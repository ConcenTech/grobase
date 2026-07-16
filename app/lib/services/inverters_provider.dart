import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/database/inverter.dart';
import 'database/database_providers.dart';
import 'database/offline_storage.dart';

final invertersProvider = FutureProvider.autoDispose<List<Inverter>>((
  ref,
) async {
  final db = ref.read(DatabaseProviders.onlineDatabase);
  return db.inverters();
});

final selectedInverterProvider =
    NotifierProvider<SelectedInverterNotifier, String?>(
      SelectedInverterNotifier.new,
    );

class SelectedInverterNotifier extends Notifier<String?> {
  late final OfflineStorage _offlineStorage;

  @override
  String? build() {
    _offlineStorage = ref.read(DatabaseProviders.offlineStorage);
    return _offlineStorage.getSelectedInverter();
  }

  void select(Inverter inverter) {
    state = inverter.id;
    _offlineStorage.setSelectedInverter(inverter);
  }
}
