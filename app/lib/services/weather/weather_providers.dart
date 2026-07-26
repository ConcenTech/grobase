import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/database/inverter.drift.dart';
import '../../models/weather/weather_data.dart';
import '../database/database_providers.dart';
import 'weather_service.dart';

class WeatherProviders {
  static final service = Provider.autoDispose(
    (ref) =>
        WeatherService(storage: ref.watch(DatabaseProviders.offlineStorage)),
  );

  static final weatherNotifier = NotifierProvider<WeatherNotifier, WeatherData>(
    WeatherNotifier.new,
  );
}

class WeatherNotifier extends Notifier<WeatherData> {
  late final WeatherService _weatherService;

  @override
  WeatherData build() {
    _weatherService = ref.read(WeatherProviders.service);
    return WeatherData.clear();
  }

  void setWeatherForInverter(Inverter inverter) {
    _weatherService
        .getCurrentWeather(inverter.location)
        .then((weather) => state = weather);
  }
}
