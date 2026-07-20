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

  late LineChartData _chartData;

  @override
  void initState() {
    super.initState();
    _rebuildSnapshotDerived();
  }

  @override
  didUpdateWidget(covariant GridChartDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.snapshots != widget.snapshots) {
      _rebuildSnapshotDerived();
      _rebuildChartData();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rebuildChartData();
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
      // gridActivePower is the total power from the grid, including export.
      final power = snapshot.gridActivePower;
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

  void _rebuildChartData() {
    final colorScheme = Theme.of(context).colorScheme;
    final touchDotColor = colorScheme.onPrimaryFixedVariant;
    final primary = colorScheme.primary;

    _chartData = _buildChartData(
      minY: _powerMinY,
      maxY: _powerMaxY,
      horizontalInterval: _powerStepW,
      leftTitles: AxisTitles(
        axisNameWidget: const Text('kW'),
        sideTitles: SideTitles(
          reservedSize: 35,
          interval: _powerStepW,
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return SideTitleWidget(meta: meta, child: Text(_toKW(value)));
          },
        ),
      ),
      barData: [
        LineChartBarData(
          color: primary,
          barWidth: 3,
          isStrokeCapRound: true,
          isStrokeJoinRound: true,
          dotData: const FlDotData(show: false),
          spots: _spots,
        ),
      ],
      touchDotColor: touchDotColor,
      tooltipBuilder: (spot) => LineTooltipItem(
        '${_toKW(spot.y)} kW · ${_fmtTime(spot.x)}',
        const TextStyle(color: Colors.white),
      ),
    );
  }

  /// Shared chart chrome: day-long X axis, matching grid/label intervals, touch.
  LineChartData _buildChartData({
    required double minY,
    required double maxY,
    required double horizontalInterval,
    required AxisTitles leftTitles,
    required List<LineChartBarData> barData,
    required Color touchDotColor,
    required LineTooltipItem Function(LineBarSpot spot) tooltipBuilder,
  }) {
    return LineChartData(
      gridData: FlGridData(
        drawVerticalLine: false,
        drawHorizontalLine: true,
        horizontalInterval: horizontalInterval,
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        leftTitles: leftTitles,
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
      lineBarsData: barData,
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
                child: LineChart(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  _chartData,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
