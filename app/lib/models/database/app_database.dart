import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationSupportDirectory();
      final file = File(join(dbFolder.path, 'grobase.db'));
      // await file.delete();
      if (kDebugMode && await file.exists()) {
        await file.delete();
        // await const SecureStorage().clear();
      }
      return NativeDatabase(file);
    });
  }
}
