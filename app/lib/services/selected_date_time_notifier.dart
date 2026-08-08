import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedDateTimeProvider =
    NotifierProvider<SelectedDateTimeNotifier, DateTime>(
      SelectedDateTimeNotifier.new,
    );

/// A notifier that provides the current selected date time.
class SelectedDateTimeNotifier extends Notifier<DateTime> {
  /// True if the user is viewing history for a specific date.
  bool _isPinned = false;

  DateTime _dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  DateTime _today() {
    return _dateOnly(DateTime.now());
  }

  @override
  DateTime build() {
    return _today();
  }

  void set(DateTime dateTime) {
    final today = _today();
    final date = _dateOnly(dateTime);

    // Limit the maximum date to today.
    if (date.isAfter(today)) {
      if (state != today) {
        _isPinned = false;
        state = today;
      }
      return;
    }

    // If the date is before today, pin the date.
    _isPinned = date.isBefore(today);

    state = date;
  }

  void setTodayIfNotPinned() {
    if (!_isPinned && state != _today()) {
      state = _today();
    }
  }
}
