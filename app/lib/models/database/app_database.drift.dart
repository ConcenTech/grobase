// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:grobase/models/database/gateway_event.drift.dart' as i1;
import 'package:grobase/models/database/gateway.drift.dart' as i2;
import 'package:grobase/models/database/inverter_member.drift.dart' as i3;
import 'package:grobase/models/database/inverter_snapshot.drift.dart' as i4;
import 'package:grobase/models/database/inverter.drift.dart' as i5;

abstract class $AppDatabase extends i0.GeneratedDatabase {
  $AppDatabase(i0.QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final i1.$GatewayEventsTable gatewayEvents = i1.$GatewayEventsTable(
    this,
  );
  late final i2.$GatewaysTable gateways = i2.$GatewaysTable(this);
  late final i3.$InverterMembersTable inverterMembers = i3
      .$InverterMembersTable(this);
  late final i4.$InverterSnapshotsTable inverterSnapshots = i4
      .$InverterSnapshotsTable(this);
  late final i5.$InvertersTable inverters = i5.$InvertersTable(this);
  @override
  Iterable<i0.TableInfo<i0.Table, Object?>> get allTables =>
      allSchemaEntities.whereType<i0.TableInfo<i0.Table, Object?>>();
  @override
  List<i0.DatabaseSchemaEntity> get allSchemaEntities => [
    gatewayEvents,
    gateways,
    inverterMembers,
    inverterSnapshots,
    inverters,
  ];
}

class $AppDatabaseManager {
  final $AppDatabase _db;
  $AppDatabaseManager(this._db);
  i1.$$GatewayEventsTableTableManager get gatewayEvents =>
      i1.$$GatewayEventsTableTableManager(_db, _db.gatewayEvents);
  i2.$$GatewaysTableTableManager get gateways =>
      i2.$$GatewaysTableTableManager(_db, _db.gateways);
  i3.$$InverterMembersTableTableManager get inverterMembers =>
      i3.$$InverterMembersTableTableManager(_db, _db.inverterMembers);
  i4.$$InverterSnapshotsTableTableManager get inverterSnapshots =>
      i4.$$InverterSnapshotsTableTableManager(_db, _db.inverterSnapshots);
  i5.$$InvertersTableTableManager get inverters =>
      i5.$$InvertersTableTableManager(_db, _db.inverters);
}
