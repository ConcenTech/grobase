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
