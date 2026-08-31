import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'solar_diagram_v2_background_painter.dart';
import 'solar_diagram_v2_foreground_painter.dart';
import 'solar_energy_data.dart' show SolarEnergyData, SolarDiagramPalette;
import 'weather_background.dart';

export 'solar_diagram_v2_background_painter.dart' show HouseDiagramV2Layout;
export 'solar_energy_data.dart' show SolarEnergyData;

/// A second, visually distinct take on [SolarEnergyDiagram], used for A/B
/// testing against it.
///
/// Composites the [HouseDiagramLayout.assetPath] illustration with:
/// * warm window glow (visible through the transparent panes at night),
/// * a transmission pole beside the house,
/// * animated power-flow cables between solar, battery, grid and inverter, and
/// * discrete wattage labels on each connection.
///
/// Driven by the same [SolarEnergyData] as the original diagram.
///
/// "Night" follows the ambient theme [Brightness]. Wrap this widget in a
/// `Theme` to drive it independently of the global app theme.
class SolarEnergyDiagramV2 extends StatefulWidget {
  const SolarEnergyDiagramV2({
    super.key,
    required this.data,
    this.duration,
    this.paintBackground = true,
  });

  static Future<void> precache() {
    return Future.wait([
      _precacheImage(HouseDiagramV2Layout.assetPath),
      _precacheImage(HouseDiagramV2Layout.poleAssetPath),
    ]);
  }

  static Future<void> _precacheImage(String assetPath) {
    final completer = Completer<void>();

    final ImageProvider imageProvider = AssetImage(assetPath);
    final ImageStream stream = imageProvider.resolve(ImageConfiguration.empty);

    stream.addListener(
      ImageStreamListener(
        (info, syncCall) {
          completer.complete();
        },
        onError: (e, s) {
          completer.completeError(e, s);
        },
      ),
    );

    return completer.future;
  }

  final SolarEnergyData data;

  /// Whether to paint the sky/ground scenery behind the house. Disable to
  /// composite over your own background (e.g. [SkyBackground]).
  final bool paintBackground;

  /// Day/night cross-fade duration. Defaults to [kThemeAnimationDuration].
  final Duration? duration;

  @override
  State<SolarEnergyDiagramV2> createState() => _SolarEnergyDiagramV2State();
}

class _SolarEnergyDiagramV2State extends State<SolarEnergyDiagramV2>
    with TickerProviderStateMixin {
  late final Ticker _ticker;
  final ValueNotifier<double> _phase = ValueNotifier<double>(0);
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
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
        final imageRect = HouseDiagramV2Layout.imageRect(canvasSize);
        final poleRect = HouseDiagramV2Layout.poleRect(canvasSize);

        // Drive ticks from the widget so painters always see current data and
        // phase together (avoids stale power when using CustomPainter.repaint).
        return AnimatedBuilder(
          animation: Listenable.merge([_night, _phase]),
          builder: (context, _) {
            final na = Curves.easeInOut.transform(_night.value);
            final t = _phase.value;
            final palette = SolarDiagramPalette.resolve(scheme, na >= 0.5);
            return RepaintBoundary(
              child: Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.none,
                children: [
                  const WeatherEffectsBackground(),
                  CustomPaint(
                    painter: SolarDiagramV2BackgroundPainter(
                      data: widget.data,
                      palette: palette,
                      t: t,
                      nightAmount: na,
                    ),
                  ),
                  Positioned.fromRect(
                    rect: poleRect,
                    child: Image.asset(
                      HouseDiagramV2Layout.poleAssetPath,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                  Positioned.fromRect(
                    rect: imageRect,
                    child: Image.asset(
                      HouseDiagramV2Layout.assetPath,
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                  const WeatherEffectsForeground(),
                  CustomPaint(
                    painter: SolarDiagramV2ForegroundPainter(
                      data: widget.data,
                      palette: palette,
                      t: t,
                      nightAmount: na,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
