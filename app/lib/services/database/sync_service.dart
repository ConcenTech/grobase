import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/sync_errors.dart';
import '../../models/database/inverter.dart';
import '../../models/database/inverter_snapshot.drift.dart';
import '../connectivity/connection_manager.dart';
import 'offline_database_service.dart';
import 'online_database_service.dart';
import 'sync_state_notifier.dart';

final _logger = Logger('SyncService');

class SyncService {
  SyncService(
    this._auth,
    this._connectionManager,
    this._onlineService,
    this._offlineService,
    this._syncStateNotifier,
  );

  final GoTrueClient _auth;
  final ConnectionManager _connectionManager;
  final OnlineDatabaseService _onlineService;
  final OfflineDatabaseService _offlineService;
  final SyncStateNotifier _syncStateNotifier;

  /// Whether the sync service is currently running.
  bool _isRunning = false;

  /// Whether the device is currently online.
  bool _isOnline = true;

  /// Subscription to authentication state changes.
  StreamSubscription<AuthState>? _authSubscription;

  /// Subscription to connection status changes.
  StreamSubscription<bool>? _connectionSubscription;

  /// Re-syncs when the app returns to the foreground.
  AppLifecycleListener? _lifecycleListener;

  RealtimeChannel? _inverterChangesChannel;

  /// Per-inverter realtime subscriptions for new snapshots.
  final Map<String, RealtimeChannel> _snapshotChannels = {};

  /// Dedupes overlapping catch-up work from resume / token refresh / reconnect.
  Future<void>? _catchUpInFlight;

  /// Cancels stale delayed resume catch-up attempts.
  int _resumeGeneration = 0;

  void init() {
    _offlineService.getInverterCount().then((count) {
      if (count > 0) {
        _logger.info('Inverters found, sync complete');
        _syncStateNotifier.setSynced();
      }
    });
    // If the user is already authenticated, start the sync service.
    if (_auth.currentSession != null) {
      start();
    }

    _startSubscriptions();
  }

  /// Starts the sync service and begins listening for auth and connection changes.
  ///
  /// If the user is already authenticated, sync operations will begin immediately.
  /// The service will remain running until [stop] is called.
  void start() {
    if (_isRunning) {
      return;
    }

    _logger.info('Starting sync service');
    _isRunning = true;

    _startListeningForDbChanges();
    unawaited(_syncAndStartSnapshotListeners());
  }

  void stop() {
    if (!_isRunning) {
      return;
    }

    _logger.info('Stopping sync service');
    _isRunning = false;
    _stopListeningForDbChanges();
    _stopListeningForSnapshotChanges();
  }

  /// Retries sync after a failure by stopping and starting again.
  void retry() {
    _logger.info('Retrying sync');
    _syncStateNotifier.setSyncing();
    _restart();
  }

  DateTime _startOfDay() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> _syncAndStartSnapshotListeners() async {
    await _getInitialSyncState();
  }

  Future<void> _getInitialSyncState() async {
    try {
      final inverters = await _onlineService.inverters();
      await _offlineService.setInverters(inverters);

      // We only care abount inverters, snapshots can come later.
      _syncStateNotifier.setSynced();

      for (final inverter in inverters) {
        await _syncSnapshotsForInverter(inverter.id);
        await _ensureSnapshotListener(inverter.id);
      }
    } catch (e, s) {
      _logger.severe('Failed to get initial sync state', e, s);
      _syncStateNotifier.setError(SyncErrors.userFacingMessage(e));
    }
  }

  /// Pulls any snapshots missed while backgrounded / disconnected.
  ///
  /// Safe to call from resume, token refresh, and connectivity restore.
  Future<void> _catchUpFromServer() {
    final existing = _catchUpInFlight;
    if (existing != null) {
      return existing;
    }

    final future = _performCatchUp().whenComplete(() {
      _catchUpInFlight = null;
    });
    _catchUpInFlight = future;
    return future;
  }

  Future<void> _performCatchUp() async {
    if (!_isRunning || _auth.currentSession == null) {
      return;
    }

    _logger.info('Catching up sync from server');
    try {
      final inverters = await _onlineService.inverters();
      await _offlineService.setInverters(inverters);
      _syncStateNotifier.setSynced();

      if (_inverterChangesChannel == null) {
        _startListeningForDbChanges();
      }

      final activeIds = <String>{};
      for (final inverter in inverters) {
        activeIds.add(inverter.id);
        await _syncSnapshotsForInverter(inverter.id);
        await _ensureSnapshotListener(inverter.id);
      }

      final staleIds = _snapshotChannels.keys
          .where((id) => !activeIds.contains(id))
          .toList();
      for (final id in staleIds) {
        _removeSnapshotListener(id);
      }
    } catch (e, s) {
      _logger.warning('Catch-up sync failed', e, s);
      // Keep last known data; surface a recoverable error for the UI.
      _syncStateNotifier.setError(SyncErrors.userFacingMessage(e));
    }
  }

  Future<void> _syncSnapshotsForInverter(String inverterId) async {
    final startOfDay = _startOfDay();
    final timestamp = await _offlineService.getInverterLastSnapshotTime(
      inverterId,
    );

    final latest = timestamp == null || timestamp.isBefore(startOfDay)
        ? startOfDay
        : timestamp;
    _logger.info('Syncing snapshots for inverter $inverterId from $latest');
    final snapshots = await _onlineService.snapshots(
      inverterId: inverterId,
      start: latest,
    );
    _logger.info('New snapshots: ${snapshots.length}');
    if (snapshots.isNotEmpty) {
      await _offlineService.addSnapshots(snapshots);
    }
  }

  Future<void> _handleInverterCreated(Inverter inverter) async {
    try {
      _logger.info('Inverter created: ${inverter.id}');
      await _offlineService.addInverter(inverter);
      await _syncSnapshotsForInverter(inverter.id);
      await _ensureSnapshotListener(inverter.id);
    } catch (e, s) {
      _logger.severe('Failed to sync new inverter', e, s);
      _syncStateNotifier.setError(SyncErrors.userFacingMessage(e));
    }
  }

  Future<void> _handleInverterUpdated(Inverter inverter) async {
    _logger.info('Inverter updated: ${inverter.id}');
    try {
      await _offlineService.upsertInverter(inverter);
      await _syncSnapshotsForInverter(inverter.id);
      await _ensureSnapshotListener(inverter.id);
    } catch (e, s) {
      _logger.severe('Failed to sync updated inverter', e, s);
      _syncStateNotifier.setError(SyncErrors.userFacingMessage(e));
    }
  }

  Future<void> _handleInverterDeleted(String inverterId) async {
    try {
      _logger.info('Inverter deleted: $inverterId');
      _removeSnapshotListener(inverterId);
      await _offlineService.removeInverter(inverterId);
      await _offlineService.removeSnapshots(inverterId);
    } catch (e, s) {
      _logger.severe('Failed to sync deleted inverter', e, s);
      _syncStateNotifier.setError(SyncErrors.userFacingMessage(e));
    }
  }

  Future<void> _handleSnapshotCreated(InverterSnapshot snapshot) async {
    try {
      await _offlineService.addSnapshots([snapshot]);
    } catch (e, s) {
      _logger.severe('Failed to persist realtime snapshot', e, s);
    }
  }

  Future<void> _ensureSnapshotListener(String inverterId) async {
    if (!_isRunning || _snapshotChannels.containsKey(inverterId)) {
      return;
    }

    try {
      _logger.info('Listening for snapshot changes on $inverterId');
      final channel = await _onlineService.snapshotChanges(
        inverterId: inverterId,
        onCreate: (snapshot) => unawaited(_handleSnapshotCreated(snapshot)),
      );
      if (!_isRunning) {
        channel.unsubscribe();
        return;
      }
      _snapshotChannels[inverterId] = channel;
    } catch (e, s) {
      _logger.warning(
        'Failed to subscribe to snapshot changes for $inverterId',
        e,
        s,
      );
    }
  }

  void _removeSnapshotListener(String inverterId) {
    final channel = _snapshotChannels.remove(inverterId);
    channel?.unsubscribe();
  }

  void _stopListeningForSnapshotChanges() {
    _logger.info('Closing snapshot subscriptions');
    for (final channel in _snapshotChannels.values) {
      channel.unsubscribe();
    }
    _snapshotChannels.clear();
  }

  /// Sets up subscriptions for auth state changes and connection status.
  ///
  /// If the user is already authenticated, sync operations will begin immediately.
  void _startSubscriptions() {
    // onError is required: GoTrue emits AuthRetryableFetchException on the
    // auth stream when token refresh fails (common on resume before DNS/network
    // is ready). Without onError, Dart treats that as an unhandled exception
    // and cancels this subscription.
    _authSubscription = _auth.onAuthStateChange.listen(
      _handleAuthChange,
      onError: (Object error, StackTrace stackTrace) {
        _logger.warning('Auth state stream error', error, stackTrace);
      },
    );
    _connectionSubscription = _connectionManager.stream.listen(
      _handleConnectionChange,
    );
    _lifecycleListener = AppLifecycleListener(onResume: _onAppResumed);
  }

  void _onAppResumed() {
    if (!_isRunning || _auth.currentSession == null) {
      return;
    }

    final generation = ++_resumeGeneration;
    _logger.info('App resumed, scheduling sync catch-up');

    // Brief delay so DNS/network can come back after backgrounding before we
    // hit Supabase (avoids racing the same AuthRetryableFetchException path).
    unawaited(() async {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (generation != _resumeGeneration || !_isRunning) {
        return;
      }
      await _catchUpFromServer();
    }());
  }

  void _handleAuthChange(AuthState state) {
    switch (state.event) {
      case .signedIn:
        _logger.info('User authenticated, starting sync.');
        start();
        break;
      case .tokenRefreshed:
        // After a successful refresh (often on resume), pull anything missed
        // while the session/network was unavailable.
        _logger.info('Token refreshed, catching up sync');
        unawaited(_catchUpFromServer());
        break;
      case .signedOut:
        _logger.info('User signed out, stopping sync and clearing database');
        stop();
        _offlineService.clear();
        _syncStateNotifier.setInitial();
        break;
      default:
        break;
    }
  }

  /// Handles connection status changes.
  ///
  /// Restarts sync when connection is restored and user is authenticated.
  void _handleConnectionChange(bool isOnline) {
    if (isOnline == _isOnline) {
      return;
    }
    _isOnline = isOnline;
    if (isOnline && _isRunning && _auth.currentSession != null) {
      _logger.info('Connection restored, restarting sync');
      _restart();
    }
  }

  void _startListeningForDbChanges() async {
    if (!_isRunning) {
      return;
    }
    _logger.info('Listening for database changes.');
    try {
      _inverterChangesChannel = await _onlineService.inverterChanges(
        onCreate: (inverter) => unawaited(_handleInverterCreated(inverter)),
        onUpdate: (inverter) => unawaited(_handleInverterUpdated(inverter)),
        onDelete: (id) => unawaited(_handleInverterDeleted(id)),
      );
    } catch (e, s) {
      _logger.warning('Failed to subscribe to inverter changes', e, s);
    }
  }

  void _stopListeningForDbChanges() {
    _logger.info('Closing database subscriptions');
    _inverterChangesChannel?.unsubscribe();
    _inverterChangesChannel = null;
  }

  /// Restarts sync operations by stopping and then starting sync.
  void _restart() {
    _logger.info('Restarting sync');
    stop();
    start();
  }

  void dispose() {
    _resumeGeneration++;
    stop();
    _stopListeningForDbChanges();
    _stopListeningForSnapshotChanges();

    _lifecycleListener?.dispose();
    _lifecycleListener = null;
    _authSubscription?.cancel();
    _connectionSubscription?.cancel();
  }
}
