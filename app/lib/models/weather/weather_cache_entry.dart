import 'weather_data.dart';

class WeatherCacheEntry {
  const WeatherCacheEntry({required this.fetchedAt, required this.data});

  final DateTime fetchedAt;
  final WeatherData data;

  factory WeatherCacheEntry.fromJson(Map<String, dynamic> json) {
    return WeatherCacheEntry(
      fetchedAt: DateTime.parse(json['fetchedAt'] as String),
      data: WeatherData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'fetchedAt': fetchedAt.toIso8601String(),
    'data': data.toJson(),
  };
}
