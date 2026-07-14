import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'solar_diagram_v2_background_painter.dart';
import 'solar_energy_data.dart';

class SolarDiagramV2ForegroundPainter extends CustomPainter {
  SolarDiagramV2ForegroundPainter({
    required this.data,
    required this.palette,
    required this.t,
    this.nightAmount = 0,
  });

  final SolarEnergyData data;
  final SolarDiagramPalette palette;

  /// Animation clock in seconds.
  final double t;

  /// Continuous day→night blend in `0..1` (0 = day, 1 = night).
  final double nightAmount;

  static const _lineWidth = 2.0;

  static const _energyLines = <List<Offset>>[
    // Solar to hub
    [Offset(86.5, 25.5), Offset(89, 28), Offset(89, 30), Offset(89, 37.75)],
    // Battery to hub
    [Offset(63, 40.25), Offset(63, 35), Offset(87, 31.5), Offset(87, 38)],
    // Grid to hub
    [Offset(106, 48.5), Offset(96, 48.5), Offset(90, 49.5), Offset(90, 45.5)],
    // House to hub
    [Offset(82.5, 51), Offset(87.5, 50), Offset(87.5, 46)],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final lines = _energyLines
        .map((line) => HouseDiagramV2Layout.mapAll(line, size))
        .toList();
    final cornerRadius =
        HouseDiagramV2Layout.contentRect(size).shortestSide * 0.03;

    for (final line in lines) {
      _paintIdleLine(canvas, line, cornerRadius);
    }
    // Positive power = flowing toward the hub.
    _paintFlowLine(canvas, lines[0], data.solarWatts, cornerRadius, true);
    _paintFlowLine(
      canvas,
      lines[1],
      data.batteryWatts,
      cornerRadius,
      data.batteryWatts.isNegative,
    );
    _paintFlowLine(
      canvas,
      lines[2],
      data.gridWatts,
      cornerRadius,
      !data.gridWatts.isNegative,
    );
    _paintFlowLine(canvas, lines[3], data.houseWatts, cornerRadius, false);

    // _paintLabels(canvas, size);
  }

  void _paintIdleLine(Canvas canvas, List<Offset> line, double cornerRadius) {
    canvas.drawPath(
      _curvedPath(line, cornerRadius),
      Paint()
        ..style = PaintingStyle.stroke
        ..color = palette.idleLine
        ..strokeWidth = _lineWidth
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
  }

  /// Paints the fill→drain flow animation along [points].
  ///
  /// [power] is signed, using the same threshold as labels
  /// ([SolarEnergyData.epsilon]): `> epsilon` flows toward the hub,
  /// `< -epsilon` flows away, otherwise idle (no flow paint).
  void _paintFlowLine(
    Canvas canvas,
    List<Offset> points,
    double power,
    double cornerRadius,
    bool isToHub,
  ) {
    const epsilon = SolarEnergyData.epsilon;

    if (points.length < 2 || power.abs() < epsilon) return;

    final metrics = _curvedPath(points, cornerRadius).computeMetrics().toList();
    if (metrics.isEmpty || metrics.first.length == 0) return;
    final metric = metrics.first;
    final length = metric.length;

    // Indeterminate fill → drain in the flow direction (same idea as a linear
    // progress indicator): leading edge advances to fill, then trailing edge
    // advances to empty, then repeat.
    const speed = 0.35; // cycles per second
    final baseCycle = (t * speed) % 1.0;
    // Outbound lines lag by half a cycle so their pulse starts when inbound
    // heads reach the hub. (Must be 0.5 — 1.0 wraps to 0 via % 1.0.)
    final cycle = isToHub ? baseCycle : (baseCycle + 0.5) % 1.0;
    final double tail;
    final double head;
    if (cycle < 0.5) {
      tail = 0;
      head = cycle * 2;
    } else {
      tail = (cycle - 0.5) * 2;
      head = 1;
    }
    if (head - tail < 1e-4) return;

    // Flow-space 0 = origin, 1 = destination. Map onto path metrics.
    final double start;
    final double end;
    if (isToHub) {
      start = tail * length;
      end = head * length;
    } else {
      start = (1 - head) * length;
      end = (1 - tail) * length;
    }

    final segment = metric.extractPath(start, end);
    final color = palette.flowColor;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _lineWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(
      segment,
      stroke
        ..color = color.withValues(alpha: 0.85)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawPath(
      segment,
      stroke
        ..color = color
        ..maskFilter = null,
    );
  }

  /// Polyline with quadratic bends at each interior vertex.
  Path _curvedPath(List<Offset> points, double radius) {
    if (points.length < 2) return Path();
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    if (points.length == 2) {
      path.lineTo(points.last.dx, points.last.dy);
      return path;
    }

    for (var i = 1; i < points.length - 1; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final next = points[i + 1];

      final toPrev = prev - curr;
      final toNext = next - curr;
      final distPrev = toPrev.distance;
      final distNext = toNext.distance;

      if (distPrev < 1e-6 || distNext < 1e-6) {
        path.lineTo(curr.dx, curr.dy);
        continue;
      }

      final r = math.min(radius, math.min(distPrev, distNext) * 0.5);
      final p1 = curr + toPrev * (r / distPrev);
      final p2 = curr + toNext * (r / distNext);

      path.lineTo(p1.dx, p1.dy);
      path.quadraticBezierTo(curr.dx, curr.dy, p2.dx, p2.dy);
    }

    path.lineTo(points.last.dx, points.last.dy);
    return path;
  }

  void _label(
    Canvas canvas,
    Offset node,
    double r, {
    required bool below,
    required String title,
    required String value,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title\n',
            style: TextStyle(
              color: palette.label,
              fontSize: r * 0.34,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: palette.label,
              fontSize: r * 0.3,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: r * 4);

    final padX = r * 0.28;
    final padY = r * 0.16;
    final dy = below ? node.dy + r * 1.15 : node.dy - r * 1.15 - tp.height;
    final origin = Offset(node.dx - tp.width / 2, dy);
    final bg = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        origin.dx - padX,
        origin.dy - padY,
        tp.width + padX * 2,
        tp.height + padY * 2,
      ),
      Radius.circular(r * 0.22),
    );
    canvas.drawRRect(
      bg,
      Paint()..color = palette.surface.withValues(alpha: 0.42),
    );
    canvas.drawRRect(
      bg,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = palette.surfaceBorder,
    );
    tp.paint(canvas, origin);
  }

  void _paintLabels(Canvas canvas, Size size) {
    final r = HouseDiagramV2Layout.contentRect(size).shortestSide * 0.1;
    _label(
      canvas,
      HouseDiagramV2Layout.map(const Offset(87, 20), size),
      r,
      below: true,
      title: 'Solar',
      value: _fmtWatts(data.solarWatts),
    );
    // Side strip (ref x 100–115).
    _label(
      canvas,
      HouseDiagramV2Layout.map(const Offset(107, 65), size),
      r,
      below: true,
      title: 'Grid',
      value: _gridValueText(),
    );
    _label(
      canvas,
      HouseDiagramV2Layout.map(const Offset(66, 115), size),
      r,
      below: false,
      title: 'Battery',
      value: _batteryValueText(),
    );
    _label(
      canvas,
      HouseDiagramV2Layout.map(const Offset(107, 83), size),
      r,
      below: false,
      title: 'Load',
      value: _fmtWatts(data.houseWatts),
    );
  }

  String _gridValueText() {
    if (data.isImporting) return 'Import ${_fmtWatts(data.gridWatts)}';
    if (data.isExporting) return 'Export ${_fmtWatts(data.gridWatts)}';
    return 'Idle';
  }

  String _batteryValueText() {
    if (data.isCharging) return '+ ${_fmtWatts(data.batteryWatts)}';
    if (data.isDischarging) {
      return '- ${_fmtWatts(data.batteryWatts)}';
    }
    return 'Idle';
  }

  String _fmtWatts(double w) {
    final a = w.abs();
    if (a < 1000) return '${a.round()} W';
    return '${(a / 1000).toStringAsFixed(1)} kW';
  }

  @override
  bool shouldRepaint(SolarDiagramV2ForegroundPainter oldDelegate) {
    return data != oldDelegate.data ||
        palette != oldDelegate.palette ||
        t != oldDelegate.t ||
        nightAmount != oldDelegate.nightAmount;
  }
}
