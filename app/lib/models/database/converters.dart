import 'dart:convert';

import 'package:drift/drift.dart';

class JsonConverter<T> extends TypeConverter<Map<String, T>, String>
    with JsonTypeConverter2<Map<String, T>, String, Map<String, dynamic>> {
  const JsonConverter();

  @override
  Map<String, T> fromSql(String fromDb) {
    return Map<String, T>.from(jsonDecode(fromDb));
  }

  @override
  String toSql(Map<String, T> value) {
    return jsonEncode(value);
  }

  @override
  Map<String, T> fromJson(Map<String, dynamic> json) {
    return Map<String, T>.from(json);
  }

  @override
  Map<String, dynamic> toJson(Map<String, T> value) => value;
}

class DateTimeConverter extends TypeConverter<DateTime, double>
    with JsonTypeConverter2<DateTime, double, String> {
  const DateTimeConverter();

  @override
  DateTime fromSql(double seconds) {
    return DateTime.fromMillisecondsSinceEpoch((seconds * 1000).round());
  }

  @override
  double toSql(DateTime value) {
    return value.millisecondsSinceEpoch / 1000;
  }

  @override
  DateTime fromJson(String value) {
    return DateTime.parse(value);
  }

  @override
  String toJson(DateTime value) {
    return value.toUtc().toIso8601String();
  }
}
