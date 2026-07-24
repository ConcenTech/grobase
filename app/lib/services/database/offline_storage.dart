import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/database/inverter.drift.dart';
import '../../models/weather/weather_cache_entry.dart';

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

  static OfflineStorage get instance {
    assert(
      _instance != null,
      'OfflineStorage should be intialized with a call to [ensureInitialized]',
    );
    return _instance!;
  }

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

  static String weatherCacheKey(double latitude, double longitude) {
    final lat = latitude.toStringAsFixed(2);
    final lon = longitude.toStringAsFixed(2);
    return 'weather_cache_${lat}_$lon';
  }

  WeatherCacheEntry? getWeatherCache(String key) {
    try {
      final raw = _prefs.getString(key);
      if (raw == null) return null;
      return WeatherCacheEntry.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (e, s) {
      _logger.severe('Failed to get weather cache for $key', e, s);
      return null;
    }
  }

  Future<void> setWeatherCache(String key, WeatherCacheEntry entry) async {
    try {
      await _prefs.setString(key, jsonEncode(entry.toJson()));
    } catch (e, s) {
      _logger.severe('Failed to set weather cache for $key', e, s);
      rethrow;
    }
  }
}
