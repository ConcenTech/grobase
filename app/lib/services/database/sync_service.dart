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
    this._offlineService,
    this._onSyncChange,
  );

  final GoTrueClient _auth;
  final ConnectionManager _connectionManager;
  final OnlineDatabaseService _onlineService;
  final OfflineDatabaseService _offlineService;

  /// A callback to be called when sync state chages.
  ///
  /// If there is data in the offline database, this will be called with true.
  /// Otherwise, this will be called with true once the first sync fetches
  /// inverters
  ///
  /// When the user signs out, this will be called with false.
  final void Function(bool complete) _onSyncChange;

  /// Whether the sync service is currently running.
  bool _isRunning = false;

  /// Whether the device is currently online.
  bool _isOnline = true;

  /// Subscription to authentication state changes.
  StreamSubscription<AuthState>? _authSubscription;

  /// Subscription to connection status changes.
  StreamSubscription<bool>? _connectionSubscription;

  RealtimeChannel? _inverterChangesChannel;
  final Map<String, RealtimeChannel> _snapshotChangesChannels = {};

  void init() {
    _offlineService.getInverterCount().then((count) {
      if (count > 0) {
        _logger.info('Inverters found, sync complete');
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
