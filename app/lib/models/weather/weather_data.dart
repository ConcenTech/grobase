class WeatherData {
  WeatherData({
    required this.sunrise,
    required this.sunset,
    required this.temperature,
    required this.clouds,
    required this.rain,
    required this.snow,
  });

  /// Clear skies, no precipitation. Used as the provider default.
  factory WeatherData.clear({DateTime? at}) {
    final day = at ?? DateTime.now();
    return WeatherData(
      sunrise: DateTime(day.year, day.month, day.day, 6),
      sunset: DateTime(day.year, day.month, day.day, 18),
      temperature: 20,
      clouds: 0,
      rain: 0,
      snow: 0,
    );
  }

  final DateTime sunrise;
  final DateTime sunset;

  /// Temperature in Celsius
  final double temperature;

  /// The amount of cloud cover 0-100%
  final int clouds;

  /// Rain in mm/h
  final double rain;

  /// Snow in mm/h
  final double snow;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherData &&
          sunrise == other.sunrise &&
          sunset == other.sunset &&
          temperature == other.temperature &&
          clouds == other.clouds &&
          rain == other.rain &&
          snow == other.snow;

  @override
  int get hashCode =>
      Object.hash(sunrise, sunset, temperature, clouds, rain, snow);

  /// Whether [at] falls outside the daylight window for this observation.
  ///
  /// Sunrise/sunset times-of-day are projected onto [at]'s calendar date so
  /// cached observations still resolve correctly after midnight.
  bool isNight([DateTime? at]) {
    final now = at ?? DateTime.now();
    final (rise, set) = _solarWindow(now);
    if (set.isAfter(rise)) {
      return now.isBefore(rise) || !now.isBefore(set);
    }
    // Sun sets after midnight (unusual at mid-latitudes).
    return now.isBefore(rise) && !now.isBefore(set);
  }

  /// Time until the next sunrise or sunset boundary after [at].
  Duration durationUntilNextDayNightChange([DateTime? at]) {
    final now = at ?? DateTime.now();
    final (rise, set) = _solarWindow(now);
    final DateTime next;
    if (set.isAfter(rise)) {
      if (now.isBefore(rise)) {
        next = rise;
      } else if (now.isBefore(set)) {
        next = set;
      } else {
        next = rise.add(const Duration(days: 1));
      }
    } else {
      if (now.isBefore(set)) {
        next = set;
      } else if (now.isBefore(rise)) {
        next = rise;
      } else {
        next = set.add(const Duration(days: 1));
      }
    }
    final wait = next.difference(now);
    // Avoid a zero/negative delay if we land exactly on a boundary.
    return wait < const Duration(seconds: 1)
        ? const Duration(seconds: 1)
        : wait;
  }

  (DateTime, DateTime) _solarWindow(DateTime now) {
    final rise = DateTime(
      now.year,
      now.month,
      now.day,
      sunrise.hour,
      sunrise.minute,
      sunrise.second,
    );
    final set = DateTime(
      now.year,
      now.month,
      now.day,
      sunset.hour,
      sunset.minute,
      sunset.second,
    );
    return (rise, set);
  }

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

    final cloudPct = (clouds['all'] as num?)?.toInt() ?? 0;
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
      clouds: cloudPct,
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
