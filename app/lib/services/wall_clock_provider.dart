import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bumps when wall-clock-sensitive UI should re-evaluate.
///
/// Fires at local midnight and whenever the app resumes. Long background
/// suspensions often prevent Dart [Timer]s from delivering, so resume is the
/// reliable signal after overnight sleep.
final wallClockTickProvider =
    NotifierProvider<WallClockTickNotifier, int>(WallClockTickNotifier.new);

class WallClockTickNotifier extends Notifier<int> {
  AppLifecycleListener? _lifecycle;
  Timer? _midnightTimer;

  @override
  int build() {
    _lifecycle = AppLifecycleListener(onResume: _onResume);
    ref.onDispose(() {
      _lifecycle?.dispose();
      _midnightTimer?.cancel();
    });
    _scheduleMidnight();
    return 0;
  }

  void _onResume() {
    state++;
    _scheduleMidnight();
  }

  void _scheduleMidnight() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    final nextMidnight = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 1));
    var wait = nextMidnight.difference(now);
    if (wait < const Duration(seconds: 1)) {
      wait = const Duration(seconds: 1);
    }
    _midnightTimer = Timer(wait, () {
      state++;
      _scheduleMidnight();
    });
  }
}

/// Local calendar day (midnight) that updates when [wallClockTickProvider] fires
/// and the civil day has changed.
///
/// Riverpod only notifies dependents when the returned [DateTime] changes, so
/// resume ticks on the same day do not recreate day-scoped streams.
final localCalendarDayProvider = Provider<DateTime>((ref) {
  ref.watch(wallClockTickProvider);
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});
