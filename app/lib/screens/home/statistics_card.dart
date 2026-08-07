import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

import '../../core/utils/formatters.dart';
import '../../models/database/inverter_snapshot.drift.dart';
import '../../models/weather/weather_data.dart';

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({
    super.key,
    required this.height,
    required this.maxWidth,
    required this.snapshot,
    required this.weather,
  });

  final double height;
  final double maxWidth;
  final InverterSnapshot snapshot;
  final WeatherData weather;

  @override
  Widget build(BuildContext context) {
    final children = [
      (
        'Total import',
        MdiIcons.transmissionTowerImport,
        formatPowerWithUnit(snapshot.gridImportEnergyToday),
      ),
      (
        'Total export',
        MdiIcons.transmissionTowerExport,
        formatPowerWithUnit(snapshot.gridExportEnergyToday),
      ),
      (
        'Total generation',
        MdiIcons.solarPowerVariant,
        formatPowerWithUnit(snapshot.solarEnergyToday),
      ),
      ('Sunrise', Icons.sunny, formatTime(weather.sunrise)),
      ('Sunset', Icons.nightlight, formatTime(weather.sunset)),
    ];

    return SizedBox(
      height: height,
      width: maxWidth,
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,

        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        separatorBuilder: (context, index) => const SizedBox(width: 4),
        itemBuilder: (context, index) => _Chip(
          label: children[index].$1,
          icon: children[index].$2,
          value: children[index].$3,
        ),
        itemCount: children.length,
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Chip(avatar: Icon(icon), label: Text(value)),
    );
  }
}
