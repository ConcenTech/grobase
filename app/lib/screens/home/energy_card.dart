import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class EnergyCardContainer extends StatelessWidget {
  const EnergyCardContainer({
    super.key,
    required this.children,
    required this.mainAxis,
  });

  final List<Widget> children;
  final Axis mainAxis;

  /// Target card width in logical pixels — kept consistent across orientations.
  static const cardWidth = 200.0;

  /// width / height
  static const cardAspectRatio = 1.3;

  static const _cardHeight = cardWidth / cardAspectRatio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const padding = EdgeInsets.all(6);

        if (mainAxis == Axis.horizontal) {
          // Landscape: horizontal grid. childAspectRatio is height/width here.
          final maxHeight = constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : MediaQuery.sizeOf(context).height;
          final crossAxisCount = (maxHeight / _cardHeight).floor().clamp(
            1,
            children.length,
          );

          return GridView.count(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            primary: false,
            padding: padding,
            crossAxisCount: crossAxisCount,
            childAspectRatio: _cardHeight / cardWidth,
            children: children,
          );
        }

        // Portrait: vertical grid. childAspectRatio is width/height here.
        return GridView(
          shrinkWrap: true,
          primary: false,
          padding: padding,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: cardWidth,
            childAspectRatio: cardAspectRatio,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          children: children,
        );
      },
    );
  }
}

class EnergyCard extends StatelessWidget {
  const EnergyCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.power,
    required this.icon,
    required this.onTap,
  });

  const EnergyCard.solar({super.key, required this.power, required this.onTap})
    : title = 'Solar',
      subtitle = null,
      icon = Icons.solar_power;

  EnergyCard.battery({
    super.key,
    required this.power,
    required int soc,
    required this.onTap,
  }) : title = 'Battery',
       subtitle = _fmtBattery(power, soc),
       icon = Icons.battery_charging_full;

  EnergyCard.grid({super.key, required this.power, required this.onTap})
    : title = 'Grid',
      subtitle = _fmtGrid(power),
      icon = MdiIcons.transmissionTower;

  const EnergyCard.load({super.key, required this.power, required this.onTap})
    : title = 'Consumption',
      subtitle = null,
      icon = MdiIcons.home;

  final String title;
  final String? subtitle;
  final double power;
  final IconData icon;
  final VoidCallback? onTap;

  static String _fmtGrid(double power) {
    return switch (power) {
      <= -1 => 'Exporting',
      >= 1 => 'Importing',
      _ => 'Idle',
    };
  }

  static String _fmtBattery(double power, int soc) {
    if (power < 1 && power > -1) {
      return '$soc%';
    }
    final status = power.isNegative ? 'Discharging' : 'Charging';
    return '$status $soc%';
  }

  String _fmtPower(double value) {
    final power = value.abs();
    if (power < 1000) {
      return power.toStringAsFixed(0);
    }
    return (power / 1000).toStringAsFixed(1);
  }

  String _fmtUnit(double value) {
    final power = value.abs();
    if (power < 1000) {
      return 'W';
    }
    return 'kW';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor = theme.colorScheme.onInverseSurface;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 250,
        minWidth: 150,
        minHeight: 90,
      ),
      child: Card(
        color: theme.colorScheme.primaryFixedDim,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          // Default splash is primary-tinted and nearly invisible on
          // primaryFixedDim — use the label color so press feedback reads clearly.
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return textColor.withValues(alpha: 0.22);
            }
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return textColor.withValues(alpha: 0.1);
            }
            return null;
          }),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(icon, color: textColor),
                    const SizedBox(width: 4),
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textColor,
                    ),
                  ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.bottomLeft,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: _fmtPower(power),
                              style: theme.textTheme.displayLarge?.copyWith(
                                fontSize: 58,
                                color: textColor,
                              ),
                            ),
                            TextSpan(
                              text: _fmtUnit(power),
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
