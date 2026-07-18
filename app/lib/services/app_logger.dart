import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class AppLogger {
  static AppLogger? _instance;

  static AppLogger get instance => _instance ??= AppLogger._();

  AppLogger._() {
    _truncateLogs();
    Logger.root.onRecord.listen(_writeLog);
  }

  static const maxEntries = 500;

  List<LogRecord> _logBuffer = [];

  int get count => _logBuffer.length;

  Timer? _timer;

  void _writeLog(LogRecord record) {
    if (kDebugMode) {
      print('$record  ${record.error ?? ''}');
    }
    _logBuffer.add(record);
    _timer?.cancel();
    _timer ??= Timer(const Duration(seconds: 5), flush);
  }

  void flush() {
    _timer?.cancel();
    _logBuffer = [];
  }

  void _truncateLogs() {
    while (_logBuffer.length > maxEntries) {
      _logBuffer.removeAt(0);
    }
  }

  String formatted() {
    final sb = StringBuffer();

    for (final log in _logBuffer) {
      sb.writeln(log.format());
    }

    return sb.toString();
  }
}

extension FormatLog on LogRecord {
  String format() {
    return '$time | '
        '${level.name.padRight(8)} | '
        '${loggerName.padRight(25)} | '
        '$message ${error?.toString() != null || stackTrace?.toString() != null ? '|' : ''} '
        '${error?.toString() ?? ''}'
        '${stackTrace?.toString() ?? ''}';
  }
}
