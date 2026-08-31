import 'dart:async';

import 'package:flutter/material.dart';

Future<DateTime?> showDatePickerBottomSheet({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  return showModalBottomSheet<DateTime?>(
    context: context,
    builder: (context) => _DatePickerBottomSheet(
      key: const Key('date_picker_bottom_sheet'),
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    ),
  );
}

class _DatePickerBottomSheet extends StatelessWidget {
  const _DatePickerBottomSheet({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  void _onDateChanged(DateTime date, BuildContext context) {
    Navigator.of(context).pop(date);
  }

  @override
  Widget build(BuildContext context) {
    return CalendarDatePicker(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      onDateChanged: (date) => _onDateChanged(date, context),
    );
  }
}
