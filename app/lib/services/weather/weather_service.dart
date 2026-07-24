import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../../core/Env/env.dart';
import '../../models/location.dart';
import '../../models/weather/weather_cache_entry.dart';
import '../../models/weather/weather_data.dart';
import '../database/offline_storage.dart';

final _logger = Logger('WeatherService');

class WeatherService {
  WeatherService({
    Dio? dio,
    this._cacheTtl = const Duration(minutes: 30),
    required this._storage,
  }) : _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: 'https://api.openweathermap.org',
               connectTimeout: const Duration(seconds: 10),
               receiveTimeout: const Duration(seconds: 10),
             ),
           );

  final Dio _dio;
  final Duration _cacheTtl;
  final OfflineStorage _storage;
  final Map<String, Future<WeatherData>> _inFlight = {};

  /// Fetches current weather for [location], using a persistent 30-minute cache.
  Future<WeatherData> getCurrentWeather(Location location) {
    final key = OfflineStorage.weatherCacheKey(
      location.latitude,
      location.longitude,
    );

    final existing = _inFlight[key];
    if (existing != null) return existing;

    final future = _getCurrentWeather(location, key);
    _inFlight[key] = future;
    return future.whenComplete(() => _inFlight.remove(key));
  }

  Future<WeatherData> _getCurrentWeather(Location location, String key) async {
    final cached = _storage.getWeatherCache(key);
    if (cached != null &&
        DateTime.now().difference(cached.fetchedAt) < _cacheTtl) {
      _logger.fine('Weather cache hit for $key');
      return cached.data;
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/data/2.5/weather',
        queryParameters: {
          'lat': location.latitude,
          'lon': location.longitude,
          'units': 'metric',
          'appid': Env.openWeatherApiKey,
        },
      );

      final body = response.data;
      if (body == null) {
        throw Exception('OpenWeatherMap returned an empty response');
      }

      final data = WeatherData.fromOpenWeatherJson(body);
      await _storage.setWeatherCache(
        key,
        WeatherCacheEntry(fetchedAt: DateTime.now(), data: data),
      );
      return data;
    } catch (e, s) {
      _logger.severe(
        'Failed to fetch weather for '
        '${location.latitude},${location.longitude}',
        e,
        s,
      );
      rethrow;
    }
  }
}
