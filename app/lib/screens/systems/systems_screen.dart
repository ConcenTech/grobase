import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/components/images/renewable_energy_site.dart';
import '../../core/components/loading_indicator.dart';
import '../../models/database/inverter.dart';
import '../../services/database/database_providers.dart';
import '../../services/inverters_provider.dart';
import 'new_system/new_system_wizard.dart';

void _showNewSystemBottomSheet(
  BuildContext context, [
  bool useRootNavigator = false,
]) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    useRootNavigator: useRootNavigator,
    builder: (context) {
      return const NewSystemWizard();
    },
  );
}

class SystemsScreen extends ConsumerWidget {
  const SystemsScreen({super.key});

  void _onSystemSelected(BuildContext context, WidgetRef ref, Inverter system) {
    ref.read(selectedInverterProvider.notifier).select(system);
    GoRouter.of(context).go('/');
    // Handle system selection, e.g., navigate to system details
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invertersRef = ref.watch(invertersProvider);

    if (invertersRef.hasValue) {
      final systems = invertersRef.requireValue;

      if (systems.isEmpty) {
        return const NoSystemsWidget();
      } else {
        return Consumer(
          builder: (context, ref2, child) {
            return SystemsListWidget(
              systems: systems,
              onSystemSelected: (system) {
                _onSystemSelected(context, ref2, system);
              },
            );
          },
        );
      }
    }

    final isLoading = invertersRef.isLoading;

    return WindTurbinesIndicator(
      status: invertersRef.isLoading ? .loading : .error,
      caption: isLoading
          ? 'Fetching your systems'
          : 'Unable to load your systems',
      details: isLoading
          ? null
          : 'Please check your internet connection and try again.',
    );
  }
}

class NewSystemButton extends ConsumerWidget {
  const NewSystemButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        // GoRouter.of(context).go('/systems/new');
        _showNewSystemBottomSheet(context);
      },
    );
  }
}

class NoSystemsWidget extends StatelessWidget {
  const NoSystemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isPortrait = constraints.maxWidth < constraints.maxHeight;
        return Center(
          child: Wrap(
            // mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            direction: isPortrait ? Axis.vertical : Axis.horizontal,
            spacing: 16.0,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const RenewableEnergySiteImage(),
              Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  const Text(
                    'No system added yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      _showNewSystemBottomSheet(context, true);
                    },
                    child: const Text('Add System'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class SystemsListWidget extends StatelessWidget {
  const SystemsListWidget({
    super.key,
    required this.systems,
    required this.onSystemSelected,
  });

  final List<Inverter> systems;
  final void Function(Inverter system) onSystemSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: systems.length,
      itemBuilder: (context, index) {
        final system = systems[index];
        return Card(
          child: ListTile(
            onTap: () => onSystemSelected(system),
            title: Text(system.displayName, style: theme.textTheme.titleMedium),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 8.0,
              children: [
                Text(system.location.name),
                Consumer(
                  builder: (context, ref, child) {
                    final latest = ref
                        .watch(DatabaseProviders.latestInverterSnapshot(system))
                        .whenOrNull(data: (data) => data);

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 12.0,
                      children: [
                        SystemDetailCard(
                          icon: MdiIcons.transmissionTower, //
                          value: latest == null
                              ? null
                              : ((latest.gridImportPower -
                                            latest.gridExportPower) /
                                        100)
                                    .toStringAsFixed(1),
                          unit: 'kW',
                        ),
                        SystemDetailCard(
                          icon: Icons.solar_power,
                          value: latest == null
                              ? null
                              : (latest.solarPower / 1000).toStringAsFixed(1),
                          unit: 'kWh',
                        ),
                        SystemDetailCard(
                          icon: Icons.battery_charging_full,
                          value: latest == null
                              ? null
                              : ((latest.chargePower - latest.dischargePower) /
                                        1000)
                                    .toStringAsFixed(1),
                          unit: 'kWh',
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            isThreeLine: true,
            trailing: system.isOnline
                ? Icon(Icons.cloud_outlined, color: theme.colorScheme.primary)
                : Icon(Icons.cloud_off, color: theme.colorScheme.error),
          ),
        );
      },
    );
  }
}

class SystemDetailCard extends StatelessWidget {
  const SystemDetailCard({
    super.key,
    required this.icon,
    required this.value,
    required this.unit,
  });

  final IconData icon;
  final String? value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme.bodyMedium!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4.0,
      children: [
        Icon(icon, color: theme.colorScheme.outline),
        Text(
          value ?? '--',
          style: textTheme.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(unit, style: textTheme),
      ],
    );
  }
}
