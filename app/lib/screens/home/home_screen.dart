import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/components/inverter_title_text.dart';
import '../../core/components/loading_indicator.dart';
import '../../core/components/solar/solar_energy_diagram_v2.dart';
import '../../core/extensions/list_extensions.dart';
import '../../models/database/inverter.drift.dart';
import '../../models/database/inverter_snapshot.drift.dart';
import '../../services/database/database_providers.dart';
import '../../services/inverters_provider.dart';
import '../../services/selected_date_time_notifier.dart';
import '../../services/weather/weather_providers.dart';
import 'dialogs/battery_chart_dialog.dart';
import 'dialogs/grid_chart_dialog.dart';
import 'dialogs/load_chart_dialog.dart';
import 'dialogs/solar_chart_dialog.dart';
import 'energy_card.dart';
import 'statistics_card.dart';
import 'system_details_button.dart';

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
  late final AppLifecycleListener _appLifecycleListener;

  @override
  void initState() {
    super.initState();
    if (widget.inverter != null) {
      _setWeatherForInverter(widget.inverter!);
    }
    _appLifecycleListener = AppLifecycleListener(
      onResume: () {
        if (widget.inverter != null) {
          _setWeatherForInverter(widget.inverter!);
        }
        ref.read(selectedDateTimeProvider.notifier).setTodayIfNotPinned();
      },
    );
  }

  @override
  void didUpdateWidget(HomeScreenContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.inverter?.id != oldWidget.inverter?.id &&
        widget.inverter != null) {
      _setWeatherForInverter(widget.inverter!);
    }
  }

  @override
  void dispose() {
    _appLifecycleListener.dispose();
    super.dispose();
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

  String _lastUpdatedText(Inverter? inverter) {
    final lastUpdated = inverter?.lastSeenAt;

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
    final solarEnergyData = _getLatestSolarEnergyData();
    final weather = ref.watch(WeatherProviders.weatherNotifier);

    final diagram = SolarEnergyDiagramV2(data: solarEnergyData);

    final historyInfoButtons = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SystemDetailsButton(inverter: widget.inverter),
        ElevatedButton.icon(
          onPressed: () =>
              GoRouter.of(context).push('/history', extra: widget.inverter),
          icon: const Icon(Icons.history),
          label: const Text('History'),
        ),
      ],
    );

    final title = Padding(
      padding: const EdgeInsets.only(left: 12),
      child: InverterTitleText(name: widget.inverter?.displayName ?? ''),
    );

    final lastUpdated = Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Text(_lastUpdatedText(widget.inverter), style: subtitleTextTheme),
    );

    final statisticsCard = widget.snapshots.isNotEmpty
        ? StatisticsCard(snapshot: widget.snapshots.last, weather: weather)
        : null;

    final energyCardChildren = [
      EnergyCard.solar(
        power: solarEnergyData.solarWatts,
        onTap: () => showDialog(
          context: context,
          builder: (context) => SolarChartDialog(snapshots: widget.snapshots),
        ),
      ),
      EnergyCard.battery(
        power: solarEnergyData.batteryWatts,
        soc: solarEnergyData.batteryLevel,
        onTap: () => showDialog(
          context: context,
          builder: (context) => BatteryChartDialog(snapshots: widget.snapshots),
        ),
      ),
      EnergyCard.grid(
        power: solarEnergyData.gridWatts,
        onTap: () => showDialog(
          context: context,
          builder: (context) => GridChartDialog(snapshots: widget.snapshots),
        ),
      ),
      EnergyCard.load(
        power: solarEnergyData.houseWatts,
        onTap: () => showDialog(
          context: context,
          builder: (context) => LoadChartDialog(snapshots: widget.snapshots),
        ),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        final energyCards = EnergyCardContainer(
          mainAxis: isLandscape ? Axis.horizontal : Axis.vertical,
          children: energyCardChildren,
        );

        if (isLandscape) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: constraints.maxHeight,
              child: Row(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: _DiagramWithFooter(
                      aspectRatio: HouseDiagramV2Layout.contentAspect,
                      sideInset: 20,
                      children: [
                        historyInfoButtons,

                        diagram,
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [title, lastUpdated, ?statisticsCard],
                        ),
                      ],
                    ),
                  ),
                  energyCards,
                ],
              ),
            ),
          );
        }

        return ListView(
          children: [
            historyInfoButtons,
            AspectRatio(
              aspectRatio: HouseDiagramV2Layout.contentAspect,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: diagram,
              ),
            ),
            title,
            lastUpdated,
            ?statisticsCard,
            energyCards,
          ],
        );
      },
    );
  }
}

/// Stacks a header, a diagram, and a footer.
///
/// Children, in order: header, diagram, footer. The diagram fills the height
/// left after the header and footer, at [aspectRatio]. The header and footer
/// are as wide as the diagram plus [sideInset] on each side.
class _DiagramWithFooter extends MultiChildRenderObjectWidget {
  const _DiagramWithFooter({
    required super.children,
    required this.aspectRatio,
    this.sideInset = 20,
  });

  final double aspectRatio;
  final double sideInset;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderDiagramWithFooter(
      aspectRatio: aspectRatio,
      sideInset: sideInset,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderDiagramWithFooter renderObject,
  ) {
    renderObject
      ..aspectRatio = aspectRatio
      ..sideInset = sideInset;
  }
}

class _DiagramFooterParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderDiagramWithFooter extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _DiagramFooterParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _DiagramFooterParentData> {
  _RenderDiagramWithFooter({
    required this._aspectRatio,
    required this._sideInset,
  });

  double _aspectRatio;
  double get aspectRatio => _aspectRatio;
  set aspectRatio(double value) {
    if (_aspectRatio == value) return;
    _aspectRatio = value;
    markNeedsLayout();
  }

  double _sideInset;
  double get sideInset => _sideInset;
  set sideInset(double value) {
    if (_sideInset == value) return;
    _sideInset = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _DiagramFooterParentData) {
      child.parentData = _DiagramFooterParentData();
    }
  }

  Size _layout(BoxConstraints constraints, {required bool dry}) {
    final header = firstChild!;
    final diagram = childAfter(header)!;
    final footer = lastChild!;
    final maxHeight = constraints.maxHeight;

    final tentativeWidth = constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : maxHeight * _aspectRatio + 2 * _sideInset;

    final loose = BoxConstraints(
      maxWidth: tentativeWidth,
      maxHeight: maxHeight,
    );
    final headerSize = _layoutChild(header, loose, dry: dry);
    final footerSize = _layoutChild(footer, loose, dry: dry);

    final remaining = max(
      0.0,
      maxHeight - headerSize.height - footerSize.height,
    );
    var diagramWidth = remaining * _aspectRatio;
    var diagramHeight = remaining;

    if (constraints.maxWidth.isFinite) {
      final maxDiagramWidth = max(0.0, constraints.maxWidth - 2 * _sideInset);
      if (diagramWidth > maxDiagramWidth) {
        diagramWidth = maxDiagramWidth;
        diagramHeight = diagramWidth / _aspectRatio;
      }
    }

    final diagramSize = Size(diagramWidth, diagramHeight);
    _layoutChild(diagram, BoxConstraints.tight(diagramSize), dry: dry);

    final columnWidth = diagramWidth + 2 * _sideInset;
    _layoutChild(
      header,
      BoxConstraints.tight(Size(columnWidth, headerSize.height)),
      dry: dry,
    );
    _layoutChild(
      footer,
      BoxConstraints.tight(Size(columnWidth, footerSize.height)),
      dry: dry,
    );

    if (!dry) {
      (header.parentData! as _DiagramFooterParentData).offset = Offset.zero;
      (diagram.parentData! as _DiagramFooterParentData).offset = Offset(
        _sideInset,
        headerSize.height,
      );
      (footer.parentData! as _DiagramFooterParentData).offset = Offset(
        0,
        maxHeight - footerSize.height,
      );
    }

    return constraints.constrain(Size(columnWidth, maxHeight));
  }

  Size _layoutChild(
    RenderBox child,
    BoxConstraints constraints, {
    required bool dry,
  }) {
    if (dry) {
      return child.getDryLayout(constraints);
    }
    child.layout(constraints, parentUsesSize: true);
    return child.size;
  }

  @override
  void performLayout() {
    size = _layout(constraints, dry: false);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _layout(constraints, dry: true);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}

/// Resolves the inverter to show on the home screen.
///
/// Stays [AsyncLoading] until sync completes and inverters are available.
/// Emits `null` when the user has no inverters.
final homeProvider = Provider<AsyncValue<Inverter?>>((ref) {
  final syncState = ref.watch(DatabaseProviders.singleSyncState(null));
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
