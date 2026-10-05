import 'package:material_ui/material_ui.dart';

extension ThemeExtension on ThemeData {
  Color get solar => Colors.orange.shade300;
  Color get battery => colorScheme.primaryFixedDim;
  Color get batteryVariant => colorScheme.primaryFixed;
  Color get grid => Colors.blue;
  Color get gridVariant => Colors.lightBlue;
  Color get consumption => const Color(0xFFB671C8);
}
