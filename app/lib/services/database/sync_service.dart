import 'dart:async';

import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/database/inverter.dart';
import '../connectivity/connection_manager.dart';
import 'offline_database_service.dart';
import 'online_database_service.dart';

final _logger = Logger('SyncService');

class SyncService {
  SyncService(
    this._auth,
    this._connectionManager,
    this._onlineService,
    this._offlineService, {
    required void Function(bool complete) onSyncChange,
    void Function(Object error, StackTrace stackTrace)? onSyncError,
  }) : _onSyncChange = onSyncChange,
       _onSyncError = onSyncError;

  final GoTrueClient _auth;
  final ConnectionManager _connectionManager;
  final OnlineDatabaseService _onlineService;
  final OfflineDatabaseService _offlineService;

  /// A callback to be called when sync state chages.
  ///
  /// If there is data in the offline database, this will be called with true.
  /// Otherwise, this will be called with true once the first sync fetches
  /// inverters — including when the list is empty (new users with no systems).
  ///
  /// When the user signs out, this will be called with false.
  final void Function(bool complete) _onSyncChange;

  /// Called when the initial sync fails after exhausting retries.
  final void Function(Object error, StackTrace stackTrace)? _onSyncError;

  /// Whether the sync service is currently running.
  bool _isRunning = false;

  /// Whether the initial inverter fetch has completed successfully.
  ///
  /// New users have no offline cache, so home stays loading until this is true.
  bool _hasCompletedInitialSync = false;

  /// Consecutive failed initial sync attempts since the last success/sign-out.
  int _initialSyncAttempts = 0;

  static const int _maxInitialSyncAttempts = 5;

  /// Whether the device is currently online.
  bool _isOnline = true;

  /// Subscription to authentication state changes.
  StreamSubscription<AuthState>? _authSubscription;

  /// Subscription to connection status changes.
  StreamSubscription<bool>? _connectionSubscription;

  /// Retries the initial sync after a failure without requiring a reconnect.
  Timer? _initialSyncRetryTimer;

  RealtimeChannel? _inverterChangesChannel;
  final Map<String, RealtimeChannel> _snapshotChangesChannels = {};

  void init() {
    _offlineService.getInverterCount().then((count) {
      if (count > 0) {
        _logger.info('Inverters found, sync complete');
        _hasCompletedInitialSync = true;
        _onSyncChange(true);
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
    _cancelInitialSyncRetry();

    _startListeningForDbChanges();
    unawaited(_syncAndStartSnapshotListeners());
  }

  void stop() {
    if (!_isRunning) {
      return;
    }

    _logger.info('Stopping sync service');
    _isRunning = false;
    _cancelInitialSyncRetry();
    _stopListeningForDbChanges();
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

      // Mark complete for new users too — an empty inverter list is a valid
      // first sync result and must unblock home/systems navigation.
      _hasCompletedInitialSync = true;
      _initialSyncAttempts = 0;
      _onSyncChange(true);

      final startOfDay = _startOfDay();

      for (final inverter in inverters) {
        await _syncSnapshotsForInverter(inverter.id);
        if (_isRunning) {
          _startSnapshotListener(inverter.id, startOfDay);
        }
      }
    } catch (e, s) {
      _logger.severe('Failed to get initial sync state', e, s);
      _handleInitialSyncFailure(e, s);
    }
  }

  /// After a failed first sync, allow [start] to run again and schedule a retry.
  ///
  /// Without this, `_isRunning` stays true forever, `start()` becomes a no-op,
  /// and new users remain stuck with syncComplete pending (permanent loading).
  void _handleInitialSyncFailure(Object error, StackTrace stackTrace) {
    if (_hasCompletedInitialSync) {
      return;
    }

    _initialSyncAttempts++;
    _isRunning = false;
    _stopListeningForDbChanges();

    if (_initialSyncAttempts >= _maxInitialSyncAttempts) {
      _logger.severe(
        'Initial sync failed after $_initialSyncAttempts attempts',
        error,
        stackTrace,
      );
      _onSyncError?.call(error, stackTrace);
      return;
    }

    _scheduleInitialSyncRetry();
  }

  void _scheduleInitialSyncRetry() {
    if (_hasCompletedInitialSync || _auth.currentSession == null) {
      return;
    }

    _cancelInitialSyncRetry();
    _logger.info(
      'Scheduling initial sync retry '
      '(attempt ${_initialSyncAttempts + 1}/$_maxInitialSyncAttempts)',
    );
    _initialSyncRetryTimer = Timer(const Duration(seconds: 3), () {
      if (_hasCompletedInitialSync || _auth.currentSession == null) {
        return;
      }
      start();
    });
  }

  void _cancelInitialSyncRetry() {
    _initialSyncRetryTimer?.cancel();
    _initialSyncRetryTimer = null;
  }

  Future<void> _syncSnapshotsForInverter(String inverterId) async {
    final startOfDay = _startOfDay();
    final timestamp = await _offlineService.getInverterLastSnapshotTime(
      inverterId,
    );

    final latest = timestamp == null || timestamp.isBefore(startOfDay)
        ? startOfDay
        : timestamp;

    final snapshots = await _onlineService.snapshots(
      inverterId: inverterId,
      start: latest,
    );

    if (snapshots.isNotEmpty) {
      await _offlineService.addSnapshots(snapshots);
    }
  }

  /// Starts listening for snapshot changes for a given inverter.
  void _startSnapshotListener(String inverterId, DateTime start) {
    if (!_isRunning || _snapshotChangesChannels.containsKey(inverterId)) {
      return;
    }

    _snapshotChangesChannels[inverterId] = _onlineService.snapshotChanges(
      inverterId: inverterId,
      start: start,
      onCreate: (snapshot) => _offlineService.addSnapshots([snapshot]),
      // onDelete: (id) => _offlineService.removeSnapshot(id),
    );
  }

  /// Stops listening for snapshot changes for a given inverter.
  void _stopSnapshotListener(String inverterId) {
    _snapshotChangesChannels.remove(inverterId)?.unsubscribe();
  }

  Future<void> _handleInverterCreated(Inverter inverter) async {
    try {
      await _offlineService.addInverter(inverter);
      // Realtime create can arrive before/without a successful initial fetch.
      // Unblock home for new users once we have local inverter data.
      if (!_hasCompletedInitialSync) {
        _hasCompletedInitialSync = true;
        _initialSyncAttempts = 0;
        _onSyncChange(true);
        _cancelInitialSyncRetry();
      }
      await _syncSnapshotsForInverter(inverter.id);
      if (_isRunning) {
        _startSnapshotListener(inverter.id, _startOfDay());
      }
    } catch (e, s) {
      _logger.severe('Failed to sync new inverter', e, s);
    }
  }

  /// Sets up subscriptions for auth state changes and connection status.
  ///
  /// If the user is already authenticated, sync operations will begin immediately.
  void _startSubscriptions() {
    _authSubscription = _auth.onAuthStateChange.listen(
      _handleAuthChange,
      onError: (Object e, StackTrace s) {
        // Required by supabase_flutter — network/token refresh errors are
        // emitted on the stream and would otherwise become unhandled zone errors.
        _logger.warning('Auth state change stream error', e, s);
      },
    );
    _connectionSubscription = _connectionManager.stream.listen(
      _handleConnectionChange,
    );
  }

  void _handleAuthChange(AuthState state) {
    switch (state.event) {
      case AuthChangeEvent.initialSession:
      case AuthChangeEvent.signedIn:
        if (state.session == null) {
          break;
        }
        _logger.info('User authenticated, starting sync.');
        start();
        break;
      case AuthChangeEvent.signedOut:
        _logger.info('User signed out, stopping sync and clearing database');
        stop();
        _hasCompletedInitialSync = false;
        _initialSyncAttempts = 0;
        unawaited(_offlineService.clear());
        _onSyncChange(false);
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
    if (isOnline && _auth.currentSession != null) {
      _logger.info('Connection restored, restarting sync');
      // Give a fresh retry budget when connectivity returns.
      _initialSyncAttempts = 0;
      if (_isRunning) {
        _restart();
      } else if (!_hasCompletedInitialSync) {
        // Initial sync may have failed while "running" and cleared _isRunning.
        start();
      }
    }
  }

  void _startListeningForDbChanges() {
    if (!_isRunning) {
      return;
    }
    _logger.info('Listening for database changes.');
    _inverterChangesChannel = _onlineService.inverterChanges(
      onCreate: (inverter) => unawaited(_handleInverterCreated(inverter)),
      onUpdate: (inverter) => _offlineService.upsertInverter(inverter),
      onDelete: (id) {
        _stopSnapshotListener(id);
        _offlineService.removeInverter(id);
      },
    );
  }

  void _stopListeningForDbChanges() {
    _logger.info('Closing database subscriptions');
    _inverterChangesChannel?.unsubscribe();
    _inverterChangesChannel = null;
    for (final channel in _snapshotChangesChannels.values) {
      channel.unsubscribe();
    }
    _snapshotChangesChannels.clear();
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
