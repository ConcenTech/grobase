import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// High-level weather state for [WeatherBackground].
enum WeatherCondition { clear, partlyCloudy, cloudy, rain, snow }

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

  factory WeatherParams.forCondition(WeatherCondition condition, bool night) {
    double cover;
    var snow = 0.0;
    var rain = 0.0;
    switch (condition) {
      case WeatherCondition.clear:
        cover = 0.0;
      case WeatherCondition.partlyCloudy:
        cover = 0.4;
      case WeatherCondition.cloudy:
        cover = 0.92;
      case WeatherCondition.rain:
        cover = 0.95;
        rain = 1.0;
      case WeatherCondition.snow:
        cover = 0.85;
        snow = 1.0;
    }

    final Color skyTop;
    final Color skyBottom;
    final Color cloudColor;
    if (night) {
      skyTop = Color.lerp(
        const Color(0xFF0A0E1E),
        const Color(0xFF181D30),
        cover,
      )!;
      skyBottom = Color.lerp(
        const Color(0xFF1B2440),
        const Color(0xFF2A3148),
        cover,
      )!;
      cloudColor = const Color(0xFF2C3548);
    } else {
      // Clear blue deepening to a darker, muted blue as cover increases
      // (rather than washing out to grey).
      skyTop = Color.lerp(
        const Color(0xFF5AA6E0),
        const Color(0xFF3E6285),
        cover,
      )!;
      skyBottom = Color.lerp(
        const Color(0xFFBBDDF5),
        const Color(0xFF7E9FBA),
        cover,
      )!;
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

/// An animated sky that sits behind the solar diagram: gradient background,
/// a sun by day / crescent moon + twinkling stars by night, clouds drifting
/// across the top, and optional snow or rain. Changing [condition] or
/// [isNight] cross-fades smoothly between states.
class WeatherBackground extends StatefulWidget {
  const WeatherBackground({
    super.key,
    required this.condition,
    required this.isNight,
    this.transition = const Duration(milliseconds: 1400),
  });

  final WeatherCondition condition;
  final bool isNight;
  final Duration transition;

  @override
  State<WeatherBackground> createState() => _WeatherBackgroundState();
}

class _WeatherBackgroundState extends State<WeatherBackground>
    with TickerProviderStateMixin {
  late final Ticker _ticker;
  final ValueNotifier<double> _clock = ValueNotifier<double>(0);

  late final AnimationController _trans;
  late WeatherParams _from;
  late WeatherParams _to;

  late final List<_Cloud> _clouds;
  late final List<_Star> _stars;
  late final List<_Flake> _flakes;

  @override
  void initState() {
    super.initState();
    final rng = math.Random(7);
    _clouds = List.generate(6, (i) => _Cloud.random(rng, i, 6));
    _stars = List.generate(60, (_) => _Star.random(rng));
    _flakes = List.generate(80, (_) => _Flake.random(rng));

    _to = _from = WeatherParams.forCondition(widget.condition, widget.isNight);
    _trans = AnimationController(vsync: this, duration: widget.transition)
      ..value = 1.0;
    _ticker = createTicker((elapsed) {
      _clock.value = elapsed.inMicroseconds / Duration.microsecondsPerSecond;
    })..start();
  }

  @override
  void didUpdateWidget(WeatherBackground old) {
    super.didUpdateWidget(old);
    if (old.condition != widget.condition || old.isNight != widget.isNight) {
      final curve = Curves.easeInOut.transform(_trans.value);
      _from = WeatherParams.lerp(_from, _to, curve);
      _to = WeatherParams.forCondition(widget.condition, widget.isNight);
      _trans.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _trans.dispose();
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([_trans, _clock]),
        builder: (context, _) {
          final params = WeatherParams.lerp(
            _from,
            _to,
            Curves.easeInOut.transform(_trans.value),
          );
          return CustomPaint(
            size: Size.infinite,
            painter: _WeatherPainter(
              params: params,
              clock: _clock.value,
              clouds: _clouds,
              stars: _stars,
              flakes: _flakes,
            ),
          );
        },
      ),
    );
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
      scale: 0.1 + r.nextDouble() * 0.08,
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

class _WeatherPainter extends CustomPainter {
  _WeatherPainter({
    required this.params,
    required this.clock,
    required this.clouds,
    required this.stars,
    required this.flakes,
  });

  final WeatherParams params;
  final double clock;
  final List<_Cloud> clouds;
  final List<_Star> stars;
  final List<_Flake> flakes;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final short = size.shortestSide;

    // Sky gradient.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [params.skyTop, params.skyBottom],
        ).createShader(rect),
    );

    if (params.stars > 0.01) _paintStars(canvas, size);

    // Sun / moon tucked into the top-left corner, clear of the diagram.
    final celestial = Offset(size.width * 0.2, size.height * 0.13);
    final cr = short * 0.07;
    _paintSun(canvas, celestial, cr, 1.0 - params.nightAmount);
    _paintMoon(canvas, celestial, cr, params.nightAmount);

    if (params.cloudCover > 0.01) _paintClouds(canvas, size, short);
    if (params.snow > 0.01) _paintSnow(canvas, size, short);
    if (params.rain > 0.01) _paintRain(canvas, size, short);
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
    for (final cloud in clouds) {
      final alpha =
          (((params.cloudCover - cloud.appearAt) / 0.2).clamp(0.0, 1.0)) * 0.95;
      if (alpha < 0.02) continue;

      final s = short * cloud.scale;
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

  void _paintSnow(Canvas canvas, Size size, double short) {
    final paint = Paint()..color = Colors.white;
    // Use a thinned-out subset of flakes so snow stays gentle.
    for (var i = 0; i < flakes.length; i += 3) {
      final f = flakes[i];
      final y = (f.baseY + clock * f.fallSpeed) % 1.0;
      final x = f.x + f.swayAmp * math.sin(clock * f.swaySpeed + f.phase);
      // Smaller flakes read as further away, so fade them a little more.
      final depth = ((f.size - 0.008) / 0.01).clamp(0.0, 1.0);
      final a = (params.snow * (0.16 + depth * 0.16)).clamp(0.0, 1.0);
      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        short * f.size * 0.45,
        paint..color = Colors.white.withValues(alpha: a),
      );
    }
  }

  void _paintRain(Canvas canvas, Size size, double short) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = short * 0.004
      ..color = const Color(
        0xFFBBD3E6,
      ).withValues(alpha: (params.rain * 0.18).clamp(0.0, 1.0));
    final len = short * 0.045;
    // Thinned-out subset keeps the rain light rather than a downpour.
    for (var i = 0; i < flakes.length; i += 3) {
      final f = flakes[i];
      final speed = f.fallSpeed * 4 + 0.6;
      final y = (f.baseY + clock * speed) % 1.0;
      final x = f.x * size.width + short * 0.02;
      final top = Offset(x, y * size.height);
      canvas.drawLine(top, top.translate(-short * 0.012, len), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WeatherPainter old) => true;
}
