import 'package:flutter_riverpod/misc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_router.dart';
import '../../../routes/mock_app_router.dart';
import '../../connectivity/connection_manager.dart';
import '../database_providers.dart';
import '../offline_database_service.dart';
import '../online_database_service.dart';
import '../sync_service.dart';
import '../sync_state_notifier.dart';
import 'mock_online_database_service.dart';

/// Syncs [MockOnlineDatabaseService] into the local Drift DB without Supabase auth.
class MockSyncService extends SyncService {
  MockSyncService({
    required OnlineDatabaseService online,
    required OfflineDatabaseService offline,
    required SyncStateNotifier syncStateNotifier,
  }) : _syncStateNotifier = syncStateNotifier,
       super(
         GoTrueClient(),
         ConnectionManager(),
         online,
         offline,
         syncStateNotifier,
       );

  final SyncStateNotifier _syncStateNotifier;

  @override
  void init() {
    // Skip auth/session checks — pull mock online data into offline storage.
    start();
    _syncStateNotifier.setSynced();
  }

  static List<Override> overrides = [
    DatabaseProviders.onlineDatabase.overrideWithValue(
      MockOnlineDatabaseService(),
    ),
    DatabaseProviders.syncService.overrideWith((ref) {
      final service = MockSyncService(
        online: ref.watch(DatabaseProviders.onlineDatabase),
        offline: ref.watch(DatabaseProviders.offlineDatabase),
        syncStateNotifier: ref.watch(DatabaseProviders.syncState.notifier),
      );
      return service..init();
    }),
    appRouterProvider.overrideWithValue(MockAppRouter()),
  ];
}
