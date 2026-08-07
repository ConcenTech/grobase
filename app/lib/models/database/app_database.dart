import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'app_database.drift.dart';
import 'gateway.dart';
import 'gateway_event.dart';
import 'inverter.dart';
import 'inverter_member.dart';
import 'inverter_snapshot.dart';

@DriftDatabase(
  tables: [
    GatewayEvents,
    Gateways,
    InverterMembers,
    InverterSnapshots,
    Inverters,
  ],
)
class AppDatabase extends $AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // @override
  // MigrationStrategy get migration {
  //   return MigrationStrategy(
  //     onCreate: (Migrator m) async {
  //       await m.createAll();
  //     },
  //     onUpgrade: (Migrator m, int from, int to) async {
  //       await m.createAll();
  //     },
  //   );
  // }

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
