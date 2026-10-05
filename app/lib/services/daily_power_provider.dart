import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/database/inverter_snapshot.drift.dart';
import 'database/database_providers.dart';

const _powerStepW = 500.0;

/// Fractional hours since local midnight, for chart X values.
double _hoursOfDay(DateTime dt) {
  return dt.hour + dt.minute / 60 + dt.second / 3600;
}

final dailyPowerProvider = Provider.autoDispose.family<DailyPowerList, String>((
  ref,
  inverterId,
) {
  final snapshots =
      ref.watch(DatabaseProviders.inverterSnapshots(inverterId)).value ??
      const <InverterSnapshot>[];

  const solarPowerMin = 0.0;
  double solarPowerMax = 0.0;
  final solarChartData = <FlSpot>[];

  const homePowerMin = 0.0;
  double homePowerMax = 0.0;
  final homeChartData = <FlSpot>[];

  double gridPowerMin = 0.0;
  double gridPowerMax = 0.0;
  final gridChartData = <FlSpot>[];

  double batteryPowerMin = 0.0;
  double batteryPowerMax = 0.0;
  final batteryPowerChartData = <FlSpot>[];

  const double batterySocMin = 0.0;
  const double batterySocMax = 100.0;
  final batterySocChartData = <FlSpot>[];

  for (final snapshot in snapshots) {
    final x = _hoursOfDay(snapshot.recordedAt);
    final solarPower = snapshot.solarPower;
    final homePower = snapshot.homeLoadPower;
    final gridPower = snapshot.gridImportPower - snapshot.gridExportPower;
    final batteryPower = snapshot.chargePower - snapshot.dischargePower;
    final batterySoc = snapshot.batteryStateOfCharge;

    solarChartData.add(FlSpot(x, solarPower));
    homeChartData.add(FlSpot(x, homePower));
    gridChartData.add(FlSpot(x, gridPower));
    batteryPowerChartData.add(FlSpot(x, batteryPower));
    batterySocChartData.add(FlSpot(x, batterySoc));

    if (solarPower > solarPowerMax) solarPowerMax = solarPower;
    if (homePower > homePowerMax) homePowerMax = homePower;
    if (gridPower > gridPowerMax) gridPowerMax = gridPower;
    if (gridPower < gridPowerMin) gridPowerMin = gridPower;
    if (batteryPower > batteryPowerMax) batteryPowerMax = batteryPower;
    if (batteryPower < batteryPowerMin) batteryPowerMin = batteryPower;
  }

  if (solarChartData.isEmpty) {
    solarPowerMax = _powerStepW;
  } else {
    solarPowerMax = (solarPowerMax / _powerStepW).ceilToDouble() * _powerStepW;
    if (solarPowerMax < _powerStepW) {
      solarPowerMax = _powerStepW;
    }
  }

  if (homeChartData.isEmpty) {
    homePowerMax = _powerStepW;
  } else {
    homePowerMax = (homePowerMax / _powerStepW).ceilToDouble() * _powerStepW;
    if (homePowerMax < _powerStepW) {
      homePowerMax = _powerStepW;
    }
  }

  if (gridChartData.isEmpty) {
    gridPowerMax = _powerStepW;
    gridPowerMin = -_powerStepW;
  } else {
    gridPowerMax = (gridPowerMax / _powerStepW).ceilToDouble() * _powerStepW;
    if (gridPowerMax < _powerStepW) {
      gridPowerMax = _powerStepW;
    }
    gridPowerMin = (gridPowerMin / _powerStepW).floorToDouble() * _powerStepW;
    if (gridPowerMin > -_powerStepW) {
      gridPowerMin = -_powerStepW;
    }
  }

  if (batteryPowerChartData.isEmpty) {
    batteryPowerMax = _powerStepW;
  } else {
    batteryPowerMax =
        (batteryPowerMax / _powerStepW).ceilToDouble() * _powerStepW;
    if (batteryPowerMax < _powerStepW) {
      batteryPowerMax = _powerStepW;
    }
  }
  return DailyPowerList(
    solar: DailyPowerData(
      chartData: solarChartData,
      maxY: solarPowerMax,
      minY: solarPowerMin,
    ),
    home: DailyPowerData(
      chartData: homeChartData,
      maxY: homePowerMax,
      minY: homePowerMin,
    ),
    grid: DailyPowerData(
      chartData: gridChartData,
      maxY: gridPowerMax,
      minY: gridPowerMin,
    ),
    batteryPower: DailyPowerData(
      chartData: batteryPowerChartData,
      maxY: batteryPowerMax,
      minY: batteryPowerMin,
    ),

    batteryCharge: DailyChargeData(
      chartData: batterySocChartData,
      maxY: batterySocMax,
      minY: batterySocMin,
    ),
  );
});

class DailyPowerList {
  DailyPowerList({
    required this.solar,
    required this.home,
    required this.grid,
    required this.batteryPower,
    required this.batteryCharge,
  });

  final DailyPowerData solar;
  final DailyPowerData home;
  final DailyPowerData grid;
  final DailyPowerData batteryPower;
  final DailyChargeData batteryCharge;
}

class DailyPowerData {
  DailyPowerData({
    required this.chartData,
    required this.maxY,
    required this.minY,
  });

  final List<FlSpot> chartData;
  final double maxY;
  final double minY;

  final double baseStep = _powerStepW;
  final bool isBattery = false;
}

class DailyChargeData extends DailyPowerData {
  DailyChargeData({
    required super.chartData,
    required super.maxY,
    required super.minY,
  });

  @override
  double get baseStep => 10.0;

  @override
  bool get isBattery => true;
}
