import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/components/date_card.dart';
import '../../core/components/inverter_title_text.dart';
import '../../core/components/scaffold/app_scaffold.dart';
import '../../models/database/inverter.dart';
import '../../models/database/inverter_snapshot.drift.dart';
import '../../services/database/database_providers.dart';
import 'daily_power_chart.dart';
import 'daily_summary_cards.dart';
import 'self_sufficiency_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key, required this.inverter});

  final Inverter inverter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshots =
        ref
            .watch(DatabaseProviders.inverterSnapshots(inverter.id)) //
            .value ??
        [];
    final isLoadingSnapshots = ref
        .watch(DatabaseProviders.syncStateForDate)
        .isSyncing;
    return HistoryScreenContent(
      inverter: inverter,
      snapshots: snapshots,
      isLoadingSnapshots: isLoadingSnapshots,
    );
  }
}

class HistoryScreenContent extends StatefulWidget {
  const HistoryScreenContent({
    required this.inverter,
    required this.snapshots,
    required this.isLoadingSnapshots,
    super.key,
  });

  final Inverter inverter;
  final bool isLoadingSnapshots;
  final List<InverterSnapshot> snapshots;

  @override
  State<HistoryScreenContent> createState() => _HistoryScreenContentState();
}

class _HistoryScreenContentState extends State<HistoryScreenContent> {
  List<InverterSnapshot> _snapshots = [];
  InverterSnapshot? _lastSnapshot;
  bool _isLoadingSnapshots = true;

  @override
  void initState() {
    super.initState();
    _snapshots = widget.snapshots;
    _isLoadingSnapshots = widget.isLoadingSnapshots;
    _setLastSnapshot();
  }

  @override
  void didUpdateWidget(HistoryScreenContent oldWidget) {
    // Keep previous state while loading new snapshots to avoid flickering.
    if (widget.isLoadingSnapshots) {
      _isLoadingSnapshots = true;
    } else {
      _isLoadingSnapshots = false;
      _snapshots = widget.snapshots;
      _setLastSnapshot();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _setLastSnapshot() {
    _lastSnapshot = _snapshots.isEmpty
        ? null
        // The last snapshot is sometimes empty. The inverter may reset totals before midnight.
        : _snapshots.lastWhere(
            (e) =>
                e.solarEnergyToday > 0 ||
                e.gridImportEnergyToday > 0 ||
                e.gridExportEnergyToday > 0 ||
                e.chargeEnergyToday > 0 ||
                e.dischargeEnergyToday > 0,
            orElse: () => _snapshots.last,
          );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      body: Theme(
        data: theme.copyWith(
          cardTheme: theme.cardTheme.copyWith(
            color: theme.brightness == .dark
                ? theme.colorScheme.surfaceContainerLow.withValues(alpha: .1)
                : null,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth > constraints.maxHeight;

            final title = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () => GoRouter.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
                Flexible(
                  child: InverterTitleText(name: widget.inverter.displayName),
                ),
              ],
            );

            final dateButtons = DateCard(minDate: widget.inverter.createdAt);

            final selfSufficiencyCard = SelfSufficiencyCard(
              snapshot: _lastSnapshot,
              isLoading: _isLoadingSnapshots,
            );

            final solarPowerChart = DailyPowerChart.solar(widget.inverter.id);
            final homePowerChart = DailyPowerChart.home(widget.inverter.id);
            final gridPowerChart = DailyPowerChart.grid(widget.inverter.id);
            final batteryPowerChart = DailyPowerChart.battery(
              widget.inverter.id,
            );

            final List<Widget> children = [];

            if (isLandscape) {
              children.addAll([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: title),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: dateButtons,
                    ),
                  ],
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxHeight = constraints.maxHeight;
                      final powerCardConstraints = BoxConstraints(
                        maxHeight: maxHeight > 600 ? maxHeight / 2 : maxHeight,
                      );

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          direction: Axis.vertical,
                          children: [
                            ConstrainedBox(
                              constraints: powerCardConstraints,
                              child: AspectRatio(
                                aspectRatio: 1.5,
                                child: SingleChildScrollView(
                                  primary: false,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      selfSufficiencyCard,
                                      DailySummaryCard(
                                        snapshot: _lastSnapshot,
                                        axis: Axis.vertical,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ConstrainedBox(
                              constraints: powerCardConstraints,
                              child: solarPowerChart,
                            ),
                            ConstrainedBox(
                              constraints: powerCardConstraints,
                              child: homePowerChart,
                            ),
                            ConstrainedBox(
                              constraints: powerCardConstraints,
                              child: gridPowerChart,
                            ),
                            ConstrainedBox(
                              constraints: powerCardConstraints,
                              child: batteryPowerChart,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ]);

              // Portrait
            } else {
              children.addAll([
                title,
                dateButtons,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: .min,
                      children: [
                        selfSufficiencyCard,
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth,
                          ),
                          child: DailySummaryCard(
                            snapshot: _lastSnapshot,
                            axis: constraints.maxWidth > 600
                                ? .horizontal
                                : .vertical,
                          ),
                        ),
                        solarPowerChart,
                        homePowerChart,
                        gridPowerChart,
                        batteryPowerChart,
                      ],
                    ),
                  ),
                ),
              ]);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            );
          },
        ),
      ),
    );
  }
}
