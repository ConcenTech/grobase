import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'solar_energy_data.dart';

/// Shared layout for the house diagram V2 asset and its reference grid.
///
/// The house occupies ref x `0–[refSize]` (and y `0–[refHeight]`). An extra
/// [sideExtent] of house width is reserved on the right (ref x
/// `[refSize]–[refWidth]`) for side elements such as the grid label.
abstract final class HouseDiagramV2Layout {
  static const assetPath = 'assets/images/house-transparent.png';
  static const poleAssetPath = 'assets/images/utility-pole.png';

  /// [house-transparent.png] is 1072×617.
  static const imageAspect = 1072 / 617;
  static const refSize = 100.0;

  /// Extra width reserved beside the house, as a fraction of house width.
  static const sideExtent = 0.15;

  /// Full reference width including the side strip (`115` with [sideExtent] 0.15).
  static const refWidth = refSize * (1 + sideExtent);

  /// Width / height of the full content rect (house + side strip).
  static const contentAspect = imageAspect * (1 + sideExtent);

  /// Reference height of the coordinate grid over the content rect.
  static const refHeight = 60.0;

  /// Full content (house + side strip), centered in [canvas] at [imageAspect]
  /// with extra width for [sideExtent].
  static Rect contentRect(Size canvas) {
    var w = canvas.width;
    var h = w / contentAspect;
    if (h > canvas.height) {
      h = canvas.height;
      w = h * contentAspect;
    }
    return Rect.fromLTWH((canvas.width - w) / 2, (canvas.height - h) / 2, w, h);
  }

  /// House image only (left [refSize]/[refWidth] of [contentRect]).
  static Rect imageRect(Size canvas) {
    final content = contentRect(canvas);
    return Rect.fromLTWH(
      content.left,
      content.top,
      content.width * refSize / refWidth,
      content.height,
    );
  }

  /// Side strip beside the house (ref x `100–115`).
  static Rect sideRect(Size canvas) {
    final house = imageRect(canvas);
    final content = contentRect(canvas);
    return Rect.fromLTWH(
      house.right,
      content.top,
      content.right - house.right,
      content.height,
    );
  }

  /// Utility pole, scaled down within [sideRect] so it reads as farther back.
  static const poleScale = 0.9;

  static Rect poleRect(Size canvas) {
    final side = sideRect(canvas);
    final h = side.height * poleScale;
    final top = side.top + (side.height - h) / 2;
    return Rect.fromLTWH(side.left, top, side.width, h);
  }

  /// Maps a reference-grid point to canvas coordinates.
  ///
  /// The content rect is divided into [refWidth]×[refHeight] segments.
  /// House art uses x `0–100`; side elements use x `100–115`. Y is `0–60`.
  static Offset map(Offset ref, Size canvas) {
    final content = contentRect(canvas);
    return Offset(
      content.left + ref.dx / refWidth * content.width,
      content.top + ref.dy / refHeight * content.height,
    );
  }

  static List<Offset> mapAll(List<Offset> refs, Size canvas) =>
      refs.map((r) => map(r, canvas)).toList();
}

class SolarDiagramV2BackgroundPainter extends CustomPainter {
  SolarDiagramV2BackgroundPainter({
    required this.data,
    required this.palette,
    required this.t,
    this.nightAmount = 0,
  });

  final SolarEnergyData data;
  final SolarDiagramPalette palette;

  /// Animation clock in seconds.
  final double t;

  /// Continuous day→night blend in `0..1` (0 = day, 1 = night). Drives every
  /// night-dependent colour/glow so day/night transitions animate smoothly.
  final double nightAmount;

  @override
  void paint(Canvas canvas, Size size) {
    final topWindow = GlowPath(
      HouseDiagramV2Layout.map(const Offset(27, 19), size),
      HouseDiagramV2Layout.map(const Offset(30, 16), size),
      HouseDiagramV2Layout.map(const Offset(30, 27), size),
      HouseDiagramV2Layout.map(const Offset(27, 27), size),
    );
    final leftWindow = GlowPath(
      HouseDiagramV2Layout.map(const Offset(19, 32), size),
      HouseDiagramV2Layout.map(const Offset(30, 33), size),
      HouseDiagramV2Layout.map(const Offset(30, 49), size),
      HouseDiagramV2Layout.map(const Offset(19, 46), size),
    );
    final rightWindow = GlowPath(
      HouseDiagramV2Layout.map(const Offset(37, 35), size),
      HouseDiagramV2Layout.map(const Offset(50, 37), size),
      HouseDiagramV2Layout.map(const Offset(50, 48), size),
      HouseDiagramV2Layout.map(const Offset(37, 45), size),
    );
    final doorWindow = GlowPath(
      HouseDiagramV2Layout.map(const Offset(79, 36), size),
      HouseDiagramV2Layout.map(const Offset(81, 36), size),
      HouseDiagramV2Layout.map(const Offset(81, 50), size),
      HouseDiagramV2Layout.map(const Offset(79, 50), size),
    );

    // Transparent battery slot in house-transparent.png (ref 0–100 grid).
    final batteryPosition = GlowPath(
      HouseDiagramV2Layout.map(const Offset(63, 42.5), size),
      HouseDiagramV2Layout.map(const Offset(66, 42), size),
      HouseDiagramV2Layout.map(const Offset(66, 53), size),
      HouseDiagramV2Layout.map(const Offset(63, 54), size),
    );

    final windows = [topWindow, leftWindow, rightWindow, doorWindow];

    for (var window in windows) {
      _paintWindowGlow(canvas, window);
    }
    _paintBatteryGlow(canvas, batteryPosition, t);
  }

  void _paintWindowGlow(Canvas canvas, GlowPath path) {
    final alpha = lerpDouble(0.3, 1, nightAmount)!;

    final color = Color.lerp(
      palette.windowUnlit,
      palette.windowLit,
      nightAmount,
    )!;

    final pane = path.toPath();
    final bounds = pane.getBounds();
    final glowPad = path.radius * 0.5;

    // Opaque base so widgets behind don't show through transparent panes.
    canvas.drawPath(pane, Paint()..color = Colors.white);

    // Soft bloom spilling past the pane.
    canvas.drawPath(
      pane,
      Paint()
        ..color = color.withValues(alpha: alpha * 0.5)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowPad * 1.1),
    );

    // Vertical falloff — brighter near the top, softer at the sill.
    canvas.drawPath(
      pane,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: alpha),
            color.withValues(alpha: alpha * 0.5),
            color.withValues(alpha: 0),
          ],
          stops: const [0.0, 0.4, 1.0],
        ).createShader(bounds),
    );
  }

  void _paintBatteryGlow(Canvas canvas, GlowPath path, double t) {
    final fillColor = SolarDiagramPalette.batteryColor(data.batteryLevel / 100);
    final slot = path.toPath();

    canvas.save();
    canvas.clipPath(slot);
    canvas.drawPath(
      path.sliceFromBottom(0, data.batteryLevel / 100),
      Paint()..color = fillColor.withValues(alpha: 0.85),
    );

    if (data.isCharging || data.isDischarging) {
      // Charging rises (f↑ toward top); discharging falls.
      final direction = data.isCharging ? 1.0 : -1.0;
      final bandPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      const bandHalfNorm = 0.045;
      const bandCount = 3;
      for (var i = 0; i < bandCount; i++) {
        var f = (i / bandCount) + direction * 0.6 * t;
        f %= 1.0;
        if (f < 0) f += 1.0;
        canvas.drawPath(
          path.sliceFromBottom(f - bandHalfNorm, f + bandHalfNorm),
          bandPaint,
        );
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant SolarDiagramV2BackgroundPainter oldDelegate) {
    return nightAmount != oldDelegate.nightAmount ||
        data != oldDelegate.data ||
        palette != oldDelegate.palette ||
        t != oldDelegate.t;
  }
}

class GlowPath {
  final Offset topLeft;
  final Offset topRight;
  final Offset bottomLeft;
  final Offset bottomRight;

  const GlowPath(
    this.topLeft,
    this.topRight,
    this.bottomRight,
    this.bottomLeft,
  );

  Path toPath() {
    return Path()
      ..moveTo(topLeft.dx, topLeft.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..close();
  }

  /// Sub-path between [bottom] and [top] as fractions of the vertical span
  /// (0 = bottom edge, 1 = top edge), following the skewed sides.
  Path sliceFromBottom(double bottom, double top) {
    bottom = bottom.clamp(0.0, 1.0);
    top = top.clamp(0.0, 1.0);
    if (top <= bottom) return Path();

    final l0 = Offset.lerp(bottomLeft, topLeft, bottom)!;
    final r0 = Offset.lerp(bottomRight, topRight, bottom)!;
    final l1 = Offset.lerp(bottomLeft, topLeft, top)!;
    final r1 = Offset.lerp(bottomRight, topRight, top)!;

    return Path()
      ..moveTo(l0.dx, l0.dy)
      ..lineTo(r0.dx, r0.dy)
      ..lineTo(r1.dx, r1.dy)
      ..lineTo(l1.dx, l1.dy)
      ..close();
  }

  double get width =>
      max((topRight - topLeft).distance, (bottomRight - bottomLeft).distance);
  double get height =>
      max((bottomLeft - topLeft).distance, (bottomRight - topRight).distance);

  double get radius => min(width, height) / 2;
}
