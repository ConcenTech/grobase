import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/database/app_database.dart';
import '../connectivity/connection_provider.dart';
import '../selected_date_time_notifier.dart';
import 'offline_database_service.dart';
import 'offline_storage.dart';
import 'online_database_service.dart';
import 'sync_service.dart';
import 'sync_state_notifier.dart';

abstract class DatabaseProviders {
  /// The generated Drift database.
  static final appDb = Provider((ref) => AppDatabase());

  static final Provider<OnlineDatabaseService> onlineDatabase =
      Provider.autoDispose((ref) => OnlineDatabaseService());

  static final Provider<OfflineDatabaseService> offlineDatabase =
      Provider.autoDispose((ref) => OfflineDatabaseService(ref.watch(appDb)));

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
      ref.watch(syncState.notifier),
    );

    ref.onDispose(service.dispose);

    return service..init();
  });

  static final syncState =
      NotifierProvider.autoDispose<SyncStateNotifier, SyncState>(
        SyncStateNotifier.new,
      );

  /// A stream of inverters from the offline database.
  static final inverters = StreamProvider(
    (ref) => ref.watch(offlineDatabase).inverters(),
  );

  /// A stream of inverter snapshots for the given inverter based on the
  /// selected date in [selectedDateTimeProvider].
  static final inverterSnapshots = StreamProvider.autoDispose.family(
    // User String inverterId instead of inverter object to avoid provider
    // rebuilds when the inverter object changes.
    (ref, String inverterId) {
      final selectedDate = ref.watch(selectedDateTimeProvider);
      ref.read(syncService).syncSelectedDateTime(selectedDate, inverterId);
      return ref
          .watch(offlineDatabase)
          .inverterSnapshots(inverterId, selectedDate);
    },
  );

  static final latestInverterSnapshot = StreamProvider.autoDispose.family(
    // Same issue as above.
    (ref, String inverterId) =>
        ref.watch(offlineDatabase).latestInverterSnapshot(inverterId),
  );

  static final inverterMembers = FutureProvider.autoDispose.family(
    (ref, String inverterId) =>
        ref.watch(onlineDatabase).inverterMembers(inverterId),
  );
}

class SyncCompleteNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setComplete(bool value) {
    state = value;
  }

  void setIncomplete() {
    state = false;
  }
}
