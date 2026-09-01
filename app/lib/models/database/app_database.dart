import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'app_database.drift.dart';
import 'app_database.steps.dart';
import 'gateway.dart';
import 'gateway_event.dart';
import 'inverter.dart';
import 'inverter_invite.dart';
import 'inverter_member.dart';
import 'inverter_snapshot.dart';

@DriftDatabase(
  tables: [
    GatewayEvents,
    Gateways,
    InverterMembers,
    InverterSnapshots,
    Inverters,
    InverterInvites,
  ],
)
class AppDatabase extends $AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          await m.create(schema.inverterInvites);
          // Add email column and set existing rows to empty string
          await m.alterTable(
            TableMigration(
              schema.inverterMembers,
              columnTransformer: {
                schema.inverterMembers.email: const Constant(''),
              },
              newColumns: [schema.inverterMembers.email],
            ),
          );
          // Set retired_at to null if status is active
          await m.alterTable(
            TableMigration(
              schema.gateways,
              columnTransformer: {
                schema.gateways.retiredAt: schema.gateways.status.caseMatch(
                  when: {const Constant('retired'): schema.gateways.retiredAt},
                  orElse: const Constant(null),
                ),
              },
            ),
          );
        },
      ),
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'grobase',
      web: kIsWeb
          ? DriftWebOptions(
              sqlite3Wasm: Uri.parse('sqlite3.wasm'),
              driftWorker: Uri.parse('drift_worker.dart.js'),
            )
          : null,
      native: !kIsWeb
          ? DriftNativeOptions(
              databasePath: () async {
                final dbFolder = await getApplicationSupportDirectory();
                return join(dbFolder.path, 'grobase.db');
              },
            )
          : null,
    );
  }
}
