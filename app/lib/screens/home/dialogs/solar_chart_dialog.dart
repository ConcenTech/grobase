import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../models/database/inverter_snapshot.drift.dart';
import 'chart_dialog.dart';

class SolarChartDialog extends StatefulWidget {
  const SolarChartDialog({super.key, required this.snapshots});

  final List<InverterSnapshot> snapshots;

  @override
  State<SolarChartDialog> createState() => _SolarChartDialogState();
}

class _SolarChartDialogState extends State<SolarChartDialog> {
  static const _powerStepW = 500.0;

  List<FlSpot> _spots = [];

  double _powerMinY = -_powerStepW;
  double _powerMaxY = _powerStepW;

  @override
  void initState() {
    super.initState();
    _rebuildSnapshotDerived();
  }

  @override
  void didUpdateWidget(covariant SolarChartDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.snapshots != widget.snapshots) {
      _rebuildSnapshotDerived();
    }
  }

  /// Formats watts as a one-decimal kW string (e.g. `-1.2`).
  String _toKW(double watts) {
    return (watts / 1000).toStringAsFixed(1);
  }

  /// Fractional hours since local midnight, for chart X values.
  double _hoursOfDay(DateTime dt) {
    return dt.hour + dt.minute / 60 + dt.second / 3600;
  }

  /// Formats fractional hours since midnight as `HH:mm` (24-hour).
  String _fmtTime(double hours) {
    final totalMinutes = (hours * 60).round();
    final hour = (totalMinutes ~/ 60) % 24;
    final minute = totalMinutes % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  void _rebuildSnapshotDerived() {
    final spots = <FlSpot>[];

    var minPower = double.infinity;
    var maxPower = double.negativeInfinity;

    for (final snapshot in widget.snapshots) {
      final x = _hoursOfDay(snapshot.recordedAt);
      final power = snapshot.solarPower;
      spots.add(FlSpot(x, power));
      if (power < minPower) minPower = power;
      if (power > maxPower) maxPower = power;
    }
    _spots = spots;

    if (spots.isEmpty) {
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

  LineChartData _buildChartData({
    required double horizontalInterval,
    required double leftReservedSize,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final touchDotColor = colorScheme.onPrimaryFixedVariant;
    final primary = colorScheme.primary;

    return LineChartData(
      gridData: FlGridData(
        drawVerticalLine: false,
        drawHorizontalLine: true,
        horizontalInterval: horizontalInterval,
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          axisNameWidget: const Text('kW'),
          sideTitles: SideTitles(
            reservedSize: leftReservedSize,
            interval: horizontalInterval,
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(meta: meta, child: Text(_toKW(value)));
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 12,
            getTitlesWidget: (value, meta) {
              final hour = value.round();
              return SideTitleWidget(
                meta: meta,
                fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                space: 2,
                child: Text('${hour.toString().padLeft(2, '0')}:00'),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      minY: _powerMinY,
      maxY: _powerMaxY,
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
            return touchedSpots
                .map(
                  (spot) => LineTooltipItem(
                    '${_toKW(spot.y)} kW · ${_fmtTime(spot.x)}',
                    const TextStyle(color: Colors.white),
                  ),
                )
                .toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          // Solid colour as a 3-stop gradient so fl_chart can lerp from the
          // charge gradient without both paint styles becoming null mid-animation.
          gradient: LinearGradient(colors: [primary, primary, primary]),
          barWidth: 3,
          isStrokeCapRound: true,
          isStrokeJoinRound: true,
          dotData: const FlDotData(show: false),
          spots: _spots,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChartDialog(
      title: const Text('Solar'),
      chart: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2, 10, 8, 8),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final minLabel = _toKW(_powerMinY);
                    final maxLabel = _toKW(_powerMaxY);
                    final interval = fittingYInterval(
                      minY: _powerMinY,
                      maxY: _powerMaxY,
                      baseStep: _powerStepW,
                      plotHeight:
                          constraints.maxHeight - chartBottomTitlesReserved,
                      labelHeight: max(
                        chartYLabelHeight(context, minLabel),
                        chartYLabelHeight(context, maxLabel),
                      ),
                    );
                    return LineChart(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      _buildChartData(
                        horizontalInterval: interval,
                        leftReservedSize: chartYLabelReservedSize(context, [
                          minLabel,
                          maxLabel,
                        ]),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
