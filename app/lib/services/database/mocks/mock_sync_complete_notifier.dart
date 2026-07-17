import '../database_providers.dart';

class MockSyncCompleteNotifier extends SyncCompleteNotifier {
  @override
  SyncCompletion build() => const SyncReady();
}
