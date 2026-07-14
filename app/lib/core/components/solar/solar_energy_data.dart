import 'package:flutter/material.dart';

import '../../../models/database/inverter_snapshot.drift.dart';

/// Immutable snapshot of the home energy system at a point in time.
///
/// Sign conventions (all values in watts unless noted):
/// * [solarWatts]   – generation. `>= 0` (panels never consume).
/// * [houseWatts]   – consumption. `>= 0` (the house always draws).
/// * [batteryWatts] – signed. `> 0` charging (energy into battery),
///   `< 0` discharging (energy out of battery).
/// * [gridWatts]    – signed. `> 0` importing (buying from grid),
///   `< 0` exporting (selling to grid).
@immutable
class SolarEnergyData {
  const SolarEnergyData({
    this.solarWatts = 0,
    this.houseWatts = 0,
    this.batteryWatts = 0,
    this.gridWatts = 0,
    this.batteryLevel = 0,
    this.lastSeenAt,
  }) : assert(batteryLevel >= 0 && batteryLevel <= 100);

  factory SolarEnergyData.fromInverterSnapshot(InverterSnapshot snapshot) {
    final batteryPower = snapshot.chargePower - snapshot.dischargePower;
    final gridPower = snapshot.gridActivePower - snapshot.gridExportPower;
    return SolarEnergyData(
      solarWatts: snapshot.solarPower,
      houseWatts: snapshot.homeLoadPower,
      batteryWatts: batteryPower,
      gridWatts: gridPower,
      batteryLevel: snapshot.batteryStateOfCharge.round(),
      lastSeenAt: snapshot.recordedAt,
    );
  }

  const SolarEnergyData.empty()
    : this(
        solarWatts: 0,
        houseWatts: 0,
        batteryWatts: 0,
        gridWatts: 0,
        batteryLevel: 0,
        lastSeenAt: null,
      );

  final double solarWatts;
  final double houseWatts;

  /// Signed: positive = charging, negative = discharging.
  final double batteryWatts;

  /// Signed: positive = importing, negative = exporting.
  final double gridWatts;

  /// Battery state of charge in the range `0..100`.
  final int batteryLevel;

  bool get isCharging => batteryWatts > epsilon;
  bool get isDischarging => batteryWatts < -epsilon;
  bool get isImporting => gridWatts > epsilon;
  bool get isExporting => gridWatts < -epsilon;

  final DateTime? lastSeenAt;

  bool get isOnline =>
      lastSeenAt != null &&
      lastSeenAt!.isAfter(DateTime.now().subtract(const Duration(minutes: 30)));

  SolarEnergyData copyWith({
    double? solarWatts,
    double? houseWatts,
    double? batteryWatts,
    double? gridWatts,
    int? batteryLevel,
    DateTime? lastSeenAt,
  }) {
    return SolarEnergyData(
      solarWatts: solarWatts ?? this.solarWatts,
      houseWatts: houseWatts ?? this.houseWatts,
      batteryWatts: batteryWatts ?? this.batteryWatts,
      gridWatts: gridWatts ?? this.gridWatts,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }

  /// Watts below this magnitude are treated as idle (labels and flow lines).
  static const double epsilon = 1.0;
}

/// Identifies one of the four corner nodes / its connection to the centre.
enum EnergyNode { solar, grid, battery, house }

/// Colour + tone palette for the diagram, resolved from the ambient
/// [ColorScheme]. "Night" simply follows the theme [Brightness] (a dark theme
/// is night); wrap the widget in a `Theme` to override it independently.
///
/// Structure (icons, lines, junction) uses cohesive neutral/themed tones rather
/// than a unique colour per node. The only colour that carries meaning is the
/// battery fill (state of charge) — see [batteryColor].
@immutable
class SolarDiagramPalette {
  const SolarDiagramPalette({
    required this.background,
    required this.surface,
    required this.surfaceBorder,
    required this.label,
    required this.labelMuted,
    required this.idleLine,
    required this.hub,
    required this.iconColor,
    required this.flowColor,
    required this.windowLit,
    required this.windowUnlit,
  });

  final Color background;
  final Color surface;
  final Color surfaceBorder;
  final Color label;
  final Color labelMuted;
  final Color idleLine;
  final Color hub;

  /// Single cohesive colour for every node icon / structural stroke.
  final Color iconColor;

  /// Single themed colour shared by every energy-flow animation.
  final Color flowColor;

  // House window states.
  final Color windowLit;
  final Color windowUnlit;

  /// Battery fill colour reflecting state of charge: red (empty) → amber (mid)
  /// → green (full), blended smoothly across the range.
  static Color batteryColor(double level) {
    const empty = Color(0xFFEF5350); // red
    const mid = Color(0xFFFFB300); // amber
    const full = Color(0xFF66BB6A); // green
    if (level <= 0.5) {
      return Color.lerp(empty, mid, (level / 0.5).clamp(0.0, 1.0))!;
    }
    return Color.lerp(mid, full, ((level - 0.5) / 0.5).clamp(0.0, 1.0))!;
  }

  /// Resolve a palette. The scene's light/dark tone follows [night] (the day
  /// sky is light regardless of the ambient [Theme]); the theme only informs
  /// the flow accent colour. So a dark-themed app in day mode still gets dark
  /// labels that read against the light day background.
  factory SolarDiagramPalette.resolve(ColorScheme scheme, bool night) {
    final dark = night;

    final background = dark ? const Color(0xFF070B16) : const Color(0xFFF3F6FB);
    final label = dark ? const Color(0xFFEDF1F7) : const Color(0xFF1C2430);

    return SolarDiagramPalette(
      background: background,
      surface: dark ? const Color(0xFF1B2230) : Colors.white,
      surfaceBorder: dark ? const Color(0xFF2E3849) : const Color(0xFFD7DEEA),
      label: label,
      labelMuted: dark ? const Color(0xFF8A95A6) : const Color(0xFF6B7686),
      // idleLine: dark ? const Color(0xFF2C3445) : const Color(0xFFCBD4E1),
      idleLine: const Color(0xFF2C3445),
      hub: dark ? const Color(0xFF3A4456) : const Color(0xFFB0BAC9),
      iconColor: label,
      // flowColor: _ensureVisible(scheme.primary, background)
      flowColor: scheme.primaryFixed,
      windowLit: const Color(0xFFFFE082),
      // windowUnlit: dark ? const Color(0xFF2B3340) : const Color(0xFFC2CAD6),
      windowUnlit: const Color(0xFF2B3340),
    );
  }

  /// Returns a copy with the given fields replaced. Lets callers tweak a few
  /// colours of a resolved palette without redefining every field.
  SolarDiagramPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceBorder,
    Color? label,
    Color? labelMuted,
    Color? idleLine,
    Color? hub,
    Color? iconColor,
    Color? flowColor,
    Color? windowLit,
    Color? windowUnlit,
  }) {
    return SolarDiagramPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceBorder: surfaceBorder ?? this.surfaceBorder,
      label: label ?? this.label,
      labelMuted: labelMuted ?? this.labelMuted,
      idleLine: idleLine ?? this.idleLine,
      hub: hub ?? this.hub,
      iconColor: iconColor ?? this.iconColor,
      flowColor: flowColor ?? this.flowColor,
      windowLit: windowLit ?? this.windowLit,
      windowUnlit: windowUnlit ?? this.windowUnlit,
    );
  }

  /// Blends two palettes for smooth day/night (or any) transitions.
  static SolarDiagramPalette lerp(
    SolarDiagramPalette a,
    SolarDiagramPalette b,
    double t,
  ) {
    return SolarDiagramPalette(
      background: Color.lerp(a.background, b.background, t)!,
      surface: Color.lerp(a.surface, b.surface, t)!,
      surfaceBorder: Color.lerp(a.surfaceBorder, b.surfaceBorder, t)!,
      label: Color.lerp(a.label, b.label, t)!,
      labelMuted: Color.lerp(a.labelMuted, b.labelMuted, t)!,
      idleLine: Color.lerp(a.idleLine, b.idleLine, t)!,
      hub: Color.lerp(a.hub, b.hub, t)!,
      iconColor: Color.lerp(a.iconColor, b.iconColor, t)!,
      flowColor: Color.lerp(a.flowColor, b.flowColor, t)!,
      windowLit: Color.lerp(a.windowLit, b.windowLit, t)!,
      windowUnlit: Color.lerp(a.windowUnlit, b.windowUnlit, t)!,
    );
  }

  /// Guarantees the flow colour reads against [bg] (e.g. a dark theme primary
  /// on the forced-dark night background) by blending toward white/black when
  /// the contrast is too low.
  static Color _ensureVisible(Color c, Color bg) {
    final diff = (c.computeLuminance() - bg.computeLuminance()).abs();
    if (diff >= 0.22) return c;
    final target = bg.computeLuminance() < 0.5 ? Colors.white : Colors.black;
    return Color.lerp(c, target, 0.55)!;
  }
}

/// Theme-level overrides for [SolarDiagramPalette], in the spirit of Flutter's
/// [ThemeExtension]. Add it to your app's `ThemeData.extensions` and set only
/// the colours you want to change; any field left null falls back to the
/// diagram's resolved default:
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: const [SolarDiagramTheme(flowColor: Colors.cyan)],
///   ),
/// );
/// ```
///
/// The same override applies to both the day and night palettes; wrap a
/// subtree in a `Theme` with a different extension to vary it locally.
@immutable
class SolarDiagramTheme extends ThemeExtension<SolarDiagramTheme> {
  const SolarDiagramTheme({
    this.background,
    this.surface,
    this.surfaceBorder,
    this.label,
    this.labelMuted,
    this.idleLine,
    this.hub,
    this.iconColor,
    this.flowColor,
    this.windowLit,
    this.windowUnlit,
  });

  final Color? background;
  final Color? surface;
  final Color? surfaceBorder;
  final Color? label;
  final Color? labelMuted;
  final Color? idleLine;
  final Color? hub;
  final Color? iconColor;
  final Color? flowColor;
  final Color? windowLit;
  final Color? windowUnlit;

  /// Applies the non-null overrides on top of a resolved [base] palette.
  SolarDiagramPalette applyTo(SolarDiagramPalette base) {
    return base.copyWith(
      background: background,
      surface: surface,
      surfaceBorder: surfaceBorder,
      label: label,
      labelMuted: labelMuted,
      idleLine: idleLine,
      hub: hub,
      iconColor: iconColor,
      flowColor: flowColor,
      windowLit: windowLit,
      windowUnlit: windowUnlit,
    );
  }

  @override
  SolarDiagramTheme copyWith({
    Color? background,
    Color? surface,
    Color? surfaceBorder,
    Color? label,
    Color? labelMuted,
    Color? idleLine,
    Color? hub,
    Color? iconColor,
    Color? flowColor,
    Color? windowLit,
    Color? windowUnlit,
  }) {
    return SolarDiagramTheme(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceBorder: surfaceBorder ?? this.surfaceBorder,
      label: label ?? this.label,
      labelMuted: labelMuted ?? this.labelMuted,
      idleLine: idleLine ?? this.idleLine,
      hub: hub ?? this.hub,
      iconColor: iconColor ?? this.iconColor,
      flowColor: flowColor ?? this.flowColor,
      windowLit: windowLit ?? this.windowLit,
      windowUnlit: windowUnlit ?? this.windowUnlit,
    );
  }

  @override
  SolarDiagramTheme lerp(ThemeExtension<SolarDiagramTheme>? other, double t) {
    if (other is! SolarDiagramTheme) return this;
    return SolarDiagramTheme(
      background: Color.lerp(background, other.background, t),
      surface: Color.lerp(surface, other.surface, t),
      surfaceBorder: Color.lerp(surfaceBorder, other.surfaceBorder, t),
      label: Color.lerp(label, other.label, t),
      labelMuted: Color.lerp(labelMuted, other.labelMuted, t),
      idleLine: Color.lerp(idleLine, other.idleLine, t),
      hub: Color.lerp(hub, other.hub, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      flowColor: Color.lerp(flowColor, other.flowColor, t),
      windowLit: Color.lerp(windowLit, other.windowLit, t),
      windowUnlit: Color.lerp(windowUnlit, other.windowUnlit, t),
    );
  }
}
