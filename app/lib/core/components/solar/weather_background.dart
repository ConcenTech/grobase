import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/weather/weather_data.dart';
import '../../../services/weather/weather_providers.dart';

/// Continuously-interpolatable description of the sky. Every field can be
/// linearly blended so weather changes animate as smooth cross-fades.
@immutable
class WeatherParams {
  const WeatherParams({
    required this.skyTop,
    required this.skyBottom,
    required this.cloudColor,
    required this.nightAmount,
    required this.cloudCover,
    required this.snow,
    required this.rain,
    required this.stars,
  });

  final Color skyTop;
  final Color skyBottom;
  final Color cloudColor;

  /// 0 = day (sun), 1 = night (moon + stars).
  final double nightAmount;

  /// 0 = clear, 1 = fully overcast.
  final double cloudCover;
  final double snow;
  final double rain;

  /// Base star visibility (already reduced by cloud cover).
  final double stars;

  static double _l(double a, double b, double t) => a + (b - a) * t;

  /// Maps mm/h onto a 0–1 intensity curve.
  /// ~5 mm/h reads as full strength; lighter rates stay subtle.
  static double _precipIntensity(double mmPerHour) {
    if (mmPerHour <= 0) return 0;
    return (mmPerHour / 5).clamp(0.0, 1.0);
  }

  static WeatherParams lerp(WeatherParams a, WeatherParams b, double t) {
    return WeatherParams(
      skyTop: Color.lerp(a.skyTop, b.skyTop, t)!,
      skyBottom: Color.lerp(a.skyBottom, b.skyBottom, t)!,
      cloudColor: Color.lerp(a.cloudColor, b.cloudColor, t)!,
      nightAmount: _l(a.nightAmount, b.nightAmount, t),
      cloudCover: _l(a.cloudCover, b.cloudCover, t),
      snow: _l(a.snow, b.snow, t),
      rain: _l(a.rain, b.rain, t),
      stars: _l(a.stars, b.stars, t),
    );
  }

  factory WeatherParams.fromData(WeatherData data, bool night) {
    final cover = (data.clouds / 100).clamp(0.0, 1.0);
    final snow = _precipIntensity(data.snow);
    final rain = _precipIntensity(data.rain);

    // Sky gradient is day/night only — weather does not tint it.
    final Color skyTop;
    final Color skyBottom;
    final Color cloudColor;
    if (night) {
      skyTop = const Color(0xFF0A0E1E);
      skyBottom = const Color(0xFF1B2440);
      cloudColor = const Color(0xFF2C3548);
    } else {
      skyTop = const Color(0xFF5AA6E0);
      skyBottom = const Color(0xFFBBDDF5);
      cloudColor = Color.lerp(
        const Color(0xFFFFFFFF),
        const Color(0xFFD7DEE5),
        cover,
      )!;
    }

    return WeatherParams(
      skyTop: skyTop,
      skyBottom: skyBottom,
      cloudColor: cloudColor,
      nightAmount: night ? 1.0 : 0.0,
      cloudCover: cover,
      snow: snow,
      rain: rain,
      stars: night ? (1.0 - cover).clamp(0.0, 1.0) : 0.0,
    );
  }
}

/// Animated sky gradient that fills its parent. Listens to [weatherProvider]
/// and theme brightness, cross-fading smoothly between states.
class SkyBackground extends ConsumerStatefulWidget {
  const SkyBackground({super.key});

  @override
  ConsumerState<SkyBackground> createState() => _SkyBackgroundState();
}

class _SkyBackgroundState extends ConsumerState<SkyBackground>
    with SingleTickerProviderStateMixin {
  bool _initialised = false;
  late final _WeatherTransition _weather;

  @override
  void initState() {
    super.initState();
    _weather = _WeatherTransition(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weather.sync(
      data: ref.read(WeatherProviders.weatherNotifier),
      isNight: Theme.of(context).brightness == Brightness.dark,
      initialised: _initialised,
      onInitialised: () => _initialised = true,
    );
  }

  @override
  void dispose() {
    _weather.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(WeatherProviders.weatherNotifier, (_, next) {
      _weather.sync(
        data: next,
        isNight: Theme.of(context).brightness == Brightness.dark,
        initialised: true,
      );
    });

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _weather.animation,
        builder: (context, _) {
          final params = _weather.params;
          return CustomPaint(
            size: Size.infinite,
            painter: _SkyGradientPainter(
              skyTop: params.skyTop,
              skyBottom: params.skyBottom,
            ),
          );
        },
      ),
    );
  }
}

class _SkyGradientPainter extends CustomPainter {
  _SkyGradientPainter({required this.skyTop, required this.skyBottom});

  final Color skyTop;
  final Color skyBottom;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [skyTop, skyBottom],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _SkyGradientPainter old) =>
      skyTop != old.skyTop || skyBottom != old.skyBottom;
}

/// Sky-layer weather: sun / moon, stars, and drifting clouds.
///
/// Place behind diagram content. Does not paint the sky gradient — use
/// [SkyBackground] for that. Pair with [WeatherEffectsForeground] for rain/snow.
class WeatherEffectsBackground extends ConsumerStatefulWidget {
  const WeatherEffectsBackground({super.key});

  @override
  ConsumerState<WeatherEffectsBackground> createState() =>
      _WeatherEffectsBackgroundState();
}

class _WeatherEffectsBackgroundState
    extends ConsumerState<WeatherEffectsBackground>
    with TickerProviderStateMixin {
  late final Ticker _ticker;
  final ValueNotifier<double> _clock = ValueNotifier<double>(0);
  late final _WeatherTransition _weather;

  late final List<_Cloud> _clouds;
  late final List<_Star> _stars;
  bool _initialised = false;

  @override
  void initState() {
    super.initState();
    _weather = _WeatherTransition(this);
    final rng = math.Random(7);
    _clouds = List.generate(6, (i) => _Cloud.random(rng, i, 6));
    _stars = List.generate(60, (_) => _Star.random(rng));

    _ticker = createTicker((elapsed) {
      _clock.value = elapsed.inMicroseconds / Duration.microsecondsPerSecond;
    })..start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weather.sync(
      data: ref.read(WeatherProviders.weatherNotifier),
      isNight: Theme.of(context).brightness == Brightness.dark,
      initialised: _initialised,
      onInitialised: () => _initialised = true,
    );
  }

  @override
  void dispose() {
    _weather.dispose();
    _ticker.dispose();
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(WeatherProviders.weatherNotifier, (_, next) {
      _weather.sync(
        data: next,
        isNight: Theme.of(context).brightness == Brightness.dark,
        initialised: true,
      );
    });

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([_weather.animation, _clock]),
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: _WeatherEffectsBackgroundPainter(
              params: _weather.params,
              clock: _clock.value,
              clouds: _clouds,
              stars: _stars,
            ),
          );
        },
      ),
    );
  }
}

/// Precipitation-layer weather: rain and snow drawn over diagram content.
///
/// Pair with [WeatherEffectsBackground] for celestial bodies and clouds.
class WeatherEffectsForeground extends ConsumerStatefulWidget {
  const WeatherEffectsForeground({super.key});

  @override
  ConsumerState<WeatherEffectsForeground> createState() =>
      _WeatherEffectsForegroundState();
}

class _WeatherEffectsForegroundState
    extends ConsumerState<WeatherEffectsForeground>
    with TickerProviderStateMixin {
  late final Ticker _ticker;
  final ValueNotifier<double> _clock = ValueNotifier<double>(0);
  late final _WeatherTransition _weather;

  late final List<_Flake> _flakes;
  bool _initialised = false;

  @override
  void initState() {
    super.initState();
    _weather = _WeatherTransition(this);
    final rng = math.Random(7);
    _flakes = List.generate(80, (_) => _Flake.random(rng));

    _ticker = createTicker((elapsed) {
      _clock.value = elapsed.inMicroseconds / Duration.microsecondsPerSecond;
    })..start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weather.sync(
      data: ref.read(WeatherProviders.weatherNotifier),
      isNight: Theme.of(context).brightness == Brightness.dark,
      initialised: _initialised,
      onInitialised: () => _initialised = true,
    );
  }

  @override
  void dispose() {
    _weather.dispose();
    _ticker.dispose();
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(WeatherProviders.weatherNotifier, (_, next) {
      _weather.sync(
        data: next,
        isNight: Theme.of(context).brightness == Brightness.dark,
        initialised: true,
      );
    });

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([_weather.animation, _clock]),
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: _WeatherEffectsForegroundPainter(
              params: _weather.params,
              clock: _clock.value,
              flakes: _flakes,
            ),
          );
        },
      ),
    );
  }
}

/// Cross-fade between weather states. Each painter owns its own instance.
class _WeatherTransition {
  _WeatherTransition(TickerProvider vsync)
    : _trans = AnimationController(
        vsync: vsync,
        duration: const Duration(milliseconds: 1400),
      )..value = 1.0;

  final AnimationController _trans;
  late WeatherParams _from;
  late WeatherParams _to;
  WeatherData? _data;
  bool _isNight = false;

  Listenable get animation => _trans;

  WeatherParams get params =>
      WeatherParams.lerp(_from, _to, Curves.easeInOut.transform(_trans.value));

  void dispose() => _trans.dispose();

  void sync({
    required WeatherData data,
    required bool isNight,
    required bool initialised,
    VoidCallback? onInitialised,
  }) {
    if (!initialised) {
      _data = data;
      _isNight = isNight;
      _from = _to = WeatherParams.fromData(data, isNight);
      onInitialised?.call();
      return;
    }

    if (data == _data && isNight == _isNight) return;

    final curve = Curves.easeInOut.transform(_trans.value);
    _from = WeatherParams.lerp(_from, _to, curve);
    _to = WeatherParams.fromData(data, isNight);
    _data = data;
    _isNight = isNight;
    _trans.forward(from: 0);
  }
}

class _Cloud {
  _Cloud({
    required this.baseX,
    required this.y,
    required this.scale,
    required this.speed,
    required this.appearAt,
  });

  final double baseX; // 0..1 starting phase along the travel span
  final double y; // 0..1 within the upper sky band
  final double scale; // fraction of shortest side
  final double speed; // fraction of width per second
  final double appearAt; // cloud-cover threshold at which it fades in

  factory _Cloud.random(math.Random r, int i, int count) {
    return _Cloud(
      baseX: r.nextDouble(),
      y: 0.05 + r.nextDouble() * 0.42,
      // ~35% smaller than the previous 0.10–0.18 range.
      scale: 0.065 + r.nextDouble() * 0.052,
      // Nearly static: a barely-perceptible drift.
      speed: 0.0015 + r.nextDouble() * 0.0025,
      appearAt: i / count * 0.85,
    );
  }
}

class _Star {
  _Star({
    required this.x,
    required this.y,
    required this.radius,
    required this.twinkleSpeed,
    required this.phase,
    required this.baseAlpha,
  });

  final double x; // 0..1
  final double y; // 0..1 (within upper band)
  final double radius; // px-ish, scaled by shortest side
  final double twinkleSpeed;
  final double phase;
  final double baseAlpha;

  factory _Star.random(math.Random r) {
    return _Star(
      x: r.nextDouble(),
      y: r.nextDouble() * 0.7,
      radius: 0.6 + r.nextDouble() * 1.4,
      twinkleSpeed: 1.5 + r.nextDouble() * 2.5,
      phase: r.nextDouble() * math.pi * 2,
      baseAlpha: 0.5 + r.nextDouble() * 0.5,
    );
  }
}

class _Flake {
  _Flake({
    required this.x,
    required this.baseY,
    required this.size,
    required this.fallSpeed,
    required this.swaySpeed,
    required this.swayAmp,
    required this.phase,
  });

  final double x; // 0..1
  final double baseY; // 0..1
  final double size; // fraction of shortest side
  final double fallSpeed; // fraction of height per second
  final double swaySpeed;
  final double swayAmp; // fraction of width
  final double phase;

  factory _Flake.random(math.Random r) {
    return _Flake(
      x: r.nextDouble(),
      baseY: r.nextDouble(),
      size: 0.008 + r.nextDouble() * 0.01,
      fallSpeed: 0.08 + r.nextDouble() * 0.16,
      swaySpeed: 0.8 + r.nextDouble() * 1.6,
      swayAmp: 0.01 + r.nextDouble() * 0.03,
      phase: r.nextDouble() * math.pi * 2,
    );
  }
}

class _WeatherEffectsBackgroundPainter extends CustomPainter {
  _WeatherEffectsBackgroundPainter({
    required this.params,
    required this.clock,
    required this.clouds,
    required this.stars,
  });

  final WeatherParams params;
  final double clock;
  final List<_Cloud> clouds;
  final List<_Star> stars;

  @override
  void paint(Canvas canvas, Size size) {
    final short = size.shortestSide;

    if (params.stars > 0.01) _paintStars(canvas, size);

    // Sun / moon tucked into the top-left corner, clear of the diagram.
    final celestial = Offset(size.width * 0.1, size.height * 0.13);
    final cr = short * 0.07;
    _paintSun(canvas, celestial, cr, 1.0 - params.nightAmount);
    _paintMoon(canvas, celestial, cr, params.nightAmount);

    if (params.cloudCover > 0.01) _paintClouds(canvas, size, short);
  }

  void _paintStars(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (final s in stars) {
      final twinkle = 0.55 + 0.45 * math.sin(clock * s.twinkleSpeed + s.phase);
      final a = (params.stars * s.baseAlpha * twinkle).clamp(0.0, 1.0);
      if (a < 0.02) continue;
      canvas.drawCircle(
        Offset(s.x * size.width, s.y * size.height),
        s.radius,
        paint..color = Colors.white.withValues(alpha: a),
      );
    }
  }

  void _paintSun(Canvas canvas, Offset c, double r, double opacity) {
    if (opacity <= 0.01) return;
    canvas.drawCircle(
      c,
      r * 2.2,
      Paint()
        ..color = const Color(0xFFFFE082).withValues(alpha: 0.35 * opacity)
        ..maskFilter = ui.MaskFilter.blur(BlurStyle.normal, r * 0.9),
    );
    canvas.drawCircle(
      c,
      r * 1.35,
      Paint()
        ..color = const Color(0xFFFFD54F).withValues(alpha: 0.45 * opacity)
        ..maskFilter = ui.MaskFilter.blur(BlurStyle.normal, r * 0.5),
    );
    canvas.drawCircle(
      c,
      r,
      Paint()..color = const Color(0xFFFFCA28).withValues(alpha: opacity),
    );
  }

  void _paintMoon(Canvas canvas, Offset c, double r, double opacity) {
    if (opacity <= 0.01) return;
    canvas.drawCircle(
      c,
      r * 1.7,
      Paint()
        ..color = const Color(0xFFCBD6E6).withValues(alpha: 0.2 * opacity)
        ..maskFilter = ui.MaskFilter.blur(BlurStyle.normal, r * 0.8),
    );
    // Carve a crescent with a clear-blended offset disc inside a layer.
    final bounds = Rect.fromCircle(center: c, radius: r * 1.3);
    canvas.saveLayer(bounds, Paint());
    canvas.drawCircle(
      c,
      r,
      Paint()..color = const Color(0xFFE8EDF5).withValues(alpha: opacity),
    );
    canvas.drawCircle(
      c.translate(r * 0.55, -r * 0.32),
      r * 0.92,
      Paint()..blendMode = BlendMode.clear,
    );
    canvas.restore();
  }

  void _paintClouds(Canvas canvas, Size size, double short) {
    final cover = params.cloudCover;
    // Opacity and slight scale grow with cover so clouds intensify past zero.
    final intensity = (0.55 + cover * 0.45).clamp(0.0, 1.0);

    for (final cloud in clouds) {
      final alpha =
          (((cover - cloud.appearAt) / 0.2).clamp(0.0, 1.0)) * 0.95 * intensity;
      if (alpha < 0.02) continue;

      final s = short * cloud.scale * (0.9 + cover * 0.2);
      final span = size.width + s * 6;
      var x = (cloud.baseX * span + clock * cloud.speed * size.width) % span;
      if (x < 0) x += span;
      final cx = x - s * 3;
      final cy = cloud.y * size.height * 0.55 + size.height * 0.04;

      // Build the cloud as one path so overlaps don't darken.
      final path = Path()
        ..addOval(
          Rect.fromCircle(center: Offset(cx - s * 1.1, cy), radius: s * 0.8),
        )
        ..addOval(
          Rect.fromCircle(center: Offset(cx, cy - s * 0.5), radius: s * 1.1),
        )
        ..addOval(
          Rect.fromCircle(center: Offset(cx + s * 1.1, cy), radius: s * 0.9),
        )
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTRB(cx - s * 2, cy - s * 0.1, cx + s * 2, cy + s * 0.85),
            Radius.circular(s * 0.6),
          ),
        );
      canvas.drawPath(
        path,
        Paint()..color = params.cloudColor.withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WeatherEffectsBackgroundPainter old) => true;
}

class _WeatherEffectsForegroundPainter extends CustomPainter {
  _WeatherEffectsForegroundPainter({
    required this.params,
    required this.clock,
    required this.flakes,
  });

  final WeatherParams params;
  final double clock;
  final List<_Flake> flakes;

  /// Particle stride: sparse just above zero, dense at full intensity.
  static int _strideFor(double intensity) {
    if (intensity <= 0) return 999;
    return math.max(1, (4.5 - intensity * 3.5).round());
  }

  @override
  void paint(Canvas canvas, Size size) {
    final short = size.shortestSide;
    if (params.snow > 0.01) _paintSnow(canvas, size, short);
    if (params.rain > 0.01) _paintRain(canvas, size, short);
  }

  void _paintSnow(Canvas canvas, Size size, double short) {
    final paint = Paint()..color = Colors.white;
    final intensity = params.snow;
    final stride = _strideFor(intensity);

    for (var i = 0; i < flakes.length; i += stride) {
      final f = flakes[i];
      // Fall speed must stay constant — tying it to intensity makes particles
      // jump ahead while weather is lerping up.
      final y = (f.baseY + clock * f.fallSpeed) % 1.0;
      final x = f.x + f.swayAmp * math.sin(clock * f.swaySpeed + f.phase);
      // Smaller flakes read as further away, so fade them a little more.
      final depth = ((f.size - 0.008) / 0.01).clamp(0.0, 1.0);
      final a = (intensity * (0.18 + depth * 0.22)).clamp(0.0, 1.0);
      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        short * f.size * (0.4 + intensity * 0.15),
        paint..color = Colors.white.withValues(alpha: a),
      );
    }
  }

  void _paintRain(Canvas canvas, Size size, double short) {
    final intensity = params.rain;
    final stride = _strideFor(intensity);
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = short * (0.003 + intensity * 0.0025)
      ..color = const Color(0xFFBBD3E6).withValues(
        alpha: (intensity * (0.14 + intensity * 0.12)).clamp(0.0, 1.0),
      );
    final len = short * (0.035 + intensity * 0.025);

    for (var i = 0; i < flakes.length; i += stride) {
      final f = flakes[i];
      final speed = f.fallSpeed * 4 + 0.6;
      final y = (f.baseY + clock * speed) % 1.0;
      final x = f.x * size.width + short * 0.02;
      final top = Offset(x, y * size.height);
      canvas.drawLine(top, top.translate(-short * 0.012, len), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WeatherEffectsForegroundPainter old) => true;
}
