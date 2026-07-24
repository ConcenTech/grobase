class WeatherData {
  WeatherData({
    required this.sunrise,
    required this.sunset,
    required this.temperature,
    required this.clouds,
    required this.rain,
    required this.snow,
  });

  final DateTime sunrise;
  final DateTime sunset;

  /// Temperature in Celsius
  final double temperature;

  /// The amount of cloud cover [0-9]
  final int clouds;

  /// Rain in mm/h
  final double rain;

  /// Snow in mm/h
  final double snow;

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      sunrise: DateTime.parse(json['sunrise'] as String),
      sunset: DateTime.parse(json['sunset'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      clouds: json['clouds'] as int,
      rain: (json['rain'] as num).toDouble(),
      snow: (json['snow'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'sunrise': sunrise.toIso8601String(),
    'sunset': sunset.toIso8601String(),
    'temperature': temperature,
    'clouds': clouds,
    'rain': rain,
    'snow': snow,
  };

  /// Maps an OpenWeatherMap Current Weather API response.
  factory WeatherData.fromOpenWeatherJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final clouds = json['clouds'] as Map<String, dynamic>? ?? const {};
    final sys = json['sys'] as Map<String, dynamic>;
    final rainMap = json['rain'] as Map<String, dynamic>?;
    final snowMap = json['snow'] as Map<String, dynamic>?;

    final cloudPct = (clouds['all'] as num?)?.toDouble() ?? 0;
    final sunriseSec = sys['sunrise'] as int;
    final sunsetSec = sys['sunset'] as int;

    return WeatherData(
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        sunriseSec * 1000,
        isUtc: true,
      ).toLocal(),
      sunset: DateTime.fromMillisecondsSinceEpoch(
        sunsetSec * 1000,
        isUtc: true,
      ).toLocal(),
      temperature: (main['temp'] as num).toDouble(),
      clouds: ((cloudPct / 100) * 9).round().clamp(0, 9),
      rain: _precipMmPerHour(rainMap),
      snow: _precipMmPerHour(snowMap),
    );
  }

  static double _precipMmPerHour(Map<String, dynamic>? precip) {
    if (precip == null) return 0;
    final oneHour = precip['1h'];
    if (oneHour is num) return oneHour.toDouble();
    final threeHour = precip['3h'];
    if (threeHour is num) return threeHour.toDouble();
    return 0;
  }
}
