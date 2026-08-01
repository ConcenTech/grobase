import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/components/segmented_switcher.dart';
import '../../../core/components/solar/solar_energy_data.dart';
import '../../../models/database/inverter_snapshot.drift.dart';
import 'chart_dialog.dart';

/// Dialog showing today's battery state of charge and power as a line chart.
///
/// Two views are available via [SegmentedSwitcher]:
/// * **Charge** — SoC (%) over the day, line coloured by
///   [SolarDiagramPalette.batteryColor].
/// * **Power** — signed battery power in kW (`charge − discharge`; positive
///   means charging). Y-axis bounds snap outward to 0.5 kW steps.
///
/// Chart spots and power axis bounds are derived when [snapshots] change.
/// Y-axis intervals are chosen at layout time so labels fit the plot height
/// and text scale.
class BatteryChartDialog extends StatefulWidget {
  const BatteryChartDialog({super.key, required this.snapshots});

  /// Snapshot series for the selected inverter (typically one calendar day).
  final List<InverterSnapshot> snapshots;

  @override
  State<BatteryChartDialog> createState() => _BatteryChartDialogState();
}

class _BatteryChartDialogState extends State<BatteryChartDialog> {
  /// Grid / label base step for the power view, in watts (0.5 kW).
  static const _powerStepW = 500.0;

  /// Grid / label base step for the charge view, in percent.
  static const _chargeStep = 10.0;

  _ViewMode _viewMode = _ViewMode.charge;

  /// X = hours since midnight (0–24), Y = SoC percent.
  List<FlSpot> _chargeSpots = const [];

  /// X = hours since midnight (0–24), Y = signed power in watts.
  List<FlSpot> _powerSpots = const [];

  double _powerMinY = -_powerStepW;
  double _powerMaxY = _powerStepW;

  @override
  void initState() {
    super.initState();
    _rebuildSnapshotDerived();
  }

  @override
  void didUpdateWidget(covariant BatteryChartDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.snapshots != widget.snapshots) {
      _rebuildSnapshotDerived();
    }
  }

  /// Fractional hours since local midnight, for chart X values.
  double _hoursOfDay(DateTime dt) {
    return dt.hour + dt.minute / 60 + dt.second / 3600;
  }

  /// Signed battery power in watts: positive = charging, negative = discharging.
  double _batteryPower(InverterSnapshot snapshot) {
    return snapshot.chargePower - snapshot.dischargePower;
  }

  /// Formats watts as a one-decimal kW string (e.g. `-1.2`).
  String _toKW(double watts) {
    return (watts / 1000).toStringAsFixed(1);
  }

  /// Formats fractional hours since midnight as `HH:mm` (24-hour).
  String _fmtTime(double hours) {
    final totalMinutes = (hours * 60).round();
    final hour = (totalMinutes ~/ 60) % 24;
    final minute = totalMinutes % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Rebuilds [_chargeSpots], [_powerSpots], and power Y bounds from [snapshots].
  ///
  /// Power min/max are floored/ceiled to [_powerStepW] so axis ticks stay on a
  /// 0.5 kW grid (e.g. −1.2…2.6 kW → −1.5…3.0 kW).
  void _rebuildSnapshotDerived() {
    final chargeSpots = <FlSpot>[];
    final powerSpots = <FlSpot>[];
    var minPower = double.infinity;
    var maxPower = double.negativeInfinity;

    for (final snapshot in widget.snapshots) {
      final x = _hoursOfDay(snapshot.recordedAt);
      chargeSpots.add(FlSpot(x, snapshot.batteryStateOfCharge));

      final power = _batteryPower(snapshot);
      powerSpots.add(FlSpot(x, power));
      if (power < minPower) minPower = power;
      if (power > maxPower) maxPower = power;
    }

    _chargeSpots = chargeSpots;
    _powerSpots = powerSpots;

    if (powerSpots.isEmpty) {
      _powerMinY = -_powerStepW;
      _powerMaxY = _powerStepW;
      return;
    }

    var minY = (minPower / _powerStepW).floorToDouble() * _powerStepW;
    var maxY = (maxPower / _powerStepW).ceilToDouble() * _powerStepW;
    if (minY == maxY) {
      minY -= _powerStepW;
      maxY += _powerStepW;
    }
    _powerMinY = minY;
    _powerMaxY = maxY;
  }

  LineChartData _chartDataFor({
    required double yAxisInterval,
    required double xAxisInterval,
    required double leftReservedSize,
    required double axisNameSize,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final touchDotColor = colorScheme.onPrimaryFixedVariant;
    final primary = colorScheme.primary;
    final axisNameStyle = chartAxisLabelStyle(context);

    return switch (_viewMode) {
      .charge => _buildChartData(
        minY: 0,
        maxY: 100,
        yAxisInterval: yAxisInterval,
        xAxisInterval: xAxisInterval,
        axisNameSize: axisNameSize,
        leftTitles: AxisTitles(
          axisNameSize: axisNameSize,
          axisNameWidget: Text('Charge (%)', style: axisNameStyle),
          sideTitles: SideTitles(
            reservedSize: leftReservedSize,
            interval: yAxisInterval,
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                meta: meta,
                space: chartYLabelSideTitleSpace,
                child: Text(value.toStringAsFixed(0), style: axisNameStyle),
              );
            },
          ),
        ),
        barData: LineChartBarData(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              SolarDiagramPalette.batteryColor(0),
              SolarDiagramPalette.batteryColor(0.5),
              SolarDiagramPalette.batteryColor(1),
            ],
          ),
          // Map the gradient to the full chart (0–100), not just the line's
          // bounding box, so colour tracks SoC.
          gradientArea: LineChartGradientArea.wholeChart,
          barWidth: 3,
          isStrokeCapRound: true,
          isStrokeJoinRound: true,
          dotData: const FlDotData(show: false),
          spots: _chargeSpots,
        ),
        touchDotColor: touchDotColor,
        tooltipBuilder: (spot) => LineTooltipItem(
          '${spot.y.toStringAsFixed(1)}% · ${_fmtTime(spot.x)}',
          const TextStyle(color: Colors.white),
        ),
      ),
      .power => _buildChartData(
        minY: _powerMinY,
        maxY: _powerMaxY,
        yAxisInterval: yAxisInterval,
        xAxisInterval: xAxisInterval,
        axisNameSize: axisNameSize,
        leftTitles: AxisTitles(
          axisNameSize: axisNameSize,
          axisNameWidget: Text('Power (kW)', style: axisNameStyle),
          sideTitles: SideTitles(
            reservedSize: leftReservedSize,
            interval: yAxisInterval,
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                meta: meta,
                space: chartYLabelSideTitleSpace,
                child: Text(_toKW(value), style: axisNameStyle),
              );
            },
          ),
        ),
        barData: LineChartBarData(
          // Solid colour as a 3-stop gradient so fl_chart can lerp from the
          // charge gradient without both paint styles becoming null mid-animation.
          gradient: LinearGradient(colors: [primary, primary, primary]),
          barWidth: 3,
          isStrokeCapRound: true,
          isStrokeJoinRound: true,
          dotData: const FlDotData(show: false),
          spots: _powerSpots,
        ),
        touchDotColor: touchDotColor,
        tooltipBuilder: (spot) => LineTooltipItem(
          '${_toKW(spot.y)} kW · ${_fmtTime(spot.x)}',
          const TextStyle(color: Colors.white),
        ),
      ),
    };
  }

  /// Shared chart chrome: day-long X axis, matching grid/label intervals, touch.
  LineChartData _buildChartData({
    required double minY,
    required double maxY,
    required double yAxisInterval,
    required double xAxisInterval,
    required double axisNameSize,
    required AxisTitles leftTitles,
    required LineChartBarData barData,
    required Color touchDotColor,
    required LineTooltipItem Function(LineBarSpot spot) tooltipBuilder,
  }) {
    return LineChartData(
      gridData: FlGridData(
        drawVerticalLine: false,
        drawHorizontalLine: true,
        horizontalInterval: yAxisInterval,
        verticalInterval: xAxisInterval,
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        leftTitles: leftTitles,
        bottomTitles: AxisTitles(
          axisNameSize: axisNameSize,
          axisNameWidget: Text(
            'Time (Hours)',
            style: chartAxisLabelStyle(context),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: axisNameSize,
            interval: xAxisInterval,
            getTitlesWidget: (value, meta) {
              final hour = value.round();
              return SideTitleWidget(
                meta: meta,
                space: 2,
                child: Text(
                  hour.toString().padLeft(2, '0'),
                  style: chartAxisLabelStyle(context),
                ),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      minY: minY,
      maxY: maxY,
      minX: 0, // 00:00
      maxX: 24, // 24:00
      lineTouchData: LineTouchData(
        enabled: true,
        getTouchedSpotIndicator: (barData, spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              const FlLine(),
              FlDotData(
                getDotPainter: (spot, spotIndex, pageData, ges) {
                  return FlDotCirclePainter(
                    color: touchDotColor,
                    radius: 4,
                    strokeWidth: 1,
                  );
                },
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map(tooltipBuilder).toList();
          },
        ),
      ),
      lineBarsData: [barData],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChartDialog(
      title: const Text('Battery'),
      chart: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2, 10, 8, 8),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final (minY, maxY, baseStep, labels) = switch (_viewMode) {
                      .charge => (0.0, 100.0, _chargeStep, ['0', '100']),
                      .power => (
                        _powerMinY,
                        _powerMaxY,
                        _powerStepW,
                        [_toKW(_powerMinY), _toKW(_powerMaxY)],
                      ),
                    };
                    final leftReservedSize = chartYLabelReservedSize(
                      context,
                      labels,
                    );
                    final axisNameSize = chartAxisNameSize(context);
                    final yInterval = fittingYInterval(
                      minY: minY,
                      maxY: maxY,
                      baseStep: baseStep,
                      plotHeight: constraints.maxHeight - axisNameSize * 2,
                      labelHeight: labels
                          .map((label) => chartYLabelHeight(context, label))
                          .reduce(max),
                    );

                    final xInterval = fittingXInterval(
                      plotWidth:
                          constraints.maxWidth -
                          leftReservedSize -
                          axisNameSize,
                      labelWidth: chartXLabelWidth(context),
                    );
                    return LineChart(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      _chartDataFor(
                        yAxisInterval: yInterval,
                        xAxisInterval: xInterval,
                        leftReservedSize: leftReservedSize,
                        axisNameSize: axisNameSize,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SegmentedSwitcher(
            labels: _ViewMode.values.map((e) => e.label).toList(),
            selectedIndex: _ViewMode.values.indexOf(_viewMode),
            onChanged: (index) {
              setState(() {
                _viewMode = _ViewMode.values[index];
              });
            },
          ),
        ],
      ),
    );
  }
}

/// Which battery series is shown in [BatteryChartDialog].
enum _ViewMode {
  charge('Charge'),
  power('Power');

  final String label;

  const _ViewMode(this.label);
}
