import 'dart:async';

import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/sync_errors.dart';
import '../../models/database/inverter.dart';
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

  RealtimeChannel? _inverterChangesChannel;

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
    unawaited(_syncInitialState());
  }

  void stop() {
    if (!_isRunning) {
      return;
    }

    _logger.info('Stopping sync service');
    _isRunning = false;
    _stopListeningForDbChanges();
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

  Future<void> _syncInitialState() async {
    try {
      final inverters = await _onlineService.inverters();
      await _offlineService.setInverters(inverters);

      // Pull today's snapshots before marking synced so the home UI has
      // current data on launch.
      for (final inverter in inverters) {
        await _syncSnapshotsForInverter(inverter.id);
      }

      _syncStateNotifier.setSynced();
    } catch (e, s) {
      _logger.severe('Failed to get initial sync state', e, s);
      _syncStateNotifier.setError(SyncErrors.userFacingMessage(e));
    }
  }

  /// Fetches snapshots from the later of start-of-day and the newest offline
  /// snapshot. New gateway uploads bump inverter `last_seen_at`, which triggers
  /// this via [_handleInverterUpdated] instead of a snapshot realtime channel.
  Future<void> _syncSnapshotsForInverter(String inverterId) async {
    final startOfDay = _startOfDay();
    final latestOffline = await _offlineService.getInverterLastSnapshotTime(
      inverterId,
    );

    final start = latestOffline == null || latestOffline.isBefore(startOfDay)
        ? startOfDay
        : latestOffline;

    final snapshots = await _onlineService.snapshots(
      inverterId: inverterId,
      start: start,
    );

    if (snapshots.isNotEmpty) {
      await _offlineService.upsertSnapshots(snapshots);
    }
  }

  Future<void> _handleInverterCreated(Inverter inverter) async {
    try {
      await _offlineService.addInverter(inverter);
      await _syncSnapshotsForInverter(inverter.id);
    } catch (e, s) {
      _logger.severe('Failed to sync new inverter', e, s);
      _syncStateNotifier.setError(SyncErrors.userFacingMessage(e));
    }
  }

  Future<void> _handleInverterUpdated(Inverter inverter) async {
    try {
      await _offlineService.upsertInverter(inverter);
      await _syncSnapshotsForInverter(inverter.id);
    } catch (e, s) {
      _logger.severe('Failed to sync inverter update', e, s);
      _syncStateNotifier.setError(SyncErrors.userFacingMessage(e));
    }
  }

  /// Sets up subscriptions for auth state changes and connection status.
  ///
  /// If the user is already authenticated, sync operations will begin immediately.
  void _startSubscriptions() {
    _authSubscription = _auth.onAuthStateChange.listen(_handleAuthChange);
    _connectionSubscription = _connectionManager.stream.listen(
      _handleConnectionChange,
    );
  }

  void _handleAuthChange(AuthState state) {
    switch (state.event) {
      case .signedIn:
        _logger.info('User authenticated, starting sync.');
        start();
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

  void _startListeningForDbChanges() {
    if (!_isRunning) {
      return;
    }
    _logger.info('Listening for database changes.');
    _inverterChangesChannel = _onlineService.inverterChanges(
      onCreate: (inverter) => unawaited(_handleInverterCreated(inverter)),
      onUpdate: (inverter) => unawaited(_handleInverterUpdated(inverter)),
      onDelete: (id) => _offlineService.removeInverter(id),
    );
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
    stop();
    _stopListeningForDbChanges();

    _authSubscription?.cancel();
    _connectionSubscription?.cancel();
  }
}
