import 'package:drift/drift.dart';

import 'converters.dart';

class InverterMembers extends Table {
  @JsonKey('inverter_id')
  TextColumn get inverterId => text()();
  @JsonKey('user_id')
  TextColumn get userId => text()();
  @JsonKey('role')
  TextColumn get role => text().map(const InverterMemberRoleConverter())();
  @JsonKey('email')
  TextColumn get email => text()();
  @JsonKey('created_at')
  RealColumn get createdAt => real().map(const DateTimeConverter())();

  @override
  Set<Column> get primaryKey => {inverterId, userId};
}

enum InverterMemberRole {
  owner,
  viewer;

  static InverterMemberRole fromString(String value) {
    return InverterMemberRole.values.firstWhere((e) => e.name == value);
  }
}

class InverterMemberRoleConverter
    extends TypeConverter<InverterMemberRole, String>
    with JsonTypeConverter2<InverterMemberRole, String, String> {
  const InverterMemberRoleConverter();

  String _toString(InverterMemberRole role) => role.name;
  InverterMemberRole _fromString(String name) =>
      InverterMemberRole.fromString(name);

  @override
  InverterMemberRole fromSql(String fromDb) => _fromString(fromDb);

  @override
  String toSql(InverterMemberRole value) => _toString(value);

  @override
  InverterMemberRole fromJson(String json) => _fromString(json);

  @override
  String toJson(InverterMemberRole value) => _toString(value);
}
