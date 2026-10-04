import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/components/solar/solar_energy_data.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../core/utils/formatters.dart';
import '../../services/daily_power_provider.dart';
import '../home/dialogs/chart_dialog.dart';

abstract class DailyPowerChart extends ConsumerWidget {
  const DailyPowerChart._({required this.inverterId});
  final String inverterId;
  const factory DailyPowerChart.solar(String inverterId) = _SolarPowerChart;
  const factory DailyPowerChart.home(String inverterId) = _HomePowerChart;
  const factory DailyPowerChart.grid(String inverterId) = _GridPowerChart;
  static Widget battery(String inverterId) => _BatteryPowerChart(inverterId);
}

class _SolarPowerChart extends DailyPowerChart {
  const _SolarPowerChart(String inverterId) : super._(inverterId: inverterId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyPowerData = ref.watch(
      dailyPowerProvider(inverterId).select((value) => value.solar),
    );
    final theme = Theme.of(context);
    return _DailyPowerChart(
      dailyPowerData: dailyPowerData,
      title: 'Solar',
      units: 'kW',
      color: theme.solar,
    );
  }
}

class _HomePowerChart extends DailyPowerChart {
  const _HomePowerChart(String inverterId) : super._(inverterId: inverterId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyPowerData = ref.watch(
      dailyPowerProvider(inverterId).select((value) => value.home),
    );
    final theme = Theme.of(context);
    return _DailyPowerChart(
      dailyPowerData: dailyPowerData,
      title: 'Consumption',
      units: 'kW',
      color: theme.consumption,
    );
  }
}

class _GridPowerChart extends DailyPowerChart {
  const _GridPowerChart(String inverterId) : super._(inverterId: inverterId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyPowerData = ref.watch(
      dailyPowerProvider(inverterId).select((value) => value.grid),
    );
    final theme = Theme.of(context);
    return _DailyPowerChart(
      dailyPowerData: dailyPowerData,
      title: 'Grid',
      units: 'kW',
      color: theme.grid,
      colorVariant: theme.gridVariant,
    );
  }
}

class _BatteryPowerChart extends ConsumerStatefulWidget {
  const _BatteryPowerChart(this.inverterId);

  final String inverterId;

  @override
  ConsumerState<_BatteryPowerChart> createState() => __BatteryPowerChartState();
}

class __BatteryPowerChartState extends ConsumerState<_BatteryPowerChart> {
  bool _showPower = false;

  void _setShowPower(bool value) {
    setState(() {
      _showPower = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(
      dailyPowerProvider(
        widget.inverterId,
      ).select((value) => (value.batteryPower, value.batteryCharge)),
    );
    final theme = Theme.of(context);

    return _DailyPowerChart(
      dailyPowerData: data.$1,
      dailyChargeData: data.$2,
      onChartTypeChanged: _setShowPower,
      showPower: _showPower,
      title: 'Battery',
      units: _showPower ? 'kW' : '%',
      color: theme.battery,
      colorVariant: theme.batteryVariant,
    );
  }
}

class _DailyPowerChart extends StatelessWidget {
  const _DailyPowerChart({
    super.key,
    required this.dailyPowerData,
    this.dailyChargeData,
    this.onChartTypeChanged,
    this.showPower = false,
    required this.title,
    required this.units,
    required this.color,
    this.colorVariant,
  }) : assert(
         (dailyChargeData != null && onChartTypeChanged != null) ||
             (dailyChargeData == null && onChartTypeChanged == null),
         'onChartTypeChanged must be provided if dailyChargeData is provided',
       );

  final DailyPowerData dailyPowerData;
  final DailyChargeData? dailyChargeData;

  final bool showPower;
  final void Function(bool value)? onChartTypeChanged;
  final String title;
  final String units;
  final Color color;

  /// The color to use when values drop below 0.
  final Color? colorVariant;

  /// [color] at and above zero, [colorVariant] below it.
  ///
  /// Three colors, matching the state-of-charge gradient, so [Gradient.lerp]
  /// can interpolate them. A fourth color would make the chart swap at the
  /// halfway point of the animation instead. The last two stops sit just
  /// either side of zero, which keeps that switch sharp.
  LinearGradient? _signedGradient(DailyPowerData data) {
    final variant = colorVariant;
    if (variant == null) {
      return null;
    }

    final span = data.maxY - data.minY;
    final zero = span == 0 ? 0.0 : (-data.minY / span).clamp(0.0, 1.0);
    final aboveZero = min(1.0, zero + 0.001);

    return LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [variant, variant, color],
      stops: [0, zero, aboveZero],
    );
  }

  DailyPowerData get dailyData =>
      !showPower && dailyChargeData != null ? dailyChargeData! : dailyPowerData;

  /// Formats watts as a one-decimal kW string (e.g. `-1.2`).
  String _toKW(double watts) {
    return (watts / 1000).toStringAsFixed(1);
  }

  String toSoc(double value) {
    return value.toStringAsFixed(0);
  }

  AxisTitles _powerSideTitles({
    required double leftReservedSize,
    required double yAxisInterval,
    required double axisNameSize,
    required TextStyle axisNameStyle,
  }) {
    return AxisTitles(
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
    );
  }

  LineTooltipItem _tooltipBuilder(LineBarSpot spot, bool isBattery) {
    if (!isBattery) {
      return LineTooltipItem(
        '${_toKW(spot.y)} kW · ${formatHours(spot.x)}',
        const TextStyle(color: Colors.white),
      );
    }
    return LineTooltipItem(
      '${spot.y.toStringAsFixed(1)}% · ${formatHours(spot.x)}',
      const TextStyle(color: Colors.white),
    );
  }

  AxisTitles _batterySideTitles({
    required double leftReservedSize,
    required double yAxisInterval,
    required double axisNameSize,
    required TextStyle axisNameStyle,
  }) {
    return AxisTitles(
      sideTitles: SideTitles(
        reservedSize: leftReservedSize,
        interval: yAxisInterval,
        showTitles: true,
        getTitlesWidget: (value, meta) {
          return SideTitleWidget(
            meta: meta,
            space: chartYLabelSideTitleSpace,
            child: Text(toSoc(value), style: axisNameStyle),
          );
        },
      ),
    );
  }

  LineChartData _buildChartData(
    BuildContext context, {
    required double yAxisInterval,
    required double xAxisInterval,
    required double leftReservedSize,
    required double axisNameSize,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final touchDotColor = colorScheme.onPrimaryFixedVariant;

    final axisNameStyle = chartAxisLabelStyle(context);

    final dailyData = this.dailyData;
    final signedGradient = _signedGradient(dailyData);

    return LineChartData(
      gridData: FlGridData(
        drawVerticalLine: false,
        drawHorizontalLine: true,
        horizontalInterval: yAxisInterval,
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        leftTitles: dailyData.isBattery
            ? _batterySideTitles(
                leftReservedSize: leftReservedSize,
                yAxisInterval: yAxisInterval,
                axisNameSize: axisNameSize,
                axisNameStyle: axisNameStyle,
              )
            : _powerSideTitles(
                leftReservedSize: leftReservedSize,
                yAxisInterval: yAxisInterval,
                axisNameSize: axisNameSize,
                axisNameStyle: axisNameStyle,
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

      minY: dailyData.minY,
      maxY: dailyData.maxY,
      minX: 0,
      maxX: 24,
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
                .map((e) => _tooltipBuilder(e, dailyData.isBattery))
                .toList();
          },
        ),
      ),
      lineBarsData: [
        if (dailyChargeData != null)
          LineChartBarData(
            gradient: dailyData.isBattery
                ? LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      SolarDiagramPalette.batteryColor(0),
                      SolarDiagramPalette.batteryColor(0.5),
                      SolarDiagramPalette.batteryColor(1),
                    ],
                  )
                : signedGradient ??
                      LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [color, color, color],
                      ),
            // Map the gradient to the full chart (0–100), not just the line's
            // bounding box, so colour tracks SoC.
            gradientArea: LineChartGradientArea.wholeChart,
            barWidth: 1,
            belowBarData: BarAreaData(
              show: dailyData.isBattery,
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  SolarDiagramPalette.batteryColor(0).withValues(alpha: 0.1),
                  SolarDiagramPalette.batteryColor(0.5).withValues(alpha: 0.1),
                  SolarDiagramPalette.batteryColor(1).withValues(alpha: 0.1),
                ],
              ),
            ),
            dotData: const FlDotData(show: false),

            spots: dailyData.chartData,
          )
        else
          LineChartBarData(
            color: signedGradient == null ? color : null,
            gradient: signedGradient,
            gradientArea: LineChartGradientArea.wholeChart,
            barWidth: 1,
            // isCurved: true,
            belowBarData: BarAreaData(
              show: dailyData.minY > -0.5,
              color: color.withValues(alpha: 0.1),
            ),
            isStrokeCapRound: false,
            isStrokeJoinRound: false,
            dotData: const FlDotData(show: false),
            spots: dailyData.chartData,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dailyData = this.dailyData;
    return AspectRatio(
      aspectRatio: 1.5,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 14, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          TextSpan(
                            text: ' $units',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (onChartTypeChanged != null)
                    Transform.scale(
                      scale: 0.75,
                      child: SegmentedButton(
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(value: 'Power', label: Text('Power')),
                          ButtonSegment(value: 'Charge', label: Text('Charge')),
                        ],
                        selected: {if (showPower) 'Power' else 'Charge'},
                        onSelectionChanged: (value) {
                          onChartTypeChanged?.call(value.contains('Power'));
                        },
                      ),
                    ),
                ],
              ),
              // Text(title, style: Theme.of(context).textTheme.titleMedium),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final minLabel = dailyData.isBattery
                        ? toSoc(0)
                        : _toKW(dailyData.minY);
                    final maxLabel = dailyData.isBattery
                        ? toSoc(100)
                        : _toKW(dailyData.maxY);

                    final leftReservedSize = chartYLabelReservedSize(context, [
                      minLabel,
                      maxLabel,
                    ]);
                    final axisNameSize = chartAxisNameSize(context);
                    final yInterval = fittingYInterval(
                      minY: dailyData.minY,
                      maxY: dailyData.maxY,
                      baseStep: dailyData.baseStep,
                      plotHeight: constraints.maxHeight - axisNameSize * 2,
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
                        context,
                        yAxisInterval: yInterval,
                        xAxisInterval: xInterval,
                        leftReservedSize: leftReservedSize,
                        axisNameSize: axisNameSize,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
