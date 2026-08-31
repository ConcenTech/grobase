import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import '../../services/selected_date_time_notifier.dart';
import '../../services/weather/weather_providers.dart';
import 'date_card.dart';
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

    final titleRow = Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        spacing: 8,
        children: [
          Flexible(
            child: Text(
              widget.inverter?.displayName ?? '',
              style: titleTextTheme,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SystemDetailsButton(inverter: widget.inverter),
        ],
      ),
    );

    final lastUpdated = Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Text(_lastUpdatedText(widget.inverter), style: subtitleTextTheme),
    );

    final dateCard = widget.inverter != null
        ? DateCard(minDate: widget.inverter!.createdAt)
        : null;

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DiagramWithFooter(
                    aspectRatio: HouseDiagramV2Layout.contentAspect,
                    sideInset: 20,
                    diagram: diagram,
                    footer: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        titleRow,
                        lastUpdated,
                        if (dateCard != null) dateCard,
                        if (statisticsCard != null) statisticsCard,
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
            AspectRatio(
              aspectRatio: HouseDiagramV2Layout.contentAspect,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: diagram,
              ),
            ),
            titleRow,
            lastUpdated,
            if (dateCard != null) dateCard,
            if (statisticsCard != null) statisticsCard,
            energyCards,
          ],
        );
      },
    );
  }
}

/// Lays out [diagram] to fill leftover height at [aspectRatio], and sizes
/// [footer] to that width plus [sideInset] on each side.
class _DiagramWithFooter extends MultiChildRenderObjectWidget {
  _DiagramWithFooter({
    required Widget diagram,
    required Widget footer,
    required this.aspectRatio,
    this.sideInset = 20,
  }) : super(children: [diagram, footer]);

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
    required double aspectRatio,
    required double sideInset,
  }) : _aspectRatio = aspectRatio,
       _sideInset = sideInset;

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
    final diagram = firstChild!;
    final footer = lastChild!;
    final maxHeight = constraints.maxHeight;

    final tentativeWidth = constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : maxHeight * _aspectRatio + 2 * _sideInset;

    final footerConstraints = BoxConstraints(
      maxWidth: tentativeWidth,
      maxHeight: maxHeight,
    );
    final footerSize = dry
        ? footer.getDryLayout(footerConstraints)
        : () {
            footer.layout(footerConstraints, parentUsesSize: true);
            return footer.size;
          }();

    final remaining = max(0.0, maxHeight - footerSize.height);
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
    if (dry) {
      diagram.getDryLayout(BoxConstraints.tight(diagramSize));
    } else {
      diagram.layout(BoxConstraints.tight(diagramSize), parentUsesSize: true);
    }

    final footerWidth = diagramWidth + 2 * _sideInset;
    final tightFooter = BoxConstraints.tight(
      Size(footerWidth, footerSize.height),
    );
    if (dry) {
      footer.getDryLayout(tightFooter);
    } else {
      footer.layout(tightFooter, parentUsesSize: true);
      (diagram.parentData as _DiagramFooterParentData).offset = Offset(
        _sideInset,
        0,
      );
      (footer.parentData as _DiagramFooterParentData).offset = Offset(
        0,
        maxHeight - footerSize.height,
      );
    }

    return constraints.constrain(Size(footerWidth, maxHeight));
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
