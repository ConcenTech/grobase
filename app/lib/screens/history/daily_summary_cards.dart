import 'dart:math';

import 'package:material_ui/material_ui.dart';

import '../../core/extensions/theme_extensions.dart';
import '../../core/utils/formatters.dart';
import '../../models/database/inverter_snapshot.drift.dart';

class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({
    super.key,
    required this.snapshot,
    required this.axis,
  });

  final InverterSnapshot? snapshot;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final import = snapshot?.gridImportEnergyToday ?? 0;
    final export = snapshot?.gridExportEnergyToday ?? 0;
    final solar = snapshot?.solarEnergyToday ?? 0;
    final batteryCharge = snapshot?.chargeEnergyToday ?? 0;
    final batteryDischarge = snapshot?.dischargeEnergyToday ?? 0;
    final consumption =
        solar + import + batteryDischarge - export - batteryCharge;
    var maxKwh = [
      import,
      export,
      consumption,
      solar,
      batteryCharge,
      batteryDischarge,
    ].reduce(max);

    if (maxKwh == 0) {
      maxKwh = 1;
    }

    final cards = [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: .min,
            children: [
              _Bar(
                title: 'Solar',
                kwh: solar,
                maxKwh: maxKwh,
                color: theme.solar,
              ),
              _Bar(
                title: 'Import',
                kwh: import,
                maxKwh: maxKwh,
                color: theme.grid,
              ),

              _Bar(
                title: 'Battery Charge',
                kwh: batteryCharge,
                maxKwh: maxKwh,
                color: theme.battery,
              ),
            ],
          ),
        ),
      ),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: .min,
            children: [
              _Bar(
                title: 'Consumption',
                kwh: consumption,
                maxKwh: maxKwh,
                color: theme.consumption,
              ),
              _Bar(
                title: 'Export',
                kwh: export,
                maxKwh: maxKwh,
                color: theme.gridVariant,
              ),
              _Bar(
                title: 'Battery Discharge',
                kwh: batteryDischarge,
                maxKwh: maxKwh,
                color: theme.batteryVariant,
              ),
            ],
          ),
        ),
      ),
    ];

    final expandChildren = axis == .horizontal;

    return Flex(
      direction: axis,
      // Horizontal layout already has a finite max width from the parent.
      // Expanding each card passes a bounded width down to the bar rows.
      // Vertical layout sits in a scroll view, so it must shrink-wrap height.
      mainAxisSize: expandChildren ? .max : .min,
      children: [
        for (final card in cards)
          if (expandChildren) Expanded(child: card) else card,
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    super.key,
    required this.title,
    required this.kwh,
    required this.maxKwh,
    required this.color,
  });

  final String title;
  final double kwh;
  final double maxKwh;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final percentage = kwh / maxKwh;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(title)),
            Text(formatEnergy(kwh, forceKWh: true, decimalPlaces: 1)),
          ],
        ),
        TweenAnimationBuilder<double>(
          key: ValueKey('$title-tween-animation'),
          tween: Tween(end: percentage),
          duration: kThemeAnimationDuration,
          builder: (context, value, _) {
            return LinearProgressIndicator(
              value: value,
              color: color,
              year2023: false,
            );
          },
        ),
      ],
    );
  }
}
