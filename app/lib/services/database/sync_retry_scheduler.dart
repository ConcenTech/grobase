import 'dart:async';

/// Owns delayed catch-up and backoff retry timers for [SyncService].
///
/// Follows the same Timer lifecycle as [ConnectionManager]: one active timer,
/// cancel on [reset] / [dispose].
class SyncRetryScheduler {
  SyncRetryScheduler({required void Function() onFire}) : _onFire = onFire;

  static const maxRetries = 4;

  static const resumeDelay = Duration(seconds: 1);

  static const retryDelays = <Duration>[
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 4),
    Duration(seconds: 8),
  ];

  final void Function() _onFire;

  Timer? _timer;

  /// Failed attempts already completed before the next scheduled retry.
  int _attempt = 0;

  int get attempt => _attempt;

  /// Schedules a catch-up after [resumeDelay], replacing any pending timer.
  void scheduleResumeCatchUp() {
    reset();
    _timer = Timer(resumeDelay, _onFire);
  }

  /// Schedules the next backoff retry.
  ///
  /// Returns the delay used, or `null` when the retry budget is exhausted.
  Duration? scheduleRetry() {
    if (_attempt >= maxRetries) {
      return null;
    }

    final delay = retryDelays[_attempt];
    _attempt += 1;
    _timer?.cancel();
    _timer = Timer(delay, _onFire);
    return delay;
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    _attempt = 0;
  }

  void dispose() {
    reset();
  }
}
