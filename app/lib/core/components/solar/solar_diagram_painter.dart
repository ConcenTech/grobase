import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'solar_energy_data.dart';

/// Paints the full solar/charging status scene: four corner nodes connected by
/// right-angle (orthogonal) routes to a central transfer square, animated
/// energy-flow dots along each connection, the battery charge animation and the
/// night-time house illumination.
///
/// Flow conveys direction only (to/from a segment): every connection shares the
/// same dot colour, speed, count and size. Repainting is driven by [phase] (a
/// continuously increasing value in seconds).
class SolarDiagramPainter extends CustomPainter {
  SolarDiagramPainter({
    required this.data,
    required this.palette,
    required this.phase,
    this.showGarage = true,
    this.paintBackground = true,
    this.nightAmount = 0,
  }) : super(repaint: phase);

  final SolarEnergyData data;
  final SolarDiagramPalette palette;
  final ValueListenable<double> phase;

  /// Continuous day→night blend in `0..1` (0 = day, 1 = night). Drives every
  /// night-dependent colour/glow so day/night transitions animate smoothly.
  final double nightAmount;

  /// Whether to draw a garage attached to the right of the house.
  final bool showGarage;

  /// Whether to fill the canvas with [SolarDiagramPalette.background]. Disabled
  /// when an animated weather sky is rendered behind the diagram.
  final bool paintBackground;

  @override
  void paint(Canvas canvas, Size size) {
    final t = phase.value;
    final layout = _Layout(size);

    if (paintBackground) _paintBackground(canvas, size);

    // 1. Idle base lines for every connection (orthogonal elbow routes).
    for (final node in EnergyNode.values) {
      _paintIdleLine(canvas, layout.pathOf(node));
    }

    // 2. Animated flow dots (drawn under the icons so the ends are masked).
    for (final node in EnergyNode.values) {
      _paintFlow(canvas, node, layout, t);
    }

    // 3. Central transfer square where the connections meet.
    _paintHub(canvas, layout.center, layout.squareHalf, t);

    // 4. Node icons.
    _paintSolar(canvas, layout.nodeOf(EnergyNode.solar), layout.iconR);
    _paintGrid(canvas, layout.nodeOf(EnergyNode.grid), layout.iconR);
    _paintBattery(canvas, layout.nodeOf(EnergyNode.battery), layout.iconR, t);
    _paintHouse(canvas, layout.nodeOf(EnergyNode.house), layout.iconR);

    // 5. Labels.
    _paintLabels(canvas, layout);
  }

  // ---------------------------------------------------------------------------
  // Background
  // ---------------------------------------------------------------------------

  void _paintBackground(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = palette.background);
  }

  // ---------------------------------------------------------------------------
  // Connections
  // ---------------------------------------------------------------------------

  void _paintIdleLine(Canvas canvas, List<Offset> pts) {
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      path.lineTo(pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = palette.idleLine
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
  }

  /// Signed flow toward the centre for [node]. Positive => dots travel from the
  /// node toward the central junction.
  double _flowToCentre(EnergyNode node) {
    switch (node) {
      case EnergyNode.solar:
        return data.solarWatts; // generation feeds the centre
      case EnergyNode.grid:
        return data.gridWatts; // import (+) flows toward the centre
      case EnergyNode.battery:
        return -data.batteryWatts; // charging (+) flows away from the centre
      case EnergyNode.house:
        return -data.houseWatts; // consumption flows away from the centre
    }
  }

  void _paintFlow(Canvas canvas, EnergyNode node, _Layout layout, double t) {
    final flow = _flowToCentre(node);
    if (flow.abs() < 1) return; // no flow on this connection

    // Direction is the only thing power conveys here; colour, speed, dot count
    // and size are identical for every connection.
    final dir = flow >= 0 ? 1.0 : -1.0; // +1 => node -> square
    const count = 4;
    const speed = 0.32; // cycles per second, shared by all connections
    final dotR = layout.iconR * 0.1;

    final pts = layout.pathOf(node);
    final color = palette.flowColor;
    final glow = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..maskFilter = const ui.MaskFilter.blur(BlurStyle.normal, 4);
    final core = Paint()..color = color;

    for (var k = 0; k < count; k++) {
      var f = (k / count) + dir * speed * t;
      f %= 1.0;
      if (f < 0) f += 1.0;
      final p = _pointAlong(pts, f);
      canvas.drawCircle(p, dotR * 1.7, glow);
      canvas.drawCircle(p, dotR, core);
    }
  }

  /// Point at fraction [f] (0..1) of the total length along the polyline [pts].
  Offset _pointAlong(List<Offset> pts, double f) {
    final lengths = <double>[];
    var total = 0.0;
    for (var i = 0; i < pts.length - 1; i++) {
      final l = (pts[i + 1] - pts[i]).distance;
      lengths.add(l);
      total += l;
    }
    if (total == 0) return pts.first;

    var target = f.clamp(0.0, 1.0) * total;
    for (var i = 0; i < lengths.length; i++) {
      if (target <= lengths[i] || i == lengths.length - 1) {
        final lt = lengths[i] == 0
            ? 0.0
            : (target / lengths[i]).clamp(0.0, 1.0);
        return Offset.lerp(pts[i], pts[i + 1], lt)!;
      }
      target -= lengths[i];
    }
    return pts.last;
  }

  // ---------------------------------------------------------------------------
  // Central junction
  // ---------------------------------------------------------------------------

  /// The central junction, drawn as a small 3/4-view inverter / distribution
  /// box: depth faces, a glowing display strip and a breathing status LED.
  void _paintHub(Canvas canvas, Offset c, double half, double t) {
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = _techOutline;

    final metal = _tone(const Color(0xFFB6C0CB));

    final w = half * 1.7;
    final h = half * 2.0;
    final fl = c.dx - w / 2;
    final fr = c.dx + w / 2;
    final ft = c.dy - h / 2;
    final fb = c.dy + h / 2;

    // Flat 2D inverter face (no extrusion).
    final front = RRect.fromRectAndRadius(
      Rect.fromLTRB(fl, ft, fr, fb),
      Radius.circular(half * 0.16),
    );
    canvas.drawRRect(front, Paint()..color = metal);
    canvas.drawRRect(front, outline);

    // Display strip glowing in the flow colour (upper portion).
    final screenRect = Rect.fromLTRB(
      fl + w * 0.15,
      ft + h * 0.12,
      fr - w * 0.15,
      ft + h * 0.44,
    );
    final screen = RRect.fromRectAndRadius(
      screenRect,
      Radius.circular(half * 0.06),
    );
    canvas.drawRRect(screen, Paint()..color = _tone(const Color(0xFF18222D)));
    final bar = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..color = palette.flowColor.withValues(alpha: 0.8);
    for (var i = 0; i < 2; i++) {
      final y = screenRect.top + screenRect.height * (0.38 + i * 0.34);
      canvas.drawLine(
        Offset(screenRect.left + w * 0.06, y),
        Offset(screenRect.right - w * 0.06, y),
        bar,
      );
    }
    canvas.drawRRect(screen, outline);

    // Cooling vents (lower-right).
    final vent = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..color = _techOutline.withValues(alpha: 0.55);
    for (var i = 0; i < 3; i++) {
      final y = fb - h * 0.12 - i * h * 0.11;
      canvas.drawLine(
        Offset(c.dx + w * 0.02, y),
        Offset(fr - w * 0.16, y),
        vent,
      );
    }

    // Breathing status LED (lower-left). Triangle-wave pulse avoids importing
    // dart:math just for a sine.
    final ph = (t % 1.6) / 1.6;
    final pulse = ph < 0.5 ? ph * 2 : (1 - ph) * 2;
    final led = Offset(fl + w * 0.22, fb - h * 0.2);
    const ledColor = Color(0xFF54D17A);
    canvas.drawCircle(
      led,
      half * 0.17,
      Paint()
        ..color = ledColor.withValues(alpha: 0.25 + 0.45 * pulse)
        ..maskFilter = ui.MaskFilter.blur(BlurStyle.normal, half * 0.12),
    );
    canvas.drawCircle(led, half * 0.075, Paint()..color = ledColor);
    canvas.drawCircle(led, half * 0.075, outline);
  }

  // ---------------------------------------------------------------------------
  // Solar panel
  // ---------------------------------------------------------------------------

  /// Dims a base colour toward night so the tech icons recede in step with the
  /// house, while a separate outline colour keeps them readable on both skies.
  Color _tone(Color cc) =>
      Color.lerp(cc, const Color(0xFF0B1530), 0.4 * nightAmount)!;

  /// Shared muted outline (slate by day, paler by night) for the solar / grid /
  /// battery casings.
  Color get _techOutline => Color.lerp(
    const Color(0xFF5C6675),
    const Color(0xFF8B95A3),
    nightAmount,
  )!;

  void _paintSolar(Canvas canvas, Offset c, double r) {
    final na = nightAmount;
    final outlineCol = _techOutline;
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = outlineCol;

    final metal = _tone(const Color(0xFFAEB8C4));
    final metalDark = _tone(const Color(0xFF7C8896));
    final cellFill = _tone(const Color(0xFF35598C));
    final cellLineCol = _tone(const Color(0xFF6E97CE));
    final frameFill = _tone(const Color(0xFFC7D0DA));

    final groundY = c.dy + r * 0.92;

    // Tilted panel (parallelogram for perspective).
    final skew = r * 0.26;
    final tl = Offset(c.dx - r + skew, c.dy - r * 0.72);
    final tr = Offset(c.dx + r + skew, c.dy - r * 0.72);
    final br = Offset(c.dx + r - skew, c.dy + r * 0.18);
    final bl = Offset(c.dx - r - skew, c.dy + r * 0.18);
    final panelBottom = Offset.lerp(bl, br, 0.5)!;

    // Support post + foot (behind the panel).
    final post = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        c.dx - r * 0.08,
        panelBottom.dy - r * 0.04,
        c.dx + r * 0.08,
        groundY,
      ),
      Radius.circular(r * 0.04),
    );
    canvas.drawRRect(post, Paint()..color = metal);
    canvas.drawRRect(post, outline);
    final foot = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(c.dx, groundY),
        width: r * 0.66,
        height: r * 0.12,
      ),
      Radius.circular(r * 0.05),
    );
    canvas.drawRRect(foot, Paint()..color = metalDark);
    canvas.drawRRect(foot, outline);

    // Panel thickness (a slim band under the front edge for depth).
    final th = r * 0.12;
    final edge = Path()
      ..addPolygon([
        bl,
        br,
        Offset(br.dx, br.dy + th),
        Offset(bl.dx, bl.dy + th),
      ], true);
    canvas.drawPath(edge, Paint()..color = metalDark);
    canvas.drawPath(edge, outline);

    // Front face (photovoltaic cells).
    final panel = Path()..addPolygon([tl, tr, br, bl], true);
    canvas.drawPath(panel, Paint()..color = cellFill);

    // Cell grid: 4 columns x 2 rows.
    final cellLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = cellLineCol;
    for (var i = 1; i < 4; i++) {
      final f = i / 4;
      canvas.drawLine(
        Offset.lerp(tl, tr, f)!,
        Offset.lerp(bl, br, f)!,
        cellLine,
      );
    }
    canvas.drawLine(
      Offset.lerp(tl, bl, 0.5)!,
      Offset.lerp(tr, br, 0.5)!,
      cellLine,
    );

    // Glare highlight (fades out toward night): a slim bright band.
    if (na < 0.999) {
      final s1 = Offset.lerp(tl, tr, 0.08)!;
      final s2 = Offset.lerp(tl, tr, 0.24)!;
      final s3 = Offset.lerp(bl, br, 0.24)!;
      final s4 = Offset.lerp(bl, br, 0.08)!;
      canvas.drawPath(
        Path()..addPolygon([s1, s2, s3, s4], true),
        Paint()..color = Colors.white.withValues(alpha: 0.18 * (1 - na)),
      );
    }

    // Light metallic frame, then the thin dark outline for a beveled edge.
    canvas.drawPath(
      panel,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeJoin = StrokeJoin.round
        ..color = frameFill,
    );
    canvas.drawPath(panel, outline);
  }

  // ---------------------------------------------------------------------------
  // Grid pylon (transmission tower)
  // ---------------------------------------------------------------------------

  void _paintGrid(Canvas canvas, Offset c, double r) {
    final outlineCol = _techOutline;
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = outlineCol;

    final metal = _tone(const Color(0xFFAEB8C4));
    final metalDark = _tone(const Color(0xFF7C8896));
    final brace = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = _tone(const Color(0xFF6E7A88));

    final topY = c.dy - r * 0.78;
    final botY = c.dy + r * 0.92;
    final topHalf = r * 0.18;
    final botHalf = r * 0.5;

    final tl = Offset(c.dx - topHalf, topY);
    final tr = Offset(c.dx + topHalf, topY);
    final bl = Offset(c.dx - botHalf, botY);
    final br = Offset(c.dx + botHalf, botY);

    double halfAt(double f) => topHalf + (botHalf - topHalf) * f;
    double yAt(double f) => topY + (botY - topY) * f;

    // Base feet.
    for (final s in [-1.0, 1.0]) {
      final fx = c.dx + s * botHalf;
      final footRect = RRect.fromRectAndRadius(
        Rect.fromLTRB(
          fx - r * 0.12,
          botY - r * 0.04,
          fx + r * 0.12,
          botY + r * 0.08,
        ),
        Radius.circular(r * 0.03),
      );
      canvas.drawRRect(footRect, Paint()..color = metalDark);
      canvas.drawRRect(footRect, outline);
    }

    // Tapered tower body — a faint fill so it reads as open lattice, not a
    // heavy solid block.
    final body = Path()..addPolygon([tl, tr, br, bl], true);
    canvas.drawPath(body, Paint()..color = metal.withValues(alpha: 0.2));

    // Lattice: horizontal rungs + alternating X cross-braces between them.
    const rungs = [0.0, 0.26, 0.52, 0.78, 1.0];
    for (final f in rungs) {
      final h = halfAt(f);
      final y = yAt(f);
      canvas.drawLine(Offset(c.dx - h, y), Offset(c.dx + h, y), brace);
    }
    for (var i = 0; i < rungs.length - 1; i++) {
      final f0 = rungs[i];
      final f1 = rungs[i + 1];
      final lt = Offset(c.dx - halfAt(f0), yAt(f0));
      final rt = Offset(c.dx + halfAt(f0), yAt(f0));
      final lb = Offset(c.dx - halfAt(f1), yAt(f1));
      final rb = Offset(c.dx + halfAt(f1), yAt(f1));
      canvas.drawLine(lt, rb, brace);
      canvas.drawLine(rt, lb, brace);
    }
    canvas.drawPath(body, outline);

    // Pointed top.
    final apex = Offset(c.dx, topY - r * 0.2);
    final top = Path()..addPolygon([tl, tr, apex], true);
    canvas.drawPath(top, Paint()..color = metal);
    canvas.drawPath(top, outline);

    // Two cross-arms with hanging insulators.
    void arm(double y, double half, double h) {
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(c.dx, y), width: half * 2, height: h),
        Radius.circular(h / 2),
      );
      canvas.drawRRect(rect, Paint()..color = metal);
      canvas.drawRRect(rect, outline);
      for (final s in [-1.0, 1.0]) {
        final p = Offset(c.dx + s * (half - h * 0.2), y + h * 0.5 + r * 0.05);
        canvas.drawCircle(p, r * 0.05, Paint()..color = metalDark);
        canvas.drawCircle(p, r * 0.05, outline);
      }
    }

    arm(topY + r * 0.12, r * 0.88, r * 0.1);
    arm(topY + r * 0.44, r * 0.64, r * 0.09);
  }

  // ---------------------------------------------------------------------------
  // Battery (with charge / discharge animation)
  // ---------------------------------------------------------------------------

  void _paintBattery(Canvas canvas, Offset c, double r, double t) {
    // Drop the icon a few pixels below its node so it clears the label above
    // (the flow connection still anchors to the node centre).
    c = c.translate(0, r * 0.2);
    // Muted neutral-grey outline so the casing recedes and the fill colour
    // leads. A darker grey reads against the light-blue day sky; a paler grey
    // against the dark night sky — lerped by nightAmount.
    final outlineColor = Color.lerp(
      const Color(0xFF5C6675),
      const Color(0xFF8B95A3),
      nightAmount,
    )!;
    final bodyW = r * 1.15;
    final bodyH = r * 1.85;
    final body = Rect.fromCenter(center: c, width: bodyW, height: bodyH);
    final bodyR = RRect.fromRectAndRadius(body, Radius.circular(r * 0.18));

    // Terminal nub.
    final nub = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(c.dx, body.top - r * 0.12),
        width: bodyW * 0.42,
        height: r * 0.22,
      ),
      Radius.circular(r * 0.06),
    );
    canvas.drawRRect(
      nub,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = outlineColor,
    );

    // Body is transparent: only the charge fill + animation carry colour.

    // Fill region clipped to the inner body.
    final inset = r * 0.14;
    final inner = RRect.fromRectAndRadius(
      body.deflate(inset),
      Radius.circular(r * 0.12),
    );
    // Fill colour reflects state of charge (red → amber → green).
    final fillColor = SolarDiagramPalette.batteryColor(data.batteryLevel / 100);
    final innerRect = inner.outerRect;
    final fillTop = innerRect.bottom - innerRect.height * data.batteryLevel;
    final fillRect = Rect.fromLTRB(
      innerRect.left,
      fillTop,
      innerRect.right,
      innerRect.bottom,
    );

    canvas.save();
    canvas.clipRRect(inner);
    canvas.drawRect(
      fillRect,
      Paint()..color = fillColor.withValues(alpha: 0.85),
    );

    // Moving wave bands convey charge (up) / discharge (down) direction.
    if (data.isCharging || data.isDischarging) {
      final dir = data.isCharging ? -1.0 : 1.0;
      final bandPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.22)
        ..maskFilter = const ui.MaskFilter.blur(BlurStyle.normal, 3);
      final span = innerRect.height;
      const bandCount = 3;
      for (var i = 0; i < bandCount; i++) {
        var f = (i / bandCount) + dir * 0.6 * t;
        f %= 1.0;
        if (f < 0) f += 1.0;
        final y = innerRect.bottom - f * span;
        canvas.drawRect(
          Rect.fromLTRB(
            innerRect.left,
            y - r * 0.07,
            innerRect.right,
            y + r * 0.07,
          ),
          bandPaint,
        );
      }
    }
    canvas.restore();

    // Body outline.
    canvas.drawRRect(
      bodyR,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = outlineColor,
    );
  }

  // ---------------------------------------------------------------------------
  // House (with night illumination)
  // ---------------------------------------------------------------------------

  void _paintHouse(Canvas canvas, Offset centre, double baseR) {
    final na = nightAmount;
    // The house reads a little small next to the other icons, so draw it larger.
    final r = baseR * 1.3;

    // Cottage palette (muted cream + terracotta) that reads on both the light
    // and the dark/night backgrounds. Faces are dimmed toward night so the warm
    // windows pop.
    Color tone(Color cc) => Color.lerp(cc, const Color(0xFF0B1530), 0.4 * na)!;
    final wall = tone(const Color(0xFFF2E7D0));
    final wallSide = tone(const Color(0xFFD8C4A0));
    final roof = tone(const Color(0xFFCE7E62));
    final roofSide = tone(const Color(0xFFAC6047));
    final doorCol = tone(const Color(0xFF8B5A3B));
    const outlineCol = Color(0xFF453932);

    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = outlineCol;

    final groundY = centre.dy + r * 0.86;

    // Soft glow spilling from the house at night (fades in with nightAmount).
    if (na > 0.001) {
      canvas.drawCircle(
        centre,
        r * 1.7,
        Paint()
          ..color = palette.windowLit.withValues(alpha: 0.16 * na)
          ..maskFilter = ui.MaskFilter.blur(BlurStyle.normal, r * 0.6),
      );
    }

    // Grounding shadow (wider when the garage is present).
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(
          centre.dx + r * (showGarage ? 0.25 : 0.05),
          groundY + r * 0.04,
        ),
        width: r * (showGarage ? 2.7 : 1.9),
        height: r * 0.28,
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.14 + 0.21 * na)
        ..maskFilter = ui.MaskFilter.blur(BlurStyle.normal, r * 0.1),
    );

    // 3/4-view geometry. Depth vector pushes faces back-right and up.
    final dxp = r * 0.30;
    final dyp = -r * 0.18;
    final fbl = Offset(centre.dx - r * 0.66, groundY);
    final fbr = Offset(centre.dx + r * 0.30, groundY);
    final ftr = Offset(centre.dx + r * 0.30, centre.dy + r * 0.04);
    final ftl = Offset(centre.dx - r * 0.66, centre.dy + r * 0.04);
    final sbr = Offset(fbr.dx + dxp, fbr.dy + dyp);
    final str = Offset(ftr.dx + dxp, ftr.dy + dyp);
    final apexF = Offset(centre.dx - r * 0.18, centre.dy - r * 0.5);
    final apexB = Offset(apexF.dx + dxp, apexF.dy + dyp);

    void poly(List<Offset> pts, Color fill) {
      final p = Path()..addPolygon(pts, true);
      canvas.drawPath(p, Paint()..color = fill);
      canvas.drawPath(p, outline);
    }

    // Right side wall + right roof slope (the shaded "depth" faces).
    poly([fbr, sbr, str, ftr], wallSide);
    poly([ftr, str, apexB, apexF], roofSide);

    // Chimney (3D box) sitting on the right roof slope.
    final chx0 = centre.dx + r * 0.08;
    final chx1 = centre.dx + r * 0.2;
    final chTop = centre.dy - r * 0.52;
    final chBot = centre.dy - r * 0.16;
    final chD = Offset(dxp * 0.35, dyp * 0.35);
    poly([
      Offset(chx1, chTop),
      Offset(chx1 + chD.dx, chTop + chD.dy),
      Offset(chx1 + chD.dx, chBot + chD.dy),
      Offset(chx1, chBot),
    ], roofSide);
    poly([
      Offset(chx0, chTop),
      Offset(chx1, chTop),
      Offset(chx1, chBot),
      Offset(chx0, chBot),
    ], doorCol);

    // Front wall + front gable.
    poly([fbl, fbr, ftr, ftl], wall);
    poly([ftl, ftr, apexF], roof);

    // Arched wooden door.
    final doorW = r * 0.23;
    final doorH = r * 0.42;
    final doorCx = centre.dx - r * 0.18;
    final door = RRect.fromRectAndCorners(
      Rect.fromLTRB(
        doorCx - doorW / 2,
        groundY - doorH,
        doorCx + doorW / 2,
        groundY,
      ),
      topLeft: Radius.circular(doorW / 2),
      topRight: Radius.circular(doorW / 2),
    );
    canvas.drawRRect(
      door,
      Paint()
        ..color = Color.lerp(
          doorCol,
          palette.windowLit.withValues(alpha: 0.9),
          na,
        )!,
    );
    canvas.drawRRect(door, outline);
    canvas.drawCircle(
      Offset(doorCx + doorW * 0.28, groundY - doorH * 0.42),
      r * 0.03,
      Paint()..color = outlineCol,
    );

    // Two storeys of glass windows on the front wall (upper row + a ground
    // floor row flanking the door).
    final winSize = r * 0.21;
    const winXs = [-0.5, 0.12];
    const winYs = [0.27, 0.62];
    for (final wy in winYs) {
      for (final wx in winXs) {
        _paintHouseWindow(
          canvas,
          Offset(centre.dx + r * wx, centre.dy + r * wy),
          winSize,
          outlineCol,
          na,
        );
      }
    }

    // Garage attached to the right (shares the house's front-right corner).
    // Squished vertically around the ground line so it's shorter (less tall &
    // skinny) than the house while staying grounded.
    if (showGarage) {
      canvas.save();
      canvas.translate(0, groundY);
      canvas.scale(1, 0.78);
      canvas.translate(0, -groundY);

      final gL = centre.dx + r * 0.3;
      final gR = centre.dx + r * 0.78;
      final gEaveY = centre.dy + r * 0.12;
      final gApex = Offset((gL + gR) / 2, centre.dy - r * 0.26);
      final gApexB = Offset(gApex.dx + dxp, gApex.dy + dyp);
      final gtl = Offset(gL, gEaveY);
      final gtr = Offset(gR, gEaveY);
      final gbr = Offset(gR, groundY);
      final gsbr = Offset(gR + dxp, groundY + dyp);
      final gstr = Offset(gR + dxp, gEaveY + dyp);

      // Right side wall + right roof slope (depth faces).
      poly([gbr, gsbr, gstr, gtr], wallSide);
      poly([gtr, gstr, gApexB, gApex], roofSide);

      // Front wall + front gable.
      poly([Offset(gL, groundY), gbr, gtr, gtl], wall);
      poly([gtl, gtr, gApex], roof);

      // Up-and-over door.
      final dL = gL + r * 0.07;
      final dR = gR - r * 0.07;
      final dTop = centre.dy + r * 0.22;
      final dBot = groundY - r * 0.02;
      final garageDoor = RRect.fromRectAndCorners(
        Rect.fromLTRB(dL, dTop, dR, dBot),
        topLeft: Radius.circular(r * 0.05),
        topRight: Radius.circular(r * 0.05),
      );
      canvas.drawRRect(
        garageDoor,
        Paint()..color = tone(const Color(0xFFE4DDCE)),
      );
      canvas.drawRRect(garageDoor, outline);

      // Panel grooves.
      final groove = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = outlineCol.withValues(alpha: 0.5);
      for (var i = 1; i < 4; i++) {
        final y = dTop + (dBot - dTop) * i / 4;
        canvas.drawLine(Offset(dL, y), Offset(dR, y), groove);
      }

      // Row of small windows along the top of the door (lit at night).
      final gwY = dTop + r * 0.085;
      final gwSize = r * 0.1;
      for (var i = 0; i < 3; i++) {
        final wx = dL + (dR - dL) * (i + 0.5) / 3;
        final wr = Rect.fromCenter(
          center: Offset(wx, gwY),
          width: gwSize,
          height: gwSize * 0.7,
        );
        if (na > 0.001) {
          canvas.drawRect(
            wr.inflate(gwSize * 0.5),
            Paint()
              ..color = palette.windowLit.withValues(alpha: 0.5 * na)
              ..maskFilter = ui.MaskFilter.blur(BlurStyle.normal, gwSize * 0.6),
          );
        }
        canvas.drawRect(
          wr,
          Paint()
            ..color = Color.lerp(
              tone(const Color(0xFF93AEBA)),
              palette.windowLit,
              na,
            )!,
        );
        canvas.drawRect(
          wr,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.9
            ..color = outlineCol,
        );
      }

      canvas.restore();
    }
  }

  /// A cartoon glass window: sky-blue by day, warm-lit (with a halo) by night.
  void _paintHouseWindow(
    Canvas canvas,
    Offset center,
    double size,
    Color outlineCol,
    double night,
  ) {
    final win = Rect.fromCenter(
      center: center,
      width: size,
      height: size * 1.15,
    );

    if (night > 0.001) {
      canvas.drawRect(
        win.inflate(size * 0.4),
        Paint()
          ..color = palette.windowLit.withValues(alpha: 0.5 * night)
          ..maskFilter = ui.MaskFilter.blur(BlurStyle.normal, size * 0.55),
      );
    }

    canvas.drawRect(
      win,
      Paint()
        ..color = Color.lerp(
          const Color(0xFFBFE0F2),
          palette.windowLit,
          night,
        )!,
    );

    final bars = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..color = outlineCol;
    canvas.drawLine(
      Offset(center.dx, win.top),
      Offset(center.dx, win.bottom),
      bars,
    );
    canvas.drawLine(
      Offset(win.left, center.dy),
      Offset(win.right, center.dy),
      bars,
    );

    final frame = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeJoin = StrokeJoin.round
      ..color = outlineCol;
    canvas.drawRect(win, frame);
  }

  // ---------------------------------------------------------------------------
  // Labels
  // ---------------------------------------------------------------------------

  void _paintLabels(Canvas canvas, _Layout layout) {
    _label(
      canvas,
      layout.nodeOf(EnergyNode.solar),
      layout.iconR,
      below: true,
      title: 'Solar',
      value: _fmtWatts(data.solarWatts),
    );
    _label(
      canvas,
      layout.nodeOf(EnergyNode.grid),
      layout.iconR,
      below: true,
      title: 'Grid',
      value: _gridValueText(),
    );
    _label(
      canvas,
      layout.nodeOf(EnergyNode.battery),
      layout.iconR,
      below: false,
      title: 'Battery ${(data.batteryLevel * 100).round()}%',
      value: _batteryValueText(),
    );
    _label(
      canvas,
      layout.nodeOf(EnergyNode.house),
      layout.iconR,
      below: false,
      title: 'House',
      value: _fmtWatts(data.houseWatts),
    );
  }

  String _gridValueText() {
    if (data.isImporting) return 'Import ${_fmtWatts(data.gridWatts)}';
    if (data.isExporting) return 'Export ${_fmtWatts(data.gridWatts)}';
    return 'Idle';
  }

  String _batteryValueText() {
    if (data.isCharging) return 'Charging ${_fmtWatts(data.batteryWatts)}';
    if (data.isDischarging) {
      return 'Discharging ${_fmtWatts(data.batteryWatts)}';
    }
    return 'Idle';
  }

  String _fmtWatts(double w) {
    final a = w.abs();
    if (a < 1000) return '${a.round()} W';
    return '${(a / 1000).toStringAsFixed(1)} kW';
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
              color: palette.labelMuted,
              fontSize: r * 0.3,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: r * 4);

    final dy = below ? node.dy + r * 1.15 : node.dy - r * 1.15 - tp.height;
    tp.paint(canvas, Offset(node.dx - tp.width / 2, dy));
  }

  @override
  bool shouldRepaint(covariant SolarDiagramPainter old) {
    return old.data != data ||
        old.palette != palette ||
        old.showGarage != showGarage ||
        old.paintBackground != paintBackground ||
        old.nightAmount != nightAmount;
  }
}

/// Pre-computes node anchor positions for a given canvas [Size].
class _Layout {
  _Layout(this.size) {
    pad = size.shortestSide * 0.2;
    iconR = size.shortestSide * 0.1;
    squareHalf = size.shortestSide * 0.075;
    center = Offset(size.width / 2, size.height / 2);

    // Vertical half-separation of the two rows from the centre. Capped so the
    // rows stay compact (no dead space between solar/battery & grid/house) on
    // tall canvases, while never exceeding the available height on short ones.
    // The lower bound keeps the inward labels clear of the transfer square.
    final available = size.height / 2 - pad;
    final target = size.shortestSide * 0.28;
    rowHalf = available < target ? available : target;
  }

  final Size size;
  late final double pad;
  late final double iconR;

  /// Half the side length of the central transfer square.
  late final double squareHalf;

  /// Vertical distance from the centre to each node row.
  late final double rowHalf;
  late final Offset center;

  Offset nodeOf(EnergyNode node) {
    final cy = center.dy;
    switch (node) {
      case EnergyNode.solar:
        return Offset(pad, cy - rowHalf); // top-left
      case EnergyNode.grid:
        return Offset(size.width - pad, cy - rowHalf); // top-right
      case EnergyNode.battery:
        return Offset(pad, cy + rowHalf); // bottom-left
      case EnergyNode.house:
        return Offset(size.width - pad, cy + rowHalf); // bottom-right
    }
  }

  /// Orthogonal (right-angle) elbow polyline from a node into the central
  /// transfer square. Each connection leaves its icon's inner edge, travels
  /// horizontally toward the centre, then turns vertically into the square:
  ///   solar  = right edge, right, down → top of square (left of centre)
  ///   grid   = left  edge, left,  down → top of square (right of centre)
  ///   battery= right edge, right, up   → bottom of square (left of centre)
  ///   house  = left  edge, left,  up   → bottom of square (right of centre)
  ///
  /// The layout is mirror-symmetric (not rotational) to avoid a pinwheel /
  /// swastika look. Paths start at the icon edge and finish slightly inside the
  /// square, with the vertical runs offset from centre so they never touch.
  List<Offset> pathOf(EnergyNode node) {
    final cx = center.dx;
    final cy = center.dy;
    final n = nodeOf(node);

    // Horizontal offset of the vertical run from the square's centre, and how
    // far the flow reaches into the square (kept inside the half-extent so the
    // four endpoints stay clear of one another).
    final runDx = squareHalf * 0.5;
    final topY = cy - squareHalf * 0.45;
    final botY = cy + squareHalf * 0.45;

    // Per-icon horizontal exit offsets (icons differ in width at mid-height).
    switch (node) {
      case EnergyNode.solar:
        return [
          Offset(n.dx + iconR * 0.9, n.dy),
          Offset(cx - runDx, n.dy),
          Offset(cx - runDx, topY),
        ];
      case EnergyNode.grid:
        return [
          Offset(n.dx - iconR * 0.5, n.dy),
          Offset(cx + runDx, n.dy),
          Offset(cx + runDx, topY),
        ];
      case EnergyNode.battery:
        return [
          Offset(n.dx + iconR * 0.62, n.dy),
          Offset(cx - runDx, n.dy),
          Offset(cx - runDx, botY),
        ];
      case EnergyNode.house:
        return [
          Offset(n.dx - iconR * 0.9, n.dy),
          Offset(cx + runDx, n.dy),
          Offset(cx + runDx, botY),
        ];
    }
  }
}
