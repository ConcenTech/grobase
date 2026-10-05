import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../core/components/animations/wind_turbines_animation.dart';
import '../../models/database/inverter_snapshot.drift.dart';
import '../../theme/theme.dart';

/// Percent of household consumption covered by solar and the battery.
///
/// Consumption is solar + import + discharge − charge − export. Import that
/// only charged the battery is removed before it is compared with consumption.
double selfSufficiencyPercent({
  required double solarEnergyToday,
  required double gridImportEnergyToday,
  required double dischargeEnergyToday,
  required double gridExportEnergyToday,
  required double chargeEnergyToday,
}) {
  final consumption =
      solarEnergyToday +
      gridImportEnergyToday +
      dischargeEnergyToday -
      chargeEnergyToday -
      gridExportEnergyToday;
  if (consumption <= 0) return 0;

  final chargeFromGrid = chargeEnergyToday > solarEnergyToday
      ? chargeEnergyToday - solarEnergyToday
      : 0.0;
  var grid = gridImportEnergyToday - chargeFromGrid;
  if (grid < 0) grid = 0;
  if (grid > consumption) grid = consumption;

  return (consumption - grid) / consumption * 100;
}

class SelfSufficiencyCard extends StatefulWidget {
  const SelfSufficiencyCard({
    super.key,
    required this.snapshot,
    required this.isLoading,
  });

  final InverterSnapshot? snapshot;
  final bool isLoading;

  @override
  State<SelfSufficiencyCard> createState() => _SelfSufficiencyCardState();
}

class _SelfSufficiencyCardState extends State<SelfSufficiencyCard> {
  late bool _isLoading;
  double _selfSufficiency = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _isLoading = widget.isLoading;
    _setSelfSufficiency();
  }

  @override
  void didUpdateWidget(SelfSufficiencyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _timer?.cancel();
    if (widget.isLoading == false) {
      _timer = Timer(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      _isLoading = true;
    }
    _setSelfSufficiency();
  }

  void _setSelfSufficiency() {
    if (widget.snapshot == null) {
      _selfSufficiency = 0;
      return;
    }

    final s = widget.snapshot!;
    _selfSufficiency = selfSufficiencyPercent(
      solarEnergyToday: s.solarEnergyToday,
      gridImportEnergyToday: s.gridImportEnergyToday,
      dischargeEnergyToday: s.dischargeEnergyToday,
      gridExportEnergyToday: s.gridExportEnergyToday,
      chargeEnergyToday: s.chargeEnergyToday,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: AppTheme.light.colorScheme.primary,
        child: Theme(
          data: AppTheme.dark,
          child: TweenAnimationBuilder<double>(
            key: const ValueKey('self-sufficiency-tween-animation'),
            tween: Tween(end: _selfSufficiency / 100),
            duration: kThemeAnimationDuration,
            builder: (context, value, _) {
              return ListTile(
                leading: CircularProgressIndicator(
                  value: value,
                  year2023: false,
                  trackGap: 0,
                  backgroundColor: AppTheme.dark.colorScheme.primaryContainer
                      .withValues(alpha: 0.5),
                ),
                trailing: _isLoading
                    ? const SizedBox(
                        width: 80,
                        height: 80,
                        child: FittedBox(
                          child: WindTurbinesAnimation(
                            status: WindTurbinesStatus.loading,
                          ),
                        ),
                      )
                    : null,
                title: _isLoading
                    ? const Text('Loading data...')
                    : Text(
                        '${(value * 100).toStringAsFixed(0)}% self-sufficient',
                      ),
                subtitle: Text(
                  style: TextStyle(
                    fontSize: 12,
                    color: _isLoading
                        ? textStyle?.color?.withValues(alpha: 0.5)
                        : null,
                  ),
                  'Battery finished the day at ${widget.snapshot?.batteryStateOfCharge.toStringAsFixed(0) ?? 0}%',
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
