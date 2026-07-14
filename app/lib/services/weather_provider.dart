import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/components/solar/weather_background.dart';

/// Global weather condition. Defaults to [WeatherCondition.clear].
final weatherProvider =
    NotifierProvider<WeatherNotifier, WeatherCondition>(WeatherNotifier.new);

class WeatherNotifier extends Notifier<WeatherCondition> {
  @override
  WeatherCondition build() => WeatherCondition.clear;

  void setCondition(WeatherCondition condition) {
    if (state != condition) {
      state = condition;
    }
  }
}
