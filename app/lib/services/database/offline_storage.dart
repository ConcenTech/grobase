import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/database/inverter.drift.dart';

final _logger = Logger('OfflineStorage');

class OfflineStorage {
  static OfflineStorage? _instance;

  OfflineStorage._(this._prefs);

  static Future<void> ensureInitialized() async {
    if (_instance != null) return;
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    _instance = OfflineStorage._(prefs);
  }

  static OfflineStorage get instance => _instance!;

  final SharedPreferencesWithCache _prefs;

  void setSelectedInverter(Inverter inverter) async {
    try {
      await _prefs.setString('selected_inverter', inverter.id.toString());
      _logger.info('Selected inverter set to ${inverter.id}');
    } catch (e, s) {
      _logger.severe('Failed to set selected inverter', e, s);
      rethrow;
    }
  }

  String? getSelectedInverter() {
    try {
      final selectedInverter = _prefs.getString('selected_inverter');
      if (selectedInverter == null) {
        return null;
      }
      return selectedInverter;
    } catch (e, s) {
      _logger.severe('Failed to get selected inverter', e, s);
      rethrow;
    }
  }
}
