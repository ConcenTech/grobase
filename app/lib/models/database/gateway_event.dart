import 'package:drift/drift.dart';

import 'converters.dart';

class GatewayEvents extends Table {
  IntColumn get id => integer()();
  @JsonKey('gateway_id')
  TextColumn get gatewayId => text()();
  @JsonKey('inverter_id')
  TextColumn get inverterId => text()();
  @JsonKey('level')
  TextColumn get level => text().map(const GatewayEventLevelConverter())();
  @JsonKey('code')
  TextColumn get code => text()();
  @JsonKey('message')
  TextColumn get message => text()();
  @JsonKey('metadata')
  TextColumn get metadata => text().map(const JsonConverter())();
  @JsonKey('recorded_at')
  RealColumn get recordedAt => real().map(const DateTimeConverter())();
  @JsonKey('ingested_at')
  RealColumn get ingestedAt => real().map(const DateTimeConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

enum GatewayEventLevel {
  info,
  warn,
  error;

  static GatewayEventLevel fromString(String value) {
    return GatewayEventLevel.values.firstWhere(
      (e) => e.name == value,
      orElse: () => GatewayEventLevel.error,
    );
  }
}

class GatewayEventLevelConverter
    extends TypeConverter<GatewayEventLevel, String>
    with JsonTypeConverter2<GatewayEventLevel, String, String> {
  const GatewayEventLevelConverter();

  String _toString(GatewayEventLevel level) => level.name;
  GatewayEventLevel _fromString(String name) =>
      GatewayEventLevel.fromString(name);

  @override
  GatewayEventLevel fromSql(String fromDb) => _fromString(fromDb);

  @override
  String toSql(GatewayEventLevel value) => _toString(value);

  @override
  GatewayEventLevel fromJson(String json) => _fromString(json);

  @override
  String toJson(GatewayEventLevel value) => _toString(value);
}
