import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../models/database/inverter_snapshot.drift.dart';
import 'chart_dialog.dart';

class GridChartDialog extends StatefulWidget {
  const GridChartDialog({super.key, required this.snapshots});

  final List<InverterSnapshot> snapshots;

  @override
  State<GridChartDialog> createState() => _GridChartDialogState();
}

class _GridChartDialogState extends State<GridChartDialog> {
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
  void didUpdateWidget(covariant GridChartDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.snapshots != widget.snapshots) {
      _rebuildSnapshotDerived();
    }
  }

  // Formats watts as a one-decimal kW string (e.g. `-1.2`).
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
      // Signed site grid: import (Pactouser) − export (Pactogrid).
      final power = snapshot.gridImportPower - snapshot.gridExportPower;
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
    required double yAxisInterval,
    required double xAxisInterval,
    required double leftReservedSize,
    required double axisNameSize,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final touchDotColor = colorScheme.onPrimaryFixedVariant;
    final primary = colorScheme.primary;
    final axisNameStyle = chartAxisLabelStyle(context);

    return LineChartData(
      gridData: FlGridData(
        drawVerticalLine: false,
        drawHorizontalLine: true,
        horizontalInterval: yAxisInterval,
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
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
        bottomTitles: AxisTitles(
          axisNameSize: axisNameSize,
          axisNameWidget: Text('Time (Hours)', style: axisNameStyle),
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
                  style: axisNameStyle,
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
          color: primary,
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
      title: const Text('Grid'),
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
                    final leftReservedSize = chartYLabelReservedSize(context, [
                      minLabel,
                      maxLabel,
                    ]);
                    final axisNameSize = chartAxisNameSize(context);
                    final yInterval = fittingYInterval(
                      minY: _powerMinY,
                      maxY: _powerMaxY,
                      baseStep: _powerStepW,
                      plotHeight:
                          constraints.maxHeight - axisNameSize * 2,
                      labelHeight: max(
                        chartYLabelHeight(context, minLabel),
                        chartYLabelHeight(context, maxLabel),
                      ),
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
                      _buildChartData(
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
        ],
      ),
    );
  }
}
