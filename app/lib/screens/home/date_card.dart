import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/components/date_picker_bottom_sheet.dart';
import '../../services/selected_date_time_notifier.dart';

class DateCard extends ConsumerWidget {
  const DateCard({super.key, required this.minDate});

  /// The earliest date that can be selected.
  final DateTime minDate;

  void _today(WidgetRef ref) => _selectDate(ref, DateTime.now());

  void _selectDate(WidgetRef ref, DateTime date) {
    ref.read(selectedDateTimeProvider.notifier).set(date);
  }

  String _formattedDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  void _openDatePicker(
    WidgetRef ref,
    BuildContext context,
    DateTime selectedDate,
  ) async {
    final now = DateTime.now();
    final result = await showDatePickerBottomSheet(
      context: context,
      initialDate: selectedDate,
      firstDate: minDate,
      lastDate: now,
    );
    if (result != null) {
      _selectDate(ref, result);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateTimeProvider);

    const oneDay = Duration(days: 1);

    final now = DateTime.now();
    final isToday =
        selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    return Row(
      children: [
        IconButton(
          onPressed: () => _selectDate(ref, selectedDate.subtract(oneDay)),
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: OutlinedButton(
            onPressed: () => _openDatePicker(ref, context, selectedDate),
            child: Text(_formattedDate(selectedDate)),
          ),
        ),
        ClipRect(
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOutCubic,
            alignment: Alignment.centerLeft,
            widthFactor: isToday ? 0 : 1,
            child: IgnorePointer(
              ignoring: isToday,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: FilledButton(
                  onPressed: () => _today(ref),
                  child: const Text('Today'),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: isToday
              ? null
              : () => _selectDate(ref, selectedDate.add(oneDay)),
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}
