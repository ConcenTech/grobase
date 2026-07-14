import 'dart:convert';

import 'package:drift/drift.dart';

import '../location.dart';
import 'converters.dart';
import 'inverter.drift.dart';

export 'inverter.drift.dart' show Inverter;

class Inverters extends Table {
  @JsonKey('id')
  TextColumn get id => text()();
  @JsonKey('inverter_sn')
  TextColumn get inverterSn => text()();
  @JsonKey('display_name')
  TextColumn get displayName => text()();
  @JsonKey('created_at')
  RealColumn get createdAt => real().map(const DateTimeConverter())();
  @JsonKey('last_seen_at')
  RealColumn get lastSeenAt => real().map(const DateTimeConverter())();
  @JsonKey('location')
  TextColumn get location => text().map(const LocationConverter())();
}

extension InvertersExtension on Inverter {
  bool get isOnline => DateTime.now().difference(lastSeenAt).inHours < 5;
}

class LocationConverter extends TypeConverter<Location, String>
    with JsonTypeConverter2<Location, String, Map<String, dynamic>> {
  const LocationConverter();

  @override
  Location fromSql(String fromDb) {
    return Location.fromJson(jsonDecode(fromDb));
  }

  @override
  String toSql(Location value) {
    return jsonEncode(value.toJson());
  }

  @override
  Location fromJson(Map<String, dynamic> json) {
    return Location.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Location value) {
    return value.toJson();
  }
}
