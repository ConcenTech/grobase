import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/database/app_database.dart';
import '../../models/database/inverter.drift.dart';
import '../connectivity/connection_provider.dart';
import 'offline_database_service.dart';
import 'offline_storage.dart';
import 'online_database_service.dart';
import 'sync_service.dart';

abstract class DatabaseProviders {
  /// The generated Drift database.
  static final _appDb = Provider((ref) => AppDatabase());

  static final Provider<OnlineDatabaseService> onlineDatabase =
      Provider.autoDispose((ref) => OnlineDatabaseService());

  static final Provider<OfflineDatabaseService> offlineDatabase =
      Provider.autoDispose((ref) => OfflineDatabaseService(ref.watch(_appDb)));

  static final Provider<OfflineStorage> offlineStorage = Provider.autoDispose(
    (ref) => OfflineStorage.instance,
  );

  // static final secureStorage = Provider((ref) => const SecureStorage());

  static final syncService = Provider((ref) {
    final service = SyncService(
      Supabase.instance.client.auth,
      ref.watch(connectionProvider),
      ref.watch(onlineDatabase),
      ref.watch(offlineDatabase),
      (complete) => _setSyncComplete(ref, complete),
    );

    ref.onDispose(service.dispose);

    return service..init();
  });

  static final syncComplete = NotifierProvider<_SyncCompleteNotifier, bool>(
    _SyncCompleteNotifier.new,
  );

  static void _setSyncComplete(Ref ref, bool complete) {
    ref.read(syncComplete.notifier).setComplete(complete);
  }

  /// A stream of inverters from the offline database.
  static final inverters = StreamProvider(
    (ref) => ref.watch(offlineDatabase).inverters(),
  );

  /// A stream of todays inverter snapshots for the given inverter.
  static final inverterSnapshots = StreamProvider.autoDispose.family(
    (ref, Inverter inverter) =>
        ref.watch(offlineDatabase).todaysInverterSnapshots(inverter.id),
  );
}

class _SyncCompleteNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setComplete(bool value) {
    state = value;
  }

  void setIncomplete() {
    state = false;
  }
}
