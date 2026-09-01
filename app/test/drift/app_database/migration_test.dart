// dart format width=80
// ignore_for_file: unused_local_variable, unused_import

import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grobase/models/database/app_database.dart';
import 'package:grobase/models/database/gateway.dart' show GatewayStatus;
import 'package:grobase/models/database/inverter_member.dart'
    show InverterMemberRole;

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  /// Ensures valid data after adding the email column to inverter_members
  /// and fixing gateway.retired_at
  test('migration from v1 to v2 does not corrupt data', () async {
    // Add data to insert into the old database, and the expected rows after the
    // migration.
    final now = DateTime.now().toUtc();
    final nowSeconds = now.millisecondsSinceEpoch / 1000;

    final oldGatewaysData = <v1.GatewaysData>[
      v1.GatewaysData(
        id: '1',
        createdAt: nowSeconds,
        hardwareId: '1',
        inverterId: 'ABC',
        status: GatewayStatus.active.name,
        provisionedBy: 'Provisioner',
        lastSeenAt: nowSeconds,
        firmwareVersion: '1',
        retiredAt: nowSeconds,
      ),
      v1.GatewaysData(
        id: '2',
        createdAt: nowSeconds,
        hardwareId: '2',
        inverterId: 'DEF',
        status: GatewayStatus.retired.name,
        provisionedBy: 'Provisioner2',
        lastSeenAt: nowSeconds,
        firmwareVersion: '1',
        retiredAt: nowSeconds,
      ),
    ];

    final expectedNewGatewaysData = <v2.GatewaysData>[
      v2.GatewaysData(
        id: '1',
        createdAt: nowSeconds,
        hardwareId: '1',
        inverterId: 'ABC',
        status: GatewayStatus.active.name,
        provisionedBy: 'Provisioner',
        lastSeenAt: nowSeconds,
        firmwareVersion: '1',
        retiredAt: null,
      ),
      v2.GatewaysData(
        id: '2',
        createdAt: nowSeconds,
        hardwareId: '2',
        inverterId: 'DEF',
        status: GatewayStatus.retired.name,
        provisionedBy: 'Provisioner2',
        lastSeenAt: nowSeconds,
        firmwareVersion: '1',
        retiredAt: nowSeconds,
      ),
    ];

    final oldInverterMembersData = <v1.InverterMembersData>[
      v1.InverterMembersData(
        createdAt: nowSeconds,
        inverterId: 'ABC',
        userId: '1',
        role: InverterMemberRole.owner.name,
      ),
    ];
    final expectedNewInverterMembersData = <v2.InverterMembersData>[
      v2.InverterMembersData(
        createdAt: nowSeconds,
        inverterId: 'ABC',
        userId: '1',
        role: InverterMemberRole.owner.name,
        email: '',
      ),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.gateways, oldGatewaysData);
        batch.insertAll(oldDb.inverterMembers, oldInverterMembersData);
      },
      validateItems: (newDb) async {
        expect(
          expectedNewGatewaysData,
          await newDb.select(newDb.gateways).get(),
        );
        expect(
          expectedNewInverterMembersData,
          await newDb.select(newDb.inverterMembers).get(),
        );
      },
    );
  });
}
