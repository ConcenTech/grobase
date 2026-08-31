import 'package:drift/drift.dart';

import 'converters.dart';

class InverterInvites extends Table {
  @JsonKey('id')
  TextColumn get id => text()();
  @JsonKey('token')
  TextColumn get token => text()();
  @JsonKey('created_at')
  RealColumn get createdAt => real().map(const DateTimeConverter())();
  @JsonKey('expires_at')
  RealColumn get expiresAt => real().map(const DateTimeConverter())();
  @JsonKey('accepted_at')
  RealColumn get acceptedAt =>
      real().nullable().map(const NullableDateTimeConverter())();

  @override
  Set<Column> get primaryKey => {id};
}
