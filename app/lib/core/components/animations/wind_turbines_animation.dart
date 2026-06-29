import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

enum WindTurbinesStatus { loading, error }

class WindTurbinesAnimation extends StatefulWidget {
  const WindTurbinesAnimation({
    super.key,
    this.width = 280,
    this.height = 180,
    this.status = WindTurbinesStatus.loading,
  });

  final double width;
  final double height;
  final WindTurbinesStatus status;

  @override
  State<WindTurbinesAnimation> createState() => _WindTurbinesAnimationState();
}

class _WindTurbinesAnimationState extends State<WindTurbinesAnimation>
    with TickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _elapsed = Duration.zero;
  late final AnimationController _errorController;
  double _frozenElapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _errorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (widget.status == WindTurbinesStatus.error) {
      _errorController.value = 1.0;
    }
    _errorController.addListener(() => setState(() {}));
    _ticker = createTicker((elapsed) {
      setState(() => _elapsed = elapsed);
    })..start();
  }

  @override
  void didUpdateWidget(covariant WindTurbinesAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status == WindTurbinesStatus.error &&
        oldWidget.status != WindTurbinesStatus.error) {
      _frozenElapsedSeconds = _elapsed.inMicroseconds / 1e6;
      _errorController.forward();
    } else if (widget.status == WindTurbinesStatus.loading &&
        oldWidget.status != WindTurbinesStatus.loading) {
      _errorController.reverse();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _errorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsedSeconds = _elapsed.inMicroseconds / 1e6;
    final errorT = Curves.easeInCubic.transform(_errorController.value);

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CustomPaint(
        painter: _WindTurbinesPainter(
          elapsedSeconds: elapsedSeconds,
          frozenElapsedSeconds: _frozenElapsedSeconds,
          errorT: errorT,
        ),
      ),
    );
  }
}

class _TurbineSpec {
  const _TurbineSpec({
    required this.xFraction,
    required this.scale,
    required this.rotationSpeed,
    required this.phaseOffset,
    required this.errorBladeOffset,
    this.isCenter = false,
  });

  final double xFraction;
  final double scale;
  final double rotationSpeed;
  final double phaseOffset;
  final double errorBladeOffset;
  final bool isCenter;
}

class _WindTurbinesPainter extends CustomPainter {
  _WindTurbinesPainter({
    required this.elapsedSeconds,
    required this.frozenElapsedSeconds,
    required this.errorT,
  });

  final double elapsedSeconds;
  final double frozenElapsedSeconds;
  final double errorT;

  static const _periodSeconds = 3.0;

  static const _turbines = [
    _TurbineSpec(
      xFraction: 0.17,
      scale: 0.62,
      rotationSpeed: 1.05,
      phaseOffset: 0.0,
      errorBladeOffset: 0.42,
    ),
    _TurbineSpec(
      xFraction: 0.5,
      scale: 1.0,
      rotationSpeed: 0.9,
      phaseOffset: 0.33,
      errorBladeOffset: -0.28,
      isCenter: true,
    ),
    _TurbineSpec(
      xFraction: 0.83,
      scale: 0.78,
      rotationSpeed: 0.98,
      phaseOffset: 0.66,
      errorBladeOffset: 0.58,
    ),
  ];

  static const _grassColor = Color(0xFF9CCC65);
  static const _grassShadowColor = Color(0xFF689F38);
  static const _errorGrassColor = Color(0xFF8D9A7A);
  static const _errorGrassShadowColor = Color(0xFF6E7568);
  static const _towerColor = Color(0xFFD5DCE6);
  static const _errorTowerColor = Color(0xFFB8BFC8);
  static const _nacelleColor = Color(0xFFA8B2C0);
  static const _errorNacelleColor = Color(0xFF98A0AA);
  static const _bladeColor = Color(0xFFC5CDD8);
  static const _errorBladeColor = Color(0xFFA8B0BA);
  static const _bladeHighlightColor = Color(0xFFE3E8EF);
  static const _errorBladeHighlightColor = Color(0xFFC8CDD4);
  static const _hubColor = Color(0xFF90A4AE);
  static const _errorHubColor = Color(0xFF7A8A94);

  @override
  void paint(Canvas canvas, Size size) {
    final groundY = size.height * 0.88;
    final effectiveElapsed = lerpDouble(
      elapsedSeconds,
      frozenElapsedSeconds,
      errorT,
    )!;

    for (final spec in _turbines) {
      final center = Offset(spec.xFraction * size.width, groundY);
      final bladeRotation =
          (effectiveElapsed /
                  _periodSeconds *
                  spec.rotationSpeed *
                  (1 - errorT * 0.15) +
              spec.phaseOffset +
              spec.errorBladeOffset * errorT) *
          2 *
          math.pi;

      _paintTurbine(
        canvas,
        center: center,
        scale: spec.scale,
        bladeRotation: bladeRotation,
        errorT: errorT,
        isCenter: spec.isCenter,
      );
    }
  }

  void _paintTurbine(
    Canvas canvas, {
    required Offset center,
    required double scale,
    required double bladeRotation,
    required double errorT,
    required bool isCenter,
  }) {
    final towerHeight = 96.0 * scale;
    final towerWidth = 7.0 * scale;
    final hubRadius = 4.5 * scale;
    final bladeLength = 38.0 * scale;
    final bladeWidth = 7.0 * scale;
    final grassRadius = 28.0 * scale;
    final leanRadians = errorT * 0.06 * (isCenter ? 1.0 : -1.0);
    final hubCenter = Offset(center.dx, center.dy - towerHeight);

    final grassColor = Color.lerp(_grassColor, _errorGrassColor, errorT)!;
    final grassShadowColor = Color.lerp(
      _grassShadowColor,
      _errorGrassShadowColor,
      errorT,
    )!;
    final towerColor = Color.lerp(_towerColor, _errorTowerColor, errorT)!;
    final bladeColor = Color.lerp(_bladeColor, _errorBladeColor, errorT)!;
    final bladeHighlightColor = Color.lerp(
      _bladeHighlightColor,
      _errorBladeHighlightColor,
      errorT,
    )!;
    final hubColor = Color.lerp(_hubColor, _errorHubColor, errorT)!;
    final nacelleColor = Color.lerp(_nacelleColor, _errorNacelleColor, errorT)!;

    _paintGrass(
      canvas,
      center: center,
      radius: grassRadius,
      scale: scale,
      grassColor: grassColor,
      shadowColor: grassShadowColor,
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(leanRadians);
    canvas.translate(-center.dx, -center.dy);

    _paintTower(
      canvas,
      base: center,
      top: hubCenter,
      width: towerWidth,
      towerColor: towerColor,
    );

    if (errorT < 0.98) {
      _paintMotionArcs(
        canvas,
        hubCenter: hubCenter,
        radius: bladeLength * 0.72,
        rotation: bladeRotation,
        opacity: (1 - errorT) * 0.35,
      );
    }

    canvas.save();
    canvas.translate(hubCenter.dx, hubCenter.dy);
    canvas.rotate(bladeRotation);

    for (var i = 0; i < 3; i++) {
      canvas.save();
      canvas.rotate(i * 2 * math.pi / 3);
      _paintBlade(
        canvas,
        length: bladeLength,
        width: bladeWidth,
        color: bladeColor,
        highlightColor: bladeHighlightColor,
      );
      canvas.restore();
    }

    canvas.restore();

    _paintNacelle(
      canvas,
      hubCenter: hubCenter,
      scale: scale,
      color: nacelleColor,
    );

    canvas.drawCircle(hubCenter, hubRadius, Paint()..color = hubColor);
    canvas.drawCircle(
      hubCenter,
      hubRadius * 0.45,
      Paint()..color = bladeHighlightColor,
    );

    canvas.restore();
  }

  void _paintGrass(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required double scale,
    required Color grassColor,
    required Color shadowColor,
  }) {
    final shadowRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - 2 * scale),
      width: radius * 2.1,
      height: radius * 0.55,
    );
    canvas.drawOval(
      shadowRect,
      Paint()..color = shadowColor.withValues(alpha: 0.35),
    );

    final grassRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - 4 * scale),
      width: radius * 2,
      height: radius * 0.7,
    );
    canvas.drawOval(grassRect, Paint()..color = grassColor);
  }

  void _paintTower(
    Canvas canvas, {
    required Offset base,
    required Offset top,
    required double width,
    required Color towerColor,
  }) {
    final path = Path()
      ..moveTo(base.dx - width * 0.55, base.dy)
      ..lineTo(top.dx - width * 0.35, top.dy + 6)
      ..lineTo(top.dx + width * 0.35, top.dy + 6)
      ..lineTo(base.dx + width * 0.55, base.dy)
      ..close();

    canvas.drawPath(path, Paint()..color = towerColor);
  }

  void _paintMotionArcs(
    Canvas canvas, {
    required Offset hubCenter,
    required double radius,
    required double rotation,
    required double opacity,
  }) {
    if (opacity <= 0.01) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white.withValues(alpha: opacity);

    for (var i = 0; i < 3; i++) {
      final startAngle = rotation + i * 2 * math.pi / 3 + 0.15;
      canvas.drawArc(
        Rect.fromCircle(center: hubCenter, radius: radius),
        startAngle,
        0.9,
        false,
        paint,
      );
    }
  }

  void _paintBlade(
    Canvas canvas, {
    required double length,
    required double width,
    required Color color,
    required Color highlightColor,
  }) {
    final path = Path()
      ..moveTo(0, -width * 0.2)
      ..quadraticBezierTo(length * 0.45, -width * 0.55, length, 0)
      ..quadraticBezierTo(length * 0.45, width * 0.55, 0, width * 0.2)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = highlightColor.withValues(alpha: 0.7),
    );
  }

  void _paintNacelle(
    Canvas canvas, {
    required Offset hubCenter,
    required double scale,
    required Color color,
  }) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(hubCenter.dx + 5 * scale, hubCenter.dy + 1 * scale),
        width: 14 * scale,
        height: 8 * scale,
      ),
      Radius.circular(2 * scale),
    );
    canvas.drawRRect(rect, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _WindTurbinesPainter oldDelegate) {
    return oldDelegate.elapsedSeconds != elapsedSeconds ||
        oldDelegate.frozenElapsedSeconds != frozenElapsedSeconds ||
        oldDelegate.errorT != errorT;
  }
}
