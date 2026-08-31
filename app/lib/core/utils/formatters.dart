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

/// Formats energy in kWh
///
/// If energy is less than 1, it returns the energy in Wh
String formatEnergy(double value) {
  final energy = value.abs();
  if (energy < 1 && energy > 0) {
    return '${energy * 1000} Wh';
  }
  return '${energy.toStringAsFixed(0)} kWh';
}
