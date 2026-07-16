import 'package:supabase_flutter/supabase_flutter.dart';

import '../../connectivity/connection_manager.dart';
import '../offline_database_service.dart';
import '../online_database_service.dart';
import '../sync_service.dart';

/// Syncs [MockOnlineDatabaseService] into the local Drift DB without Supabase auth.
class MockSyncService extends SyncService {
  MockSyncService({
    required OnlineDatabaseService online,
    required OfflineDatabaseService offline,
    required void Function(bool complete) onSyncChange,
  }) : super(
         GoTrueClient(),
         ConnectionManager(),
         online,
         offline,
         onSyncChange,
       );

  @override
  void init() {
    // Skip auth/session checks — pull mock online data into offline storage.
    start();
  }
}
