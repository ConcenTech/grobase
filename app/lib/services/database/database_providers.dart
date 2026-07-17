import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/database/app_database.dart';
import '../../models/database/inverter.drift.dart';
import '../connectivity/connection_provider.dart';
import 'offline_database_service.dart';
import 'offline_storage.dart';
import 'online_database_service.dart';
import 'sync_service.dart';

/// Progress of the first inverter sync used to gate the home screen.
sealed class SyncCompletion {
  const SyncCompletion();
}

/// Initial sync has not finished yet (new users start here).
class SyncPending extends SyncCompletion {
  const SyncPending();
}

/// Initial inverter sync finished successfully (list may be empty).
class SyncReady extends SyncCompletion {
  const SyncReady();
}

/// Initial sync failed after retries; UI should show an error instead of loading.
class SyncFailed extends SyncCompletion {
  const SyncFailed(this.error, [this.stackTrace]);

  final Object error;
  final StackTrace? stackTrace;
}

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
      onSyncChange: (complete) => setSyncComplete(ref, complete),
      onSyncError: (error, stackTrace) => setSyncFailed(ref, error, stackTrace),
    );

    ref.onDispose(service.dispose);

    return service..init();
  });

  static final syncComplete =
      NotifierProvider<SyncCompleteNotifier, SyncCompletion>(
        SyncCompleteNotifier.new,
      );

  static void setSyncComplete(Ref ref, bool complete) {
    ref.read(syncComplete.notifier).setComplete(complete);
  }

  static void setSyncFailed(Ref ref, Object error, [StackTrace? stackTrace]) {
    ref.read(syncComplete.notifier).setFailed(error, stackTrace);
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

  static final latestInverterSnapshot = StreamProvider.autoDispose.family(
    (ref, Inverter inverter) =>
        ref.watch(offlineDatabase).latestInverterSnapshot(inverter.id),
  );
}

class SyncCompleteNotifier extends Notifier<SyncCompletion> {
  @override
  SyncCompletion build() => const SyncPending();

  void setComplete(bool value) {
    state = value ? const SyncReady() : const SyncPending();
  }

  void setFailed(Object error, [StackTrace? stackTrace]) {
    state = SyncFailed(error, stackTrace);
  }

  void setIncomplete() {
    state = const SyncPending();
  }
}
