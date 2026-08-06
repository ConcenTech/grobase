import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/components/loading_indicator.dart';
import '../../core/components/solar/solar_energy_diagram_v2.dart';
import '../../core/extensions/list_extensions.dart';
import '../../models/database/inverter.drift.dart';
import '../../models/database/inverter_snapshot.drift.dart';
import '../../services/database/database_providers.dart';
import '../../services/inverters_provider.dart';
import '../../services/weather/weather_providers.dart';
import 'dialogs/battery_chart_dialog.dart';
import 'dialogs/grid_chart_dialog.dart';
import 'dialogs/load_chart_dialog.dart';
import 'dialogs/solar_chart_dialog.dart';
import 'energy_card.dart';
import 'statistics_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _navigateToSystems(BuildContext context) {
    if (context.mounted) {
      GoRouter.of(context).go('/systems');
    }
  }

  void _showError(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(homeProvider, (_, next) {
      if (next.isLoading) {
        return;
      }
      if (!next.hasSelectedInverter) {
        _navigateToSystems(context);
      }
    });

    final inverterRef = ref.watch(homeProvider);
    final inverter = inverterRef.value;

    AsyncValue<List<InverterSnapshot>>? snapshotsRef;
    if (inverter != null) {
      final provider = DatabaseProviders.inverterSnapshots(inverter.id);
      snapshotsRef = ref.watch(provider);

      ref.listen(provider, (_, next) {
        if (next.hasError) {
          return _showError(context, next.error.toString());
        }
      });
    }

    final snapshots = snapshotsRef?.value ?? <InverterSnapshot>[];
    final isLoading =
        inverterRef.isLoading || (snapshotsRef?.isLoading ?? false);
    final hasData = inverterRef.hasValue && (snapshotsRef?.hasValue ?? false);
    final hasError = inverterRef.hasError || (snapshotsRef?.hasError ?? false);
    final showOverlay = (isLoading && !hasData) || hasError;

    return Stack(
      fit: StackFit.expand,
      children: [
        HomeScreenContent(inverter: inverter, snapshots: snapshots),
        if (showOverlay) ...[
          const ModalBarrier(dismissible: false, color: Color(0x66000000)),
          WindTurbinesIndicator(status: isLoading ? .loading : .error),
        ],
      ],
    );
  }
}

class HomeScreenContent extends ConsumerStatefulWidget {
  const HomeScreenContent({
    super.key,
    required this.inverter,
    required this.snapshots,
  });

  final Inverter? inverter;
  final List<InverterSnapshot> snapshots;
  @override
  ConsumerState<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends ConsumerState<HomeScreenContent> {
  @override
  void initState() {
    super.initState();
    if (widget.inverter != null) {
      print(
        'setting weather for initial inverter: ${widget.inverter!.displayName}',
      );
      _setWeatherForInverter(widget.inverter!);
    }
  }

  @override
  void didUpdateWidget(HomeScreenContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.inverter?.id != oldWidget.inverter?.id &&
        widget.inverter != null) {
      print(
        'setting weather for new inverter: ${widget.inverter!.displayName}',
      );
      _setWeatherForInverter(widget.inverter!);
    }
  }

  void _setWeatherForInverter(Inverter inverter) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(WeatherProviders.weatherNotifier.notifier)
          .setWeatherForInverter(inverter);
    });
  }

  InverterSnapshot? getLatestSnapshot() {
    return widget.snapshots.isNotEmpty ? widget.snapshots.last : null;
  }

  SolarEnergyData _getLatestSolarEnergyData() {
    final snapshot = getLatestSnapshot();
    return snapshot != null
        ? SolarEnergyData.fromInverterSnapshot(snapshot)
        : const SolarEnergyData.empty();
  }

  String _lastUpdatedText(SolarEnergyData data) {
    final lastUpdated = data.lastSeenAt;

    if (lastUpdated == null) {
      return 'Offline';
    }
    final difference = DateTime.now().difference(lastUpdated);
    var relative = difference.inDays;
    var unit = 'day';
    if (relative == 0) {
      relative = difference.inHours;
      unit = 'hour';
      if (relative == 0) {
        relative = difference.inMinutes;
        unit = 'minute';
        if (relative == 0) {
          relative = difference.inSeconds;
          unit = 'second';
        }
      }
    }

    if (relative != 1) {
      unit += 's';
    }

    return 'Online. Last updated $relative $unit ago';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleTextTheme = theme.textTheme.headlineMedium!.merge(
      GoogleFonts.montserrat(fontWeight: .w500),
    );
    final subtitleTextTheme = theme.textTheme.labelSmall!;
    const statisticsCardHeight = 45.0;
    final titleTextHeight = titleTextTheme.height! * titleTextTheme.fontSize!;
    final statusTextHeight =
        subtitleTextTheme.height! * subtitleTextTheme.fontSize!;

    final solarEnergyData = _getLatestSolarEnergyData();

    // LayoutBuilder (outside the scroll view) reflects space after app bars, etc.
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableSize = Size(constraints.maxWidth, constraints.maxHeight);

        final Axis mainAxis;
        final Size houseSize;
        final Widget spacer;

        if (availableSize.width > availableSize.height) {
          mainAxis = Axis.horizontal;
          final houseHeight = min(
            availableSize.height - 16.0 - statisticsCardHeight,
            (availableSize.width * .65) / 2,
          );

          final houseWidth = houseHeight * 2;

          houseSize = Size(
            houseWidth,
            houseHeight - (statusTextHeight + titleTextHeight),
          );
          spacer = const SizedBox(width: 16);
        } else {
          mainAxis = Axis.vertical;
          houseSize = Size(availableSize.width - 16.0, 300);
          spacer = const SizedBox.shrink();
        }

        return SingleChildScrollView(
          scrollDirection: mainAxis,
          padding: const EdgeInsets.all(0),
          child: Flex(
            direction: mainAxis,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              spacer,
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox.fromSize(
                    size: houseSize,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: SolarEnergyDiagramV2(data: solarEnergyData),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      spacing: 8,
                      children: [
                        Text(
                          widget.inverter?.displayName ?? '',
                          style: titleTextTheme,
                        ),
                        if (widget.inverter != null)
                          IconButton(
                            onPressed: () => GoRouter.of(
                              context,
                            ).push('/system-details', extra: widget.inverter),
                            icon: const Icon(Icons.info),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      _lastUpdatedText(solarEnergyData),
                      style: subtitleTextTheme,
                    ),
                  ),
                  if (widget.snapshots.isNotEmpty)
                    StatisticsCard(
                      height: statisticsCardHeight,
                      maxWidth: houseSize.width,
                      snapshot: widget.snapshots.last,
                      weather: ref.watch(WeatherProviders.weatherNotifier),
                    ),
                ],
              ),
              EnergyCardContainer(
                mainAxis: mainAxis,
                children: [
                  EnergyCard.solar(
                    power: solarEnergyData.solarWatts,
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) =>
                          SolarChartDialog(snapshots: widget.snapshots),
                    ),
                  ),
                  EnergyCard.battery(
                    power: solarEnergyData.batteryWatts,
                    soc: solarEnergyData.batteryLevel,
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) =>
                          BatteryChartDialog(snapshots: widget.snapshots),
                    ),
                  ),
                  EnergyCard.grid(
                    power: solarEnergyData.gridWatts,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            GridChartDialog(snapshots: widget.snapshots),
                      );
                    },
                  ),
                  EnergyCard.load(
                    power: solarEnergyData.houseWatts,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            LoadChartDialog(snapshots: widget.snapshots),
                      );
                    },
                  ),
                ],
              ),
              spacer,
            ],
          ),
        );
      },
    );
  }
}

/// Resolves the inverter to show on the home screen.
///
/// Stays [AsyncLoading] until sync completes and inverters are available.
/// Emits `null` when the user has no inverters.
final homeProvider = Provider<AsyncValue<Inverter?>>((ref) {
  final syncState = ref.watch(DatabaseProviders.syncState);
  final hasSynced = syncState.hasSynced || syncState.hasError;

  if (!hasSynced) {
    return const AsyncLoading();
  }

  final invertersRef = ref.watch(DatabaseProviders.inverters);

  return invertersRef.when(
    loading: () => const AsyncLoading(),
    error: AsyncError.new,
    data: (inverters) {
      if (inverters.isEmpty) {
        return const AsyncData(null);
      }

      final selected = ref.watch(selectedInverterProvider);

      if (selected == null) {
        return AsyncData(inverters.first);
      }

      return AsyncData(
        inverters.firstWhereOrNull((inverter) => inverter.id == selected),
      );
    },
  );
});

extension _HomeProviderEx on AsyncValue<Inverter?> {
  bool get hasSelectedInverter => hasValue && requireValue != null;
}
