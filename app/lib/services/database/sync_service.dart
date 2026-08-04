import 'dart:async';

import 'package:flutter/widgets.dart';
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

  AppLifecycleListener? _appLifecycleListener;

  /// Timer for retrying sync after a failure.
  ///
  /// Ensure it is cancelled before calling [_getInitialSyncState]
  Timer? _retryTimer;

  static const _maxRetryAttempts = 4;
  int _retryAttempts = 0;

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
    unawaited(_getInitialSyncState());
  }

  void stop() {
    if (!_isRunning) {
      return;
    }

    _logger.info('Stopping sync service');
    _isRunning = false;
    _clearRetryState();
    _stopListeningForDbChanges();
  }

  /// Retries sync after a failure by stopping and starting again.
  void restart() {
    _logger.info('Retrying sync');
    _syncStateNotifier.setSyncing();
    _restart();
  }

  void _clearRetryState() {
    _retryTimer?.cancel();
    _retryAttempts = 0;
  }

  DateTime _startOfDay() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> _getInitialSyncState() async {
    try {
      final inverters = await _onlineService.inverters();
      await _offlineService.setInverters(inverters);

      // We only care abount inverters, snapshots can come later.
      _syncStateNotifier.setSynced();
      _clearRetryState();

      for (final inverter in inverters) {
        await _syncSnapshotsForInverter(inverter.id);
      }
    } catch (e, s) {
      _scheduleRetryOrSetError(e, s);
    }
  }

  void _scheduleRetryOrSetError(Object e, StackTrace s) {
    _retryTimer?.cancel();
    if (_retryAttempts < _maxRetryAttempts && SyncErrors.isRetryable(e)) {
      _retryAttempts++;
      _retryTimer = Timer(Duration(seconds: 1 * _retryAttempts), () {
        _logger.info(
          'Retrying sync. Attempt $_retryAttempts of $_maxRetryAttempts',
        );
        _getInitialSyncState();
      });
      return;
    }

    if (_retryAttempts >= _maxRetryAttempts) {
      _logger.severe('Sync failed after $_maxRetryAttempts attempts', e, s);
    } else {
      _logger.severe('Sync failed with non-retryable error', e, s);
    }

    _clearRetryState();
    _syncStateNotifier.setError(SyncErrors.userFacingMessage(e));
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
    } catch (e, s) {
      _logger.severe('Failed to sync updated inverter', e, s);
      _syncStateNotifier.setError(SyncErrors.userFacingMessage(e));
    }
  }

  Future<void> _handleInverterDeleted(String inverterId) async {
    try {
      _logger.info('Inverter deleted: $inverterId');
      await _offlineService.removeInverter(inverterId);
      await _offlineService.removeSnapshots(inverterId);
    } catch (e, s) {
      _logger.severe('Failed to sync deleted inverter', e, s);
      _syncStateNotifier.setError(SyncErrors.userFacingMessage(e));
    }
  }

  /// Sets up subscriptions for auth state changes and connection status.
  ///
  /// If the user is already authenticated, sync operations will begin immediately.
  void _startSubscriptions() {
    _authSubscription = _auth.onAuthStateChange.listen(
      _handleAuthChange,
      onError: (e, s) => _logger.warning('Auth state change error', e, s),
    );
    _connectionSubscription = _connectionManager.stream.listen(
      _handleConnectionChange,
    );
    _appLifecycleListener = AppLifecycleListener(
      onResume: _handleLifecycleResume,
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

  void _handleLifecycleResume() {
    _logger.info('App resumed');
    _clearRetryState();
    if (_isRunning && _auth.currentSession != null) {
      _getInitialSyncState();
    }
  }

  void _startListeningForDbChanges() async {
    if (!_isRunning) {
      return;
    }
    _logger.info('Listening for database changes.');
    _inverterChangesChannel = await _onlineService.inverterChanges(
      onCreate: (inverter) => unawaited(_handleInverterCreated(inverter)),
      onUpdate: (inverter) => unawaited(_handleInverterUpdated(inverter)),
      onDelete: (id) => unawaited(_handleInverterDeleted(id)),
    );
  }

  void _stopListeningForDbChanges() {
    _logger.info('Closing database subscriptions');
    _inverterChangesChannel?.unsubscribe();
    _inverterChangesChannel = null;
  }

  /// Restarts sync operations by stopping and then starting sync.
  void _restart() {
    stop();
    start();
  }

  void dispose() {
    stop();
    _stopListeningForDbChanges();

    _authSubscription?.cancel();
    _connectionSubscription?.cancel();
    _appLifecycleListener?.dispose();
  }
}
