import 'package:drift/drift.dart';

import 'converters.dart';

class Gateways extends Table {
  @JsonKey('id')
  TextColumn get id => text()();
  @JsonKey('hardware_id')
  TextColumn get hardwareId => text()();
  @JsonKey('inverter_id')
  TextColumn get inverterId => text()();
  @JsonKey('status')
  TextColumn get status => text().map(const GatewayStatusConverter())();
  @JsonKey('provisioned_by')
  TextColumn get provisionedBy => text()();
  @JsonKey('last_seen_at')
  RealColumn get lastSeenAt => real().map(const DateTimeConverter())();
  @JsonKey('firmware_version')
  TextColumn get firmwareVersion => text()();
  @JsonKey('created_at')
  RealColumn get createdAt => real().map(const DateTimeConverter())();
  @JsonKey('retired_at')
  RealColumn get retiredAt => real().map(const DateTimeConverter())();
}

enum GatewayStatus {
  pending,
  active,
  retired;

  static GatewayStatus fromString(String value) {
    return GatewayStatus.values.firstWhere((e) => e.name == value);
  }
}

class GatewayStatusConverter extends TypeConverter<GatewayStatus, String>
    with JsonTypeConverter2<GatewayStatus, String, String> {
  const GatewayStatusConverter();

  String _toString(GatewayStatus status) => status.name;
  GatewayStatus _fromString(String name) => GatewayStatus.fromString(name);

  @override
  GatewayStatus fromSql(String fromDb) => _fromString(fromDb);

  @override
  String toSql(GatewayStatus value) => _toString(value);

  @override
  GatewayStatus fromJson(String json) => _fromString(json);

  @override
  String toJson(GatewayStatus value) => _toString(value);
}
