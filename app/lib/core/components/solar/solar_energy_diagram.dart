import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'solar_diagram_painter.dart';
import 'solar_energy_data.dart';
import 'weather_background.dart';

export 'solar_energy_data.dart'
    show SolarEnergyData, SolarDiagramPalette, SolarDiagramTheme, EnergyNode;
export 'weather_background.dart'
    show
        SkyBackground,
        WeatherEffectsBackground,
        WeatherEffectsForeground;

/// An animated diagram of a home solar / charging system.
///
/// Four corner nodes (solar, grid, battery, house) connect to a central
/// junction. Energy flow is animated along each connection based on the signed
/// power values in [data], the battery fills/empties with a directional
/// shimmer, and the house illuminates at night.
///
/// "Night" follows the ambient theme [Brightness] — a dark theme renders the
/// night scene. Wrap this widget in a `Theme` to drive it independently of the
/// global app theme.
///
/// When [showWeatherEffects] is true, [WeatherEffectsBackground] (sun/moon,
/// stars, clouds) sits behind the diagram and [WeatherEffectsForeground]
/// (rain/snow) sits in front. Both listen to [weatherProvider]. The diagram
/// itself is painted transparently so the [SkyBackground] shows through.
class SolarEnergyDiagram extends StatefulWidget {
  const SolarEnergyDiagram({
    super.key,
    required this.data,
    this.showWeatherEffects = false,
    this.showGarage = true,
    this.duration,
  });

  final SolarEnergyData data;

  /// When true, draws weather effects around the diagram. Requires a
  /// [SkyBackground] behind this widget (typically via [AppScaffold]).
  final bool showWeatherEffects;

  /// Whether the house is drawn with an attached garage.
  final bool showGarage;

  /// Animation duration. Defaults to [kThemeAnimationDuration]
  final Duration? duration;

  @override
  State<SolarEnergyDiagram> createState() => _SolarEnergyDiagramState();
}

class _SolarEnergyDiagramState extends State<SolarEnergyDiagram>
    with TickerProviderStateMixin {
  late final Ticker _ticker;

  /// Continuously increasing time in seconds. Drives the flow animation without
  /// triggering full widget rebuilds (the painter listens to it directly).
  final ValueNotifier<double> _phase = ValueNotifier<double>(0);

  /// Animates the day↔night blend (0 = day, 1 = night) so palette colours and
  /// the house illumination cross-fade in step with the weather sky. "Night"
  /// follows the ambient theme [Brightness] (a dark theme is night).
  late final AnimationController _night;
  bool _isNight = false;
  bool _initialised = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      _phase.value = elapsed.inMicroseconds / Duration.microsecondsPerSecond;
    })..start();
    _night = AnimationController(
      vsync: this,
      duration: widget.duration ?? kThemeAnimationDuration,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Drive night from the theme brightness; animate on changes, snap on first.
    final night = Theme.of(context).brightness == Brightness.dark;
    if (!_initialised) {
      _night.value = night ? 1 : 0;
      _initialised = true;
    } else if (night != _isNight) {
      night ? _night.forward() : _night.reverse();
    }
    _isNight = night;
  }

  @override
  void dispose() {
    _ticker.dispose();
    _phase.dispose();
    _night.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final overrides = theme.extension<SolarDiagramTheme>();
    SolarDiagramPalette resolve(bool night) {
      final base = SolarDiagramPalette.resolve(scheme, night);
      return overrides == null ? base : overrides.applyTo(base);
    }

    final dayPalette = resolve(false);
    final nightPalette = resolve(true);
    final hasWeatherEffects = widget.showWeatherEffects;

    return AnimatedBuilder(
      animation: _night,
      builder: (context, _) {
        final na = Curves.easeInOut.transform(_night.value);
        final palette = SolarDiagramPalette.lerp(dayPalette, nightPalette, na);

        final diagram = RepaintBoundary(
          child: CustomPaint(
            size: Size.infinite,
            painter: SolarDiagramPainter(
              data: widget.data,
              palette: palette,
              phase: _phase,
              showGarage: widget.showGarage,
              paintBackground: !hasWeatherEffects,
              nightAmount: na,
            ),
          ),
        );

        if (!hasWeatherEffects) {
          return ColoredBox(color: palette.background, child: diagram);
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            // Push the diagram down so the corner sun/moon has clear room above.
            final topInset = constraints.maxHeight * 0.12;
            return Stack(
              fit: StackFit.expand,
              children: [
                const WeatherEffectsBackground(),
                Padding(
                  padding: EdgeInsets.only(top: topInset),
                  child: diagram,
                ),
                const WeatherEffectsForeground(),
              ],
            );
          },
        );
      },
    );
  }
}
