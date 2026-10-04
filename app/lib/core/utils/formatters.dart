import 'package:intl/intl.dart';

String formatPower(double value) {
  final power = value.abs();
  if (power < 1000) {
    return power.toStringAsFixed(0);
  }
  return (power / 1000).toStringAsFixed(1);
}

String formatPowerUnit(double value) {
  final power = value.abs();
  if (power < 1000) {
    return 'W';
  }
  return 'kW';
}

String formatPowerWithUnit(double value) {
  final power = value.abs();
  if (power < 1000) {
    return '${power.toStringAsFixed(0)} W';
  }
  return '${(power / 1000).toStringAsFixed(1)} kW';
}

String formatTime(DateTime time) {
  return DateFormat('HH:mm').format(time);
}

/// Formats fractional hours since midnight as `HH:mm` (24-hour).
String formatHours(double hours) {
  final totalMinutes = (hours * 60).round();
  final hour = (totalMinutes ~/ 60) % 24;
  final minute = totalMinutes % 60;
  return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

/// Formats energy in kWh
///
/// If energy is less than 1, it returns the energy in Wh
String formatEnergy(double value, {bool forceKWh = false, int? decimalPlaces}) {
  final energy = value.abs();
  if (energy < 1 && energy > 0 && !forceKWh) {
    return '${energy * 1000} Wh';
  }
  final dc = decimalPlaces ?? (forceKWh && energy < 1 ? 1 : 0);
  return '${energy.toStringAsFixed(dc)} kWh';
}
