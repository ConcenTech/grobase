// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:grobase/models/database/inverter_snapshot.drift.dart' as i1;
import 'package:grobase/models/database/inverter_snapshot.dart' as i2;
import 'package:grobase/models/database/converters.dart' as i3;

typedef $$InverterSnapshotsTableCreateCompanionBuilder =
    i1.InverterSnapshotsCompanion Function({
      i0.Value<int> id,
      required String inverterId,
      required String gatewayId,
      required DateTime recordedAt,
      required DateTime ingestedAt,
      required double batteryStateOfCharge,
      required double batteryVoltage,
      required double batteryCurrent,
      required double chargePower,
      required double dischargePower,
      required double chargeEnergyToday,
      required double dischargeEnergyToday,
      required double gridImportPower,
      required double gridFrequency,
      required double gridVoltage,
      required double gridCurrent,
      required double gridExportPower,
      required double gridExportEnergyToday,
      required double gridImportEnergyToday,
      required double gridChargePower,
      required double solarEnergyToday,
      required double solarPower,
      required double homeLoadPower,
    });
typedef $$InverterSnapshotsTableUpdateCompanionBuilder =
    i1.InverterSnapshotsCompanion Function({
      i0.Value<int> id,
      i0.Value<String> inverterId,
      i0.Value<String> gatewayId,
      i0.Value<DateTime> recordedAt,
      i0.Value<DateTime> ingestedAt,
      i0.Value<double> batteryStateOfCharge,
      i0.Value<double> batteryVoltage,
      i0.Value<double> batteryCurrent,
      i0.Value<double> chargePower,
      i0.Value<double> dischargePower,
      i0.Value<double> chargeEnergyToday,
      i0.Value<double> dischargeEnergyToday,
      i0.Value<double> gridImportPower,
      i0.Value<double> gridFrequency,
      i0.Value<double> gridVoltage,
      i0.Value<double> gridCurrent,
      i0.Value<double> gridExportPower,
      i0.Value<double> gridExportEnergyToday,
      i0.Value<double> gridImportEnergyToday,
      i0.Value<double> gridChargePower,
      i0.Value<double> solarEnergyToday,
      i0.Value<double> solarPower,
      i0.Value<double> homeLoadPower,
    });

class $$InverterSnapshotsTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$InverterSnapshotsTable> {
  $$InverterSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get inverterId => $composableBuilder(
    column: $table.inverterId,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get gatewayId => $composableBuilder(
    column: $table.gatewayId,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<DateTime, DateTime, double>
  get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<DateTime, DateTime, double>
  get ingestedAt => $composableBuilder(
    column: $table.ingestedAt,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnFilters<double> get batteryStateOfCharge => $composableBuilder(
    column: $table.batteryStateOfCharge,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get batteryVoltage => $composableBuilder(
    column: $table.batteryVoltage,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get batteryCurrent => $composableBuilder(
    column: $table.batteryCurrent,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get chargePower => $composableBuilder(
    column: $table.chargePower,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get dischargePower => $composableBuilder(
    column: $table.dischargePower,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get chargeEnergyToday => $composableBuilder(
    column: $table.chargeEnergyToday,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get dischargeEnergyToday => $composableBuilder(
    column: $table.dischargeEnergyToday,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get gridImportPower => $composableBuilder(
    column: $table.gridImportPower,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get gridFrequency => $composableBuilder(
    column: $table.gridFrequency,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get gridVoltage => $composableBuilder(
    column: $table.gridVoltage,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get gridCurrent => $composableBuilder(
    column: $table.gridCurrent,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get gridExportPower => $composableBuilder(
    column: $table.gridExportPower,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get gridExportEnergyToday => $composableBuilder(
    column: $table.gridExportEnergyToday,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get gridImportEnergyToday => $composableBuilder(
    column: $table.gridImportEnergyToday,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get gridChargePower => $composableBuilder(
    column: $table.gridChargePower,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get solarEnergyToday => $composableBuilder(
    column: $table.solarEnergyToday,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get solarPower => $composableBuilder(
    column: $table.solarPower,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get homeLoadPower => $composableBuilder(
    column: $table.homeLoadPower,
    builder: (column) => i0.ColumnFilters(column),
  );
}

class $$InverterSnapshotsTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$InverterSnapshotsTable> {
  $$InverterSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get inverterId => $composableBuilder(
    column: $table.inverterId,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get gatewayId => $composableBuilder(
    column: $table.gatewayId,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get ingestedAt => $composableBuilder(
    column: $table.ingestedAt,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get batteryStateOfCharge => $composableBuilder(
    column: $table.batteryStateOfCharge,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get batteryVoltage => $composableBuilder(
    column: $table.batteryVoltage,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get batteryCurrent => $composableBuilder(
    column: $table.batteryCurrent,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get chargePower => $composableBuilder(
    column: $table.chargePower,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get dischargePower => $composableBuilder(
    column: $table.dischargePower,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get chargeEnergyToday => $composableBuilder(
    column: $table.chargeEnergyToday,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get dischargeEnergyToday => $composableBuilder(
    column: $table.dischargeEnergyToday,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get gridImportPower => $composableBuilder(
    column: $table.gridImportPower,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get gridFrequency => $composableBuilder(
    column: $table.gridFrequency,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get gridVoltage => $composableBuilder(
    column: $table.gridVoltage,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get gridCurrent => $composableBuilder(
    column: $table.gridCurrent,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get gridExportPower => $composableBuilder(
    column: $table.gridExportPower,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get gridExportEnergyToday => $composableBuilder(
    column: $table.gridExportEnergyToday,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get gridImportEnergyToday => $composableBuilder(
    column: $table.gridImportEnergyToday,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get gridChargePower => $composableBuilder(
    column: $table.gridChargePower,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get solarEnergyToday => $composableBuilder(
    column: $table.solarEnergyToday,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get solarPower => $composableBuilder(
    column: $table.solarPower,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get homeLoadPower => $composableBuilder(
    column: $table.homeLoadPower,
    builder: (column) => i0.ColumnOrderings(column),
  );
}

class $$InverterSnapshotsTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$InverterSnapshotsTable> {
  $$InverterSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  i0.GeneratedColumn<String> get inverterId => $composableBuilder(
    column: $table.inverterId,
    builder: (column) => column,
  );

  i0.GeneratedColumn<String> get gatewayId =>
      $composableBuilder(column: $table.gatewayId, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<DateTime, double> get recordedAt =>
      $composableBuilder(
        column: $table.recordedAt,
        builder: (column) => column,
      );

  i0.GeneratedColumnWithTypeConverter<DateTime, double> get ingestedAt =>
      $composableBuilder(
        column: $table.ingestedAt,
        builder: (column) => column,
      );

  i0.GeneratedColumn<double> get batteryStateOfCharge => $composableBuilder(
    column: $table.batteryStateOfCharge,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get batteryVoltage => $composableBuilder(
    column: $table.batteryVoltage,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get batteryCurrent => $composableBuilder(
    column: $table.batteryCurrent,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get chargePower => $composableBuilder(
    column: $table.chargePower,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get dischargePower => $composableBuilder(
    column: $table.dischargePower,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get chargeEnergyToday => $composableBuilder(
    column: $table.chargeEnergyToday,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get dischargeEnergyToday => $composableBuilder(
    column: $table.dischargeEnergyToday,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get gridImportPower => $composableBuilder(
    column: $table.gridImportPower,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get gridFrequency => $composableBuilder(
    column: $table.gridFrequency,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get gridVoltage => $composableBuilder(
    column: $table.gridVoltage,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get gridCurrent => $composableBuilder(
    column: $table.gridCurrent,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get gridExportPower => $composableBuilder(
    column: $table.gridExportPower,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get gridExportEnergyToday => $composableBuilder(
    column: $table.gridExportEnergyToday,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get gridImportEnergyToday => $composableBuilder(
    column: $table.gridImportEnergyToday,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get gridChargePower => $composableBuilder(
    column: $table.gridChargePower,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get solarEnergyToday => $composableBuilder(
    column: $table.solarEnergyToday,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get solarPower => $composableBuilder(
    column: $table.solarPower,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get homeLoadPower => $composableBuilder(
    column: $table.homeLoadPower,
    builder: (column) => column,
  );
}

class $$InverterSnapshotsTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i1.$InverterSnapshotsTable,
          i1.InverterSnapshot,
          i1.$$InverterSnapshotsTableFilterComposer,
          i1.$$InverterSnapshotsTableOrderingComposer,
          i1.$$InverterSnapshotsTableAnnotationComposer,
          $$InverterSnapshotsTableCreateCompanionBuilder,
          $$InverterSnapshotsTableUpdateCompanionBuilder,
          (
            i1.InverterSnapshot,
            i0.BaseReferences<
              i0.GeneratedDatabase,
              i1.$InverterSnapshotsTable,
              i1.InverterSnapshot
            >,
          ),
          i1.InverterSnapshot,
          i0.PrefetchHooks Function()
        > {
  $$InverterSnapshotsTableTableManager(
    i0.GeneratedDatabase db,
    i1.$InverterSnapshotsTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i1.$$InverterSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => i1
              .$$InverterSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              i1.$$InverterSnapshotsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                i0.Value<int> id = const i0.Value.absent(),
                i0.Value<String> inverterId = const i0.Value.absent(),
                i0.Value<String> gatewayId = const i0.Value.absent(),
                i0.Value<DateTime> recordedAt = const i0.Value.absent(),
                i0.Value<DateTime> ingestedAt = const i0.Value.absent(),
                i0.Value<double> batteryStateOfCharge = const i0.Value.absent(),
                i0.Value<double> batteryVoltage = const i0.Value.absent(),
                i0.Value<double> batteryCurrent = const i0.Value.absent(),
                i0.Value<double> chargePower = const i0.Value.absent(),
                i0.Value<double> dischargePower = const i0.Value.absent(),
                i0.Value<double> chargeEnergyToday = const i0.Value.absent(),
                i0.Value<double> dischargeEnergyToday = const i0.Value.absent(),
                i0.Value<double> gridImportPower = const i0.Value.absent(),
                i0.Value<double> gridFrequency = const i0.Value.absent(),
                i0.Value<double> gridVoltage = const i0.Value.absent(),
                i0.Value<double> gridCurrent = const i0.Value.absent(),
                i0.Value<double> gridExportPower = const i0.Value.absent(),
                i0.Value<double> gridExportEnergyToday =
                    const i0.Value.absent(),
                i0.Value<double> gridImportEnergyToday =
                    const i0.Value.absent(),
                i0.Value<double> gridChargePower = const i0.Value.absent(),
                i0.Value<double> solarEnergyToday = const i0.Value.absent(),
                i0.Value<double> solarPower = const i0.Value.absent(),
                i0.Value<double> homeLoadPower = const i0.Value.absent(),
              }) => i1.InverterSnapshotsCompanion(
                id: id,
                inverterId: inverterId,
                gatewayId: gatewayId,
                recordedAt: recordedAt,
                ingestedAt: ingestedAt,
                batteryStateOfCharge: batteryStateOfCharge,
                batteryVoltage: batteryVoltage,
                batteryCurrent: batteryCurrent,
                chargePower: chargePower,
                dischargePower: dischargePower,
                chargeEnergyToday: chargeEnergyToday,
                dischargeEnergyToday: dischargeEnergyToday,
                gridImportPower: gridImportPower,
                gridFrequency: gridFrequency,
                gridVoltage: gridVoltage,
                gridCurrent: gridCurrent,
                gridExportPower: gridExportPower,
                gridExportEnergyToday: gridExportEnergyToday,
                gridImportEnergyToday: gridImportEnergyToday,
                gridChargePower: gridChargePower,
                solarEnergyToday: solarEnergyToday,
                solarPower: solarPower,
                homeLoadPower: homeLoadPower,
              ),
          createCompanionCallback:
              ({
                i0.Value<int> id = const i0.Value.absent(),
                required String inverterId,
                required String gatewayId,
                required DateTime recordedAt,
                required DateTime ingestedAt,
                required double batteryStateOfCharge,
                required double batteryVoltage,
                required double batteryCurrent,
                required double chargePower,
                required double dischargePower,
                required double chargeEnergyToday,
                required double dischargeEnergyToday,
                required double gridImportPower,
                required double gridFrequency,
                required double gridVoltage,
                required double gridCurrent,
                required double gridExportPower,
                required double gridExportEnergyToday,
                required double gridImportEnergyToday,
                required double gridChargePower,
                required double solarEnergyToday,
                required double solarPower,
                required double homeLoadPower,
              }) => i1.InverterSnapshotsCompanion.insert(
                id: id,
                inverterId: inverterId,
                gatewayId: gatewayId,
                recordedAt: recordedAt,
                ingestedAt: ingestedAt,
                batteryStateOfCharge: batteryStateOfCharge,
                batteryVoltage: batteryVoltage,
                batteryCurrent: batteryCurrent,
                chargePower: chargePower,
                dischargePower: dischargePower,
                chargeEnergyToday: chargeEnergyToday,
                dischargeEnergyToday: dischargeEnergyToday,
                gridImportPower: gridImportPower,
                gridFrequency: gridFrequency,
                gridVoltage: gridVoltage,
                gridCurrent: gridCurrent,
                gridExportPower: gridExportPower,
                gridExportEnergyToday: gridExportEnergyToday,
                gridImportEnergyToday: gridImportEnergyToday,
                gridChargePower: gridChargePower,
                solarEnergyToday: solarEnergyToday,
                solarPower: solarPower,
                homeLoadPower: homeLoadPower,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), i0.BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InverterSnapshotsTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i1.$InverterSnapshotsTable,
      i1.InverterSnapshot,
      i1.$$InverterSnapshotsTableFilterComposer,
      i1.$$InverterSnapshotsTableOrderingComposer,
      i1.$$InverterSnapshotsTableAnnotationComposer,
      $$InverterSnapshotsTableCreateCompanionBuilder,
      $$InverterSnapshotsTableUpdateCompanionBuilder,
      (
        i1.InverterSnapshot,
        i0.BaseReferences<
          i0.GeneratedDatabase,
          i1.$InverterSnapshotsTable,
          i1.InverterSnapshot
        >,
      ),
      i1.InverterSnapshot,
      i0.PrefetchHooks Function()
    >;

class $InverterSnapshotsTable extends i2.InverterSnapshots
    with i0.TableInfo<$InverterSnapshotsTable, i1.InverterSnapshot> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InverterSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<int> id = i0.GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: i0.DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _inverterIdMeta = const i0.VerificationMeta(
    'inverterId',
  );
  @override
  late final i0.GeneratedColumn<String> inverterId = i0.GeneratedColumn<String>(
    'inverter_id',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const i0.VerificationMeta _gatewayIdMeta = const i0.VerificationMeta(
    'gatewayId',
  );
  @override
  late final i0.GeneratedColumn<String> gatewayId = i0.GeneratedColumn<String>(
    'gateway_id',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final i0.GeneratedColumnWithTypeConverter<DateTime, double> recordedAt =
      i0.GeneratedColumn<double>(
        'recorded_at',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      ).withConverter<DateTime>(
        i1.$InverterSnapshotsTable.$converterrecordedAt,
      );
  @override
  late final i0.GeneratedColumnWithTypeConverter<DateTime, double> ingestedAt =
      i0.GeneratedColumn<double>(
        'ingested_at',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      ).withConverter<DateTime>(
        i1.$InverterSnapshotsTable.$converteringestedAt,
      );
  static const i0.VerificationMeta _batteryStateOfChargeMeta =
      const i0.VerificationMeta('batteryStateOfCharge');
  @override
  late final i0.GeneratedColumn<double> batteryStateOfCharge =
      i0.GeneratedColumn<double>(
        'battery_state_of_charge',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _batteryVoltageMeta =
      const i0.VerificationMeta('batteryVoltage');
  @override
  late final i0.GeneratedColumn<double> batteryVoltage =
      i0.GeneratedColumn<double>(
        'battery_voltage',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _batteryCurrentMeta =
      const i0.VerificationMeta('batteryCurrent');
  @override
  late final i0.GeneratedColumn<double> batteryCurrent =
      i0.GeneratedColumn<double>(
        'battery_current',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _chargePowerMeta = const i0.VerificationMeta(
    'chargePower',
  );
  @override
  late final i0.GeneratedColumn<double> chargePower =
      i0.GeneratedColumn<double>(
        'charge_power',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _dischargePowerMeta =
      const i0.VerificationMeta('dischargePower');
  @override
  late final i0.GeneratedColumn<double> dischargePower =
      i0.GeneratedColumn<double>(
        'discharge_power',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _chargeEnergyTodayMeta =
      const i0.VerificationMeta('chargeEnergyToday');
  @override
  late final i0.GeneratedColumn<double> chargeEnergyToday =
      i0.GeneratedColumn<double>(
        'charge_energy_today',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _dischargeEnergyTodayMeta =
      const i0.VerificationMeta('dischargeEnergyToday');
  @override
  late final i0.GeneratedColumn<double> dischargeEnergyToday =
      i0.GeneratedColumn<double>(
        'discharge_energy_today',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _gridImportPowerMeta =
      const i0.VerificationMeta('gridImportPower');
  @override
  late final i0.GeneratedColumn<double> gridImportPower =
      i0.GeneratedColumn<double>(
        'grid_import_power',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _gridFrequencyMeta =
      const i0.VerificationMeta('gridFrequency');
  @override
  late final i0.GeneratedColumn<double> gridFrequency =
      i0.GeneratedColumn<double>(
        'grid_frequency',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _gridVoltageMeta = const i0.VerificationMeta(
    'gridVoltage',
  );
  @override
  late final i0.GeneratedColumn<double> gridVoltage =
      i0.GeneratedColumn<double>(
        'grid_voltage',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _gridCurrentMeta = const i0.VerificationMeta(
    'gridCurrent',
  );
  @override
  late final i0.GeneratedColumn<double> gridCurrent =
      i0.GeneratedColumn<double>(
        'grid_current',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _gridExportPowerMeta =
      const i0.VerificationMeta('gridExportPower');
  @override
  late final i0.GeneratedColumn<double> gridExportPower =
      i0.GeneratedColumn<double>(
        'grid_export_power',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _gridExportEnergyTodayMeta =
      const i0.VerificationMeta('gridExportEnergyToday');
  @override
  late final i0.GeneratedColumn<double> gridExportEnergyToday =
      i0.GeneratedColumn<double>(
        'grid_export_energy_today',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _gridImportEnergyTodayMeta =
      const i0.VerificationMeta('gridImportEnergyToday');
  @override
  late final i0.GeneratedColumn<double> gridImportEnergyToday =
      i0.GeneratedColumn<double>(
        'grid_import_energy_today',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _gridChargePowerMeta =
      const i0.VerificationMeta('gridChargePower');
  @override
  late final i0.GeneratedColumn<double> gridChargePower =
      i0.GeneratedColumn<double>(
        'grid_charge_power',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _solarEnergyTodayMeta =
      const i0.VerificationMeta('solarEnergyToday');
  @override
  late final i0.GeneratedColumn<double> solarEnergyToday =
      i0.GeneratedColumn<double>(
        'solar_energy_today',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _solarPowerMeta = const i0.VerificationMeta(
    'solarPower',
  );
  @override
  late final i0.GeneratedColumn<double> solarPower = i0.GeneratedColumn<double>(
    'solar_power',
    aliasedName,
    false,
    type: i0.DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const i0.VerificationMeta _homeLoadPowerMeta =
      const i0.VerificationMeta('homeLoadPower');
  @override
  late final i0.GeneratedColumn<double> homeLoadPower =
      i0.GeneratedColumn<double>(
        'home_load_power',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      );
  @override
  List<i0.GeneratedColumn> get $columns => [
    id,
    inverterId,
    gatewayId,
    recordedAt,
    ingestedAt,
    batteryStateOfCharge,
    batteryVoltage,
    batteryCurrent,
    chargePower,
    dischargePower,
    chargeEnergyToday,
    dischargeEnergyToday,
    gridImportPower,
    gridFrequency,
    gridVoltage,
    gridCurrent,
    gridExportPower,
    gridExportEnergyToday,
    gridImportEnergyToday,
    gridChargePower,
    solarEnergyToday,
    solarPower,
    homeLoadPower,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inverter_snapshots';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i1.InverterSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('inverter_id')) {
      context.handle(
        _inverterIdMeta,
        inverterId.isAcceptableOrUnknown(data['inverter_id']!, _inverterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_inverterIdMeta);
    }
    if (data.containsKey('gateway_id')) {
      context.handle(
        _gatewayIdMeta,
        gatewayId.isAcceptableOrUnknown(data['gateway_id']!, _gatewayIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gatewayIdMeta);
    }
    if (data.containsKey('battery_state_of_charge')) {
      context.handle(
        _batteryStateOfChargeMeta,
        batteryStateOfCharge.isAcceptableOrUnknown(
          data['battery_state_of_charge']!,
          _batteryStateOfChargeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_batteryStateOfChargeMeta);
    }
    if (data.containsKey('battery_voltage')) {
      context.handle(
        _batteryVoltageMeta,
        batteryVoltage.isAcceptableOrUnknown(
          data['battery_voltage']!,
          _batteryVoltageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_batteryVoltageMeta);
    }
    if (data.containsKey('battery_current')) {
      context.handle(
        _batteryCurrentMeta,
        batteryCurrent.isAcceptableOrUnknown(
          data['battery_current']!,
          _batteryCurrentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_batteryCurrentMeta);
    }
    if (data.containsKey('charge_power')) {
      context.handle(
        _chargePowerMeta,
        chargePower.isAcceptableOrUnknown(
          data['charge_power']!,
          _chargePowerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_chargePowerMeta);
    }
    if (data.containsKey('discharge_power')) {
      context.handle(
        _dischargePowerMeta,
        dischargePower.isAcceptableOrUnknown(
          data['discharge_power']!,
          _dischargePowerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dischargePowerMeta);
    }
    if (data.containsKey('charge_energy_today')) {
      context.handle(
        _chargeEnergyTodayMeta,
        chargeEnergyToday.isAcceptableOrUnknown(
          data['charge_energy_today']!,
          _chargeEnergyTodayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_chargeEnergyTodayMeta);
    }
    if (data.containsKey('discharge_energy_today')) {
      context.handle(
        _dischargeEnergyTodayMeta,
        dischargeEnergyToday.isAcceptableOrUnknown(
          data['discharge_energy_today']!,
          _dischargeEnergyTodayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dischargeEnergyTodayMeta);
    }
    if (data.containsKey('grid_import_power')) {
      context.handle(
        _gridImportPowerMeta,
        gridImportPower.isAcceptableOrUnknown(
          data['grid_import_power']!,
          _gridImportPowerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gridImportPowerMeta);
    }
    if (data.containsKey('grid_frequency')) {
      context.handle(
        _gridFrequencyMeta,
        gridFrequency.isAcceptableOrUnknown(
          data['grid_frequency']!,
          _gridFrequencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gridFrequencyMeta);
    }
    if (data.containsKey('grid_voltage')) {
      context.handle(
        _gridVoltageMeta,
        gridVoltage.isAcceptableOrUnknown(
          data['grid_voltage']!,
          _gridVoltageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gridVoltageMeta);
    }
    if (data.containsKey('grid_current')) {
      context.handle(
        _gridCurrentMeta,
        gridCurrent.isAcceptableOrUnknown(
          data['grid_current']!,
          _gridCurrentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gridCurrentMeta);
    }
    if (data.containsKey('grid_export_power')) {
      context.handle(
        _gridExportPowerMeta,
        gridExportPower.isAcceptableOrUnknown(
          data['grid_export_power']!,
          _gridExportPowerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gridExportPowerMeta);
    }
    if (data.containsKey('grid_export_energy_today')) {
      context.handle(
        _gridExportEnergyTodayMeta,
        gridExportEnergyToday.isAcceptableOrUnknown(
          data['grid_export_energy_today']!,
          _gridExportEnergyTodayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gridExportEnergyTodayMeta);
    }
    if (data.containsKey('grid_import_energy_today')) {
      context.handle(
        _gridImportEnergyTodayMeta,
        gridImportEnergyToday.isAcceptableOrUnknown(
          data['grid_import_energy_today']!,
          _gridImportEnergyTodayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gridImportEnergyTodayMeta);
    }
    if (data.containsKey('grid_charge_power')) {
      context.handle(
        _gridChargePowerMeta,
        gridChargePower.isAcceptableOrUnknown(
          data['grid_charge_power']!,
          _gridChargePowerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gridChargePowerMeta);
    }
    if (data.containsKey('solar_energy_today')) {
      context.handle(
        _solarEnergyTodayMeta,
        solarEnergyToday.isAcceptableOrUnknown(
          data['solar_energy_today']!,
          _solarEnergyTodayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_solarEnergyTodayMeta);
    }
    if (data.containsKey('solar_power')) {
      context.handle(
        _solarPowerMeta,
        solarPower.isAcceptableOrUnknown(data['solar_power']!, _solarPowerMeta),
      );
    } else if (isInserting) {
      context.missing(_solarPowerMeta);
    }
    if (data.containsKey('home_load_power')) {
      context.handle(
        _homeLoadPowerMeta,
        homeLoadPower.isAcceptableOrUnknown(
          data['home_load_power']!,
          _homeLoadPowerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_homeLoadPowerMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.InverterSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.InverterSnapshot(
      id: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      inverterId: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}inverter_id'],
      )!,
      gatewayId: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}gateway_id'],
      )!,
      recordedAt: i1.$InverterSnapshotsTable.$converterrecordedAt.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.double,
          data['${effectivePrefix}recorded_at'],
        )!,
      ),
      ingestedAt: i1.$InverterSnapshotsTable.$converteringestedAt.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.double,
          data['${effectivePrefix}ingested_at'],
        )!,
      ),
      batteryStateOfCharge: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}battery_state_of_charge'],
      )!,
      batteryVoltage: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}battery_voltage'],
      )!,
      batteryCurrent: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}battery_current'],
      )!,
      chargePower: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}charge_power'],
      )!,
      dischargePower: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}discharge_power'],
      )!,
      chargeEnergyToday: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}charge_energy_today'],
      )!,
      dischargeEnergyToday: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}discharge_energy_today'],
      )!,
      gridImportPower: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}grid_import_power'],
      )!,
      gridFrequency: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}grid_frequency'],
      )!,
      gridVoltage: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}grid_voltage'],
      )!,
      gridCurrent: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}grid_current'],
      )!,
      gridExportPower: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}grid_export_power'],
      )!,
      gridExportEnergyToday: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}grid_export_energy_today'],
      )!,
      gridImportEnergyToday: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}grid_import_energy_today'],
      )!,
      gridChargePower: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}grid_charge_power'],
      )!,
      solarEnergyToday: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}solar_energy_today'],
      )!,
      solarPower: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}solar_power'],
      )!,
      homeLoadPower: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}home_load_power'],
      )!,
    );
  }

  @override
  $InverterSnapshotsTable createAlias(String alias) {
    return $InverterSnapshotsTable(attachedDatabase, alias);
  }

  static i0.JsonTypeConverter2<DateTime, double, String> $converterrecordedAt =
      const i3.DateTimeConverter();
  static i0.JsonTypeConverter2<DateTime, double, String> $converteringestedAt =
      const i3.DateTimeConverter();
}

class InverterSnapshot extends i0.DataClass
    implements i0.Insertable<i1.InverterSnapshot> {
  final int id;
  final String inverterId;
  final String gatewayId;
  final DateTime recordedAt;
  final DateTime ingestedAt;
  final double batteryStateOfCharge;
  final double batteryVoltage;
  final double batteryCurrent;
  final double chargePower;
  final double dischargePower;
  final double chargeEnergyToday;
  final double dischargeEnergyToday;
  final double gridImportPower;
  final double gridFrequency;
  final double gridVoltage;
  final double gridCurrent;
  final double gridExportPower;
  final double gridExportEnergyToday;
  final double gridImportEnergyToday;
  final double gridChargePower;
  final double solarEnergyToday;
  final double solarPower;
  final double homeLoadPower;
  const InverterSnapshot({
    required this.id,
    required this.inverterId,
    required this.gatewayId,
    required this.recordedAt,
    required this.ingestedAt,
    required this.batteryStateOfCharge,
    required this.batteryVoltage,
    required this.batteryCurrent,
    required this.chargePower,
    required this.dischargePower,
    required this.chargeEnergyToday,
    required this.dischargeEnergyToday,
    required this.gridImportPower,
    required this.gridFrequency,
    required this.gridVoltage,
    required this.gridCurrent,
    required this.gridExportPower,
    required this.gridExportEnergyToday,
    required this.gridImportEnergyToday,
    required this.gridChargePower,
    required this.solarEnergyToday,
    required this.solarPower,
    required this.homeLoadPower,
  });
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<int>(id);
    map['inverter_id'] = i0.Variable<String>(inverterId);
    map['gateway_id'] = i0.Variable<String>(gatewayId);
    {
      map['recorded_at'] = i0.Variable<double>(
        i1.$InverterSnapshotsTable.$converterrecordedAt.toSql(recordedAt),
      );
    }
    {
      map['ingested_at'] = i0.Variable<double>(
        i1.$InverterSnapshotsTable.$converteringestedAt.toSql(ingestedAt),
      );
    }
    map['battery_state_of_charge'] = i0.Variable<double>(batteryStateOfCharge);
    map['battery_voltage'] = i0.Variable<double>(batteryVoltage);
    map['battery_current'] = i0.Variable<double>(batteryCurrent);
    map['charge_power'] = i0.Variable<double>(chargePower);
    map['discharge_power'] = i0.Variable<double>(dischargePower);
    map['charge_energy_today'] = i0.Variable<double>(chargeEnergyToday);
    map['discharge_energy_today'] = i0.Variable<double>(dischargeEnergyToday);
    map['grid_import_power'] = i0.Variable<double>(gridImportPower);
    map['grid_frequency'] = i0.Variable<double>(gridFrequency);
    map['grid_voltage'] = i0.Variable<double>(gridVoltage);
    map['grid_current'] = i0.Variable<double>(gridCurrent);
    map['grid_export_power'] = i0.Variable<double>(gridExportPower);
    map['grid_export_energy_today'] = i0.Variable<double>(
      gridExportEnergyToday,
    );
    map['grid_import_energy_today'] = i0.Variable<double>(
      gridImportEnergyToday,
    );
    map['grid_charge_power'] = i0.Variable<double>(gridChargePower);
    map['solar_energy_today'] = i0.Variable<double>(solarEnergyToday);
    map['solar_power'] = i0.Variable<double>(solarPower);
    map['home_load_power'] = i0.Variable<double>(homeLoadPower);
    return map;
  }

  i1.InverterSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return i1.InverterSnapshotsCompanion(
      id: i0.Value(id),
      inverterId: i0.Value(inverterId),
      gatewayId: i0.Value(gatewayId),
      recordedAt: i0.Value(recordedAt),
      ingestedAt: i0.Value(ingestedAt),
      batteryStateOfCharge: i0.Value(batteryStateOfCharge),
      batteryVoltage: i0.Value(batteryVoltage),
      batteryCurrent: i0.Value(batteryCurrent),
      chargePower: i0.Value(chargePower),
      dischargePower: i0.Value(dischargePower),
      chargeEnergyToday: i0.Value(chargeEnergyToday),
      dischargeEnergyToday: i0.Value(dischargeEnergyToday),
      gridImportPower: i0.Value(gridImportPower),
      gridFrequency: i0.Value(gridFrequency),
      gridVoltage: i0.Value(gridVoltage),
      gridCurrent: i0.Value(gridCurrent),
      gridExportPower: i0.Value(gridExportPower),
      gridExportEnergyToday: i0.Value(gridExportEnergyToday),
      gridImportEnergyToday: i0.Value(gridImportEnergyToday),
      gridChargePower: i0.Value(gridChargePower),
      solarEnergyToday: i0.Value(solarEnergyToday),
      solarPower: i0.Value(solarPower),
      homeLoadPower: i0.Value(homeLoadPower),
    );
  }

  factory InverterSnapshot.fromJson(
    Map<String, dynamic> json, {
    i0.ValueSerializer? serializer,
  }) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return InverterSnapshot(
      id: serializer.fromJson<int>(json['id']),
      inverterId: serializer.fromJson<String>(json['inverter_id']),
      gatewayId: serializer.fromJson<String>(json['gateway_id']),
      recordedAt: i1.$InverterSnapshotsTable.$converterrecordedAt.fromJson(
        serializer.fromJson<String>(json['recorded_at']),
      ),
      ingestedAt: i1.$InverterSnapshotsTable.$converteringestedAt.fromJson(
        serializer.fromJson<String>(json['ingested_at']),
      ),
      batteryStateOfCharge: serializer.fromJson<double>(
        json['battery_soc_percent'],
      ),
      batteryVoltage: serializer.fromJson<double>(json['battery_voltage_v']),
      batteryCurrent: serializer.fromJson<double>(json['battery_current_a']),
      chargePower: serializer.fromJson<double>(json['battery_charge_power_w']),
      dischargePower: serializer.fromJson<double>(
        json['battery_discharge_power_w'],
      ),
      chargeEnergyToday: serializer.fromJson<double>(
        json['battery_charge_energy_today_kwh'],
      ),
      dischargeEnergyToday: serializer.fromJson<double>(
        json['battery_discharge_energy_today_kwh'],
      ),
      gridImportPower: serializer.fromJson<double>(json['grid_import_power_w']),
      gridFrequency: serializer.fromJson<double>(json['grid_frequency_hz']),
      gridVoltage: serializer.fromJson<double>(json['grid_voltage_v']),
      gridCurrent: serializer.fromJson<double>(json['grid_current_a']),
      gridExportPower: serializer.fromJson<double>(json['grid_export_power_w']),
      gridExportEnergyToday: serializer.fromJson<double>(
        json['grid_export_energy_today_kwh'],
      ),
      gridImportEnergyToday: serializer.fromJson<double>(
        json['grid_import_energy_today_kwh'],
      ),
      gridChargePower: serializer.fromJson<double>(json['grid_charge_power_w']),
      solarEnergyToday: serializer.fromJson<double>(
        json['solar_energy_today_kwh'],
      ),
      solarPower: serializer.fromJson<double>(json['solar_power_w']),
      homeLoadPower: serializer.fromJson<double>(json['home_load_power_w']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'inverter_id': serializer.toJson<String>(inverterId),
      'gateway_id': serializer.toJson<String>(gatewayId),
      'recorded_at': serializer.toJson<String>(
        i1.$InverterSnapshotsTable.$converterrecordedAt.toJson(recordedAt),
      ),
      'ingested_at': serializer.toJson<String>(
        i1.$InverterSnapshotsTable.$converteringestedAt.toJson(ingestedAt),
      ),
      'battery_soc_percent': serializer.toJson<double>(batteryStateOfCharge),
      'battery_voltage_v': serializer.toJson<double>(batteryVoltage),
      'battery_current_a': serializer.toJson<double>(batteryCurrent),
      'battery_charge_power_w': serializer.toJson<double>(chargePower),
      'battery_discharge_power_w': serializer.toJson<double>(dischargePower),
      'battery_charge_energy_today_kwh': serializer.toJson<double>(
        chargeEnergyToday,
      ),
      'battery_discharge_energy_today_kwh': serializer.toJson<double>(
        dischargeEnergyToday,
      ),
      'grid_import_power_w': serializer.toJson<double>(gridImportPower),
      'grid_frequency_hz': serializer.toJson<double>(gridFrequency),
      'grid_voltage_v': serializer.toJson<double>(gridVoltage),
      'grid_current_a': serializer.toJson<double>(gridCurrent),
      'grid_export_power_w': serializer.toJson<double>(gridExportPower),
      'grid_export_energy_today_kwh': serializer.toJson<double>(
        gridExportEnergyToday,
      ),
      'grid_import_energy_today_kwh': serializer.toJson<double>(
        gridImportEnergyToday,
      ),
      'grid_charge_power_w': serializer.toJson<double>(gridChargePower),
      'solar_energy_today_kwh': serializer.toJson<double>(solarEnergyToday),
      'solar_power_w': serializer.toJson<double>(solarPower),
      'home_load_power_w': serializer.toJson<double>(homeLoadPower),
    };
  }

  i1.InverterSnapshot copyWith({
    int? id,
    String? inverterId,
    String? gatewayId,
    DateTime? recordedAt,
    DateTime? ingestedAt,
    double? batteryStateOfCharge,
    double? batteryVoltage,
    double? batteryCurrent,
    double? chargePower,
    double? dischargePower,
    double? chargeEnergyToday,
    double? dischargeEnergyToday,
    double? gridImportPower,
    double? gridFrequency,
    double? gridVoltage,
    double? gridCurrent,
    double? gridExportPower,
    double? gridExportEnergyToday,
    double? gridImportEnergyToday,
    double? gridChargePower,
    double? solarEnergyToday,
    double? solarPower,
    double? homeLoadPower,
  }) => i1.InverterSnapshot(
    id: id ?? this.id,
    inverterId: inverterId ?? this.inverterId,
    gatewayId: gatewayId ?? this.gatewayId,
    recordedAt: recordedAt ?? this.recordedAt,
    ingestedAt: ingestedAt ?? this.ingestedAt,
    batteryStateOfCharge: batteryStateOfCharge ?? this.batteryStateOfCharge,
    batteryVoltage: batteryVoltage ?? this.batteryVoltage,
    batteryCurrent: batteryCurrent ?? this.batteryCurrent,
    chargePower: chargePower ?? this.chargePower,
    dischargePower: dischargePower ?? this.dischargePower,
    chargeEnergyToday: chargeEnergyToday ?? this.chargeEnergyToday,
    dischargeEnergyToday: dischargeEnergyToday ?? this.dischargeEnergyToday,
    gridImportPower: gridImportPower ?? this.gridImportPower,
    gridFrequency: gridFrequency ?? this.gridFrequency,
    gridVoltage: gridVoltage ?? this.gridVoltage,
    gridCurrent: gridCurrent ?? this.gridCurrent,
    gridExportPower: gridExportPower ?? this.gridExportPower,
    gridExportEnergyToday: gridExportEnergyToday ?? this.gridExportEnergyToday,
    gridImportEnergyToday: gridImportEnergyToday ?? this.gridImportEnergyToday,
    gridChargePower: gridChargePower ?? this.gridChargePower,
    solarEnergyToday: solarEnergyToday ?? this.solarEnergyToday,
    solarPower: solarPower ?? this.solarPower,
    homeLoadPower: homeLoadPower ?? this.homeLoadPower,
  );
  InverterSnapshot copyWithCompanion(i1.InverterSnapshotsCompanion data) {
    return InverterSnapshot(
      id: data.id.present ? data.id.value : this.id,
      inverterId: data.inverterId.present
          ? data.inverterId.value
          : this.inverterId,
      gatewayId: data.gatewayId.present ? data.gatewayId.value : this.gatewayId,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      ingestedAt: data.ingestedAt.present
          ? data.ingestedAt.value
          : this.ingestedAt,
      batteryStateOfCharge: data.batteryStateOfCharge.present
          ? data.batteryStateOfCharge.value
          : this.batteryStateOfCharge,
      batteryVoltage: data.batteryVoltage.present
          ? data.batteryVoltage.value
          : this.batteryVoltage,
      batteryCurrent: data.batteryCurrent.present
          ? data.batteryCurrent.value
          : this.batteryCurrent,
      chargePower: data.chargePower.present
          ? data.chargePower.value
          : this.chargePower,
      dischargePower: data.dischargePower.present
          ? data.dischargePower.value
          : this.dischargePower,
      chargeEnergyToday: data.chargeEnergyToday.present
          ? data.chargeEnergyToday.value
          : this.chargeEnergyToday,
      dischargeEnergyToday: data.dischargeEnergyToday.present
          ? data.dischargeEnergyToday.value
          : this.dischargeEnergyToday,
      gridImportPower: data.gridImportPower.present
          ? data.gridImportPower.value
          : this.gridImportPower,
      gridFrequency: data.gridFrequency.present
          ? data.gridFrequency.value
          : this.gridFrequency,
      gridVoltage: data.gridVoltage.present
          ? data.gridVoltage.value
          : this.gridVoltage,
      gridCurrent: data.gridCurrent.present
          ? data.gridCurrent.value
          : this.gridCurrent,
      gridExportPower: data.gridExportPower.present
          ? data.gridExportPower.value
          : this.gridExportPower,
      gridExportEnergyToday: data.gridExportEnergyToday.present
          ? data.gridExportEnergyToday.value
          : this.gridExportEnergyToday,
      gridImportEnergyToday: data.gridImportEnergyToday.present
          ? data.gridImportEnergyToday.value
          : this.gridImportEnergyToday,
      gridChargePower: data.gridChargePower.present
          ? data.gridChargePower.value
          : this.gridChargePower,
      solarEnergyToday: data.solarEnergyToday.present
          ? data.solarEnergyToday.value
          : this.solarEnergyToday,
      solarPower: data.solarPower.present
          ? data.solarPower.value
          : this.solarPower,
      homeLoadPower: data.homeLoadPower.present
          ? data.homeLoadPower.value
          : this.homeLoadPower,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InverterSnapshot(')
          ..write('id: $id, ')
          ..write('inverterId: $inverterId, ')
          ..write('gatewayId: $gatewayId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('ingestedAt: $ingestedAt, ')
          ..write('batteryStateOfCharge: $batteryStateOfCharge, ')
          ..write('batteryVoltage: $batteryVoltage, ')
          ..write('batteryCurrent: $batteryCurrent, ')
          ..write('chargePower: $chargePower, ')
          ..write('dischargePower: $dischargePower, ')
          ..write('chargeEnergyToday: $chargeEnergyToday, ')
          ..write('dischargeEnergyToday: $dischargeEnergyToday, ')
          ..write('gridImportPower: $gridImportPower, ')
          ..write('gridFrequency: $gridFrequency, ')
          ..write('gridVoltage: $gridVoltage, ')
          ..write('gridCurrent: $gridCurrent, ')
          ..write('gridExportPower: $gridExportPower, ')
          ..write('gridExportEnergyToday: $gridExportEnergyToday, ')
          ..write('gridImportEnergyToday: $gridImportEnergyToday, ')
          ..write('gridChargePower: $gridChargePower, ')
          ..write('solarEnergyToday: $solarEnergyToday, ')
          ..write('solarPower: $solarPower, ')
          ..write('homeLoadPower: $homeLoadPower')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    inverterId,
    gatewayId,
    recordedAt,
    ingestedAt,
    batteryStateOfCharge,
    batteryVoltage,
    batteryCurrent,
    chargePower,
    dischargePower,
    chargeEnergyToday,
    dischargeEnergyToday,
    gridImportPower,
    gridFrequency,
    gridVoltage,
    gridCurrent,
    gridExportPower,
    gridExportEnergyToday,
    gridImportEnergyToday,
    gridChargePower,
    solarEnergyToday,
    solarPower,
    homeLoadPower,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.InverterSnapshot &&
          other.id == this.id &&
          other.inverterId == this.inverterId &&
          other.gatewayId == this.gatewayId &&
          other.recordedAt == this.recordedAt &&
          other.ingestedAt == this.ingestedAt &&
          other.batteryStateOfCharge == this.batteryStateOfCharge &&
          other.batteryVoltage == this.batteryVoltage &&
          other.batteryCurrent == this.batteryCurrent &&
          other.chargePower == this.chargePower &&
          other.dischargePower == this.dischargePower &&
          other.chargeEnergyToday == this.chargeEnergyToday &&
          other.dischargeEnergyToday == this.dischargeEnergyToday &&
          other.gridImportPower == this.gridImportPower &&
          other.gridFrequency == this.gridFrequency &&
          other.gridVoltage == this.gridVoltage &&
          other.gridCurrent == this.gridCurrent &&
          other.gridExportPower == this.gridExportPower &&
          other.gridExportEnergyToday == this.gridExportEnergyToday &&
          other.gridImportEnergyToday == this.gridImportEnergyToday &&
          other.gridChargePower == this.gridChargePower &&
          other.solarEnergyToday == this.solarEnergyToday &&
          other.solarPower == this.solarPower &&
          other.homeLoadPower == this.homeLoadPower);
}

class InverterSnapshotsCompanion
    extends i0.UpdateCompanion<i1.InverterSnapshot> {
  final i0.Value<int> id;
  final i0.Value<String> inverterId;
  final i0.Value<String> gatewayId;
  final i0.Value<DateTime> recordedAt;
  final i0.Value<DateTime> ingestedAt;
  final i0.Value<double> batteryStateOfCharge;
  final i0.Value<double> batteryVoltage;
  final i0.Value<double> batteryCurrent;
  final i0.Value<double> chargePower;
  final i0.Value<double> dischargePower;
  final i0.Value<double> chargeEnergyToday;
  final i0.Value<double> dischargeEnergyToday;
  final i0.Value<double> gridImportPower;
  final i0.Value<double> gridFrequency;
  final i0.Value<double> gridVoltage;
  final i0.Value<double> gridCurrent;
  final i0.Value<double> gridExportPower;
  final i0.Value<double> gridExportEnergyToday;
  final i0.Value<double> gridImportEnergyToday;
  final i0.Value<double> gridChargePower;
  final i0.Value<double> solarEnergyToday;
  final i0.Value<double> solarPower;
  final i0.Value<double> homeLoadPower;
  const InverterSnapshotsCompanion({
    this.id = const i0.Value.absent(),
    this.inverterId = const i0.Value.absent(),
    this.gatewayId = const i0.Value.absent(),
    this.recordedAt = const i0.Value.absent(),
    this.ingestedAt = const i0.Value.absent(),
    this.batteryStateOfCharge = const i0.Value.absent(),
    this.batteryVoltage = const i0.Value.absent(),
    this.batteryCurrent = const i0.Value.absent(),
    this.chargePower = const i0.Value.absent(),
    this.dischargePower = const i0.Value.absent(),
    this.chargeEnergyToday = const i0.Value.absent(),
    this.dischargeEnergyToday = const i0.Value.absent(),
    this.gridImportPower = const i0.Value.absent(),
    this.gridFrequency = const i0.Value.absent(),
    this.gridVoltage = const i0.Value.absent(),
    this.gridCurrent = const i0.Value.absent(),
    this.gridExportPower = const i0.Value.absent(),
    this.gridExportEnergyToday = const i0.Value.absent(),
    this.gridImportEnergyToday = const i0.Value.absent(),
    this.gridChargePower = const i0.Value.absent(),
    this.solarEnergyToday = const i0.Value.absent(),
    this.solarPower = const i0.Value.absent(),
    this.homeLoadPower = const i0.Value.absent(),
  });
  InverterSnapshotsCompanion.insert({
    this.id = const i0.Value.absent(),
    required String inverterId,
    required String gatewayId,
    required DateTime recordedAt,
    required DateTime ingestedAt,
    required double batteryStateOfCharge,
    required double batteryVoltage,
    required double batteryCurrent,
    required double chargePower,
    required double dischargePower,
    required double chargeEnergyToday,
    required double dischargeEnergyToday,
    required double gridImportPower,
    required double gridFrequency,
    required double gridVoltage,
    required double gridCurrent,
    required double gridExportPower,
    required double gridExportEnergyToday,
    required double gridImportEnergyToday,
    required double gridChargePower,
    required double solarEnergyToday,
    required double solarPower,
    required double homeLoadPower,
  }) : inverterId = i0.Value(inverterId),
       gatewayId = i0.Value(gatewayId),
       recordedAt = i0.Value(recordedAt),
       ingestedAt = i0.Value(ingestedAt),
       batteryStateOfCharge = i0.Value(batteryStateOfCharge),
       batteryVoltage = i0.Value(batteryVoltage),
       batteryCurrent = i0.Value(batteryCurrent),
       chargePower = i0.Value(chargePower),
       dischargePower = i0.Value(dischargePower),
       chargeEnergyToday = i0.Value(chargeEnergyToday),
       dischargeEnergyToday = i0.Value(dischargeEnergyToday),
       gridImportPower = i0.Value(gridImportPower),
       gridFrequency = i0.Value(gridFrequency),
       gridVoltage = i0.Value(gridVoltage),
       gridCurrent = i0.Value(gridCurrent),
       gridExportPower = i0.Value(gridExportPower),
       gridExportEnergyToday = i0.Value(gridExportEnergyToday),
       gridImportEnergyToday = i0.Value(gridImportEnergyToday),
       gridChargePower = i0.Value(gridChargePower),
       solarEnergyToday = i0.Value(solarEnergyToday),
       solarPower = i0.Value(solarPower),
       homeLoadPower = i0.Value(homeLoadPower);
  static i0.Insertable<i1.InverterSnapshot> custom({
    i0.Expression<int>? id,
    i0.Expression<String>? inverterId,
    i0.Expression<String>? gatewayId,
    i0.Expression<double>? recordedAt,
    i0.Expression<double>? ingestedAt,
    i0.Expression<double>? batteryStateOfCharge,
    i0.Expression<double>? batteryVoltage,
    i0.Expression<double>? batteryCurrent,
    i0.Expression<double>? chargePower,
    i0.Expression<double>? dischargePower,
    i0.Expression<double>? chargeEnergyToday,
    i0.Expression<double>? dischargeEnergyToday,
    i0.Expression<double>? gridImportPower,
    i0.Expression<double>? gridFrequency,
    i0.Expression<double>? gridVoltage,
    i0.Expression<double>? gridCurrent,
    i0.Expression<double>? gridExportPower,
    i0.Expression<double>? gridExportEnergyToday,
    i0.Expression<double>? gridImportEnergyToday,
    i0.Expression<double>? gridChargePower,
    i0.Expression<double>? solarEnergyToday,
    i0.Expression<double>? solarPower,
    i0.Expression<double>? homeLoadPower,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (inverterId != null) 'inverter_id': inverterId,
      if (gatewayId != null) 'gateway_id': gatewayId,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (ingestedAt != null) 'ingested_at': ingestedAt,
      if (batteryStateOfCharge != null)
        'battery_state_of_charge': batteryStateOfCharge,
      if (batteryVoltage != null) 'battery_voltage': batteryVoltage,
      if (batteryCurrent != null) 'battery_current': batteryCurrent,
      if (chargePower != null) 'charge_power': chargePower,
      if (dischargePower != null) 'discharge_power': dischargePower,
      if (chargeEnergyToday != null) 'charge_energy_today': chargeEnergyToday,
      if (dischargeEnergyToday != null)
        'discharge_energy_today': dischargeEnergyToday,
      if (gridImportPower != null) 'grid_import_power': gridImportPower,
      if (gridFrequency != null) 'grid_frequency': gridFrequency,
      if (gridVoltage != null) 'grid_voltage': gridVoltage,
      if (gridCurrent != null) 'grid_current': gridCurrent,
      if (gridExportPower != null) 'grid_export_power': gridExportPower,
      if (gridExportEnergyToday != null)
        'grid_export_energy_today': gridExportEnergyToday,
      if (gridImportEnergyToday != null)
        'grid_import_energy_today': gridImportEnergyToday,
      if (gridChargePower != null) 'grid_charge_power': gridChargePower,
      if (solarEnergyToday != null) 'solar_energy_today': solarEnergyToday,
      if (solarPower != null) 'solar_power': solarPower,
      if (homeLoadPower != null) 'home_load_power': homeLoadPower,
    });
  }

  i1.InverterSnapshotsCompanion copyWith({
    i0.Value<int>? id,
    i0.Value<String>? inverterId,
    i0.Value<String>? gatewayId,
    i0.Value<DateTime>? recordedAt,
    i0.Value<DateTime>? ingestedAt,
    i0.Value<double>? batteryStateOfCharge,
    i0.Value<double>? batteryVoltage,
    i0.Value<double>? batteryCurrent,
    i0.Value<double>? chargePower,
    i0.Value<double>? dischargePower,
    i0.Value<double>? chargeEnergyToday,
    i0.Value<double>? dischargeEnergyToday,
    i0.Value<double>? gridImportPower,
    i0.Value<double>? gridFrequency,
    i0.Value<double>? gridVoltage,
    i0.Value<double>? gridCurrent,
    i0.Value<double>? gridExportPower,
    i0.Value<double>? gridExportEnergyToday,
    i0.Value<double>? gridImportEnergyToday,
    i0.Value<double>? gridChargePower,
    i0.Value<double>? solarEnergyToday,
    i0.Value<double>? solarPower,
    i0.Value<double>? homeLoadPower,
  }) {
    return i1.InverterSnapshotsCompanion(
      id: id ?? this.id,
      inverterId: inverterId ?? this.inverterId,
      gatewayId: gatewayId ?? this.gatewayId,
      recordedAt: recordedAt ?? this.recordedAt,
      ingestedAt: ingestedAt ?? this.ingestedAt,
      batteryStateOfCharge: batteryStateOfCharge ?? this.batteryStateOfCharge,
      batteryVoltage: batteryVoltage ?? this.batteryVoltage,
      batteryCurrent: batteryCurrent ?? this.batteryCurrent,
      chargePower: chargePower ?? this.chargePower,
      dischargePower: dischargePower ?? this.dischargePower,
      chargeEnergyToday: chargeEnergyToday ?? this.chargeEnergyToday,
      dischargeEnergyToday: dischargeEnergyToday ?? this.dischargeEnergyToday,
      gridImportPower: gridImportPower ?? this.gridImportPower,
      gridFrequency: gridFrequency ?? this.gridFrequency,
      gridVoltage: gridVoltage ?? this.gridVoltage,
      gridCurrent: gridCurrent ?? this.gridCurrent,
      gridExportPower: gridExportPower ?? this.gridExportPower,
      gridExportEnergyToday:
          gridExportEnergyToday ?? this.gridExportEnergyToday,
      gridImportEnergyToday:
          gridImportEnergyToday ?? this.gridImportEnergyToday,
      gridChargePower: gridChargePower ?? this.gridChargePower,
      solarEnergyToday: solarEnergyToday ?? this.solarEnergyToday,
      solarPower: solarPower ?? this.solarPower,
      homeLoadPower: homeLoadPower ?? this.homeLoadPower,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<int>(id.value);
    }
    if (inverterId.present) {
      map['inverter_id'] = i0.Variable<String>(inverterId.value);
    }
    if (gatewayId.present) {
      map['gateway_id'] = i0.Variable<String>(gatewayId.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = i0.Variable<double>(
        i1.$InverterSnapshotsTable.$converterrecordedAt.toSql(recordedAt.value),
      );
    }
    if (ingestedAt.present) {
      map['ingested_at'] = i0.Variable<double>(
        i1.$InverterSnapshotsTable.$converteringestedAt.toSql(ingestedAt.value),
      );
    }
    if (batteryStateOfCharge.present) {
      map['battery_state_of_charge'] = i0.Variable<double>(
        batteryStateOfCharge.value,
      );
    }
    if (batteryVoltage.present) {
      map['battery_voltage'] = i0.Variable<double>(batteryVoltage.value);
    }
    if (batteryCurrent.present) {
      map['battery_current'] = i0.Variable<double>(batteryCurrent.value);
    }
    if (chargePower.present) {
      map['charge_power'] = i0.Variable<double>(chargePower.value);
    }
    if (dischargePower.present) {
      map['discharge_power'] = i0.Variable<double>(dischargePower.value);
    }
    if (chargeEnergyToday.present) {
      map['charge_energy_today'] = i0.Variable<double>(chargeEnergyToday.value);
    }
    if (dischargeEnergyToday.present) {
      map['discharge_energy_today'] = i0.Variable<double>(
        dischargeEnergyToday.value,
      );
    }
    if (gridImportPower.present) {
      map['grid_import_power'] = i0.Variable<double>(gridImportPower.value);
    }
    if (gridFrequency.present) {
      map['grid_frequency'] = i0.Variable<double>(gridFrequency.value);
    }
    if (gridVoltage.present) {
      map['grid_voltage'] = i0.Variable<double>(gridVoltage.value);
    }
    if (gridCurrent.present) {
      map['grid_current'] = i0.Variable<double>(gridCurrent.value);
    }
    if (gridExportPower.present) {
      map['grid_export_power'] = i0.Variable<double>(gridExportPower.value);
    }
    if (gridExportEnergyToday.present) {
      map['grid_export_energy_today'] = i0.Variable<double>(
        gridExportEnergyToday.value,
      );
    }
    if (gridImportEnergyToday.present) {
      map['grid_import_energy_today'] = i0.Variable<double>(
        gridImportEnergyToday.value,
      );
    }
    if (gridChargePower.present) {
      map['grid_charge_power'] = i0.Variable<double>(gridChargePower.value);
    }
    if (solarEnergyToday.present) {
      map['solar_energy_today'] = i0.Variable<double>(solarEnergyToday.value);
    }
    if (solarPower.present) {
      map['solar_power'] = i0.Variable<double>(solarPower.value);
    }
    if (homeLoadPower.present) {
      map['home_load_power'] = i0.Variable<double>(homeLoadPower.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InverterSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('inverterId: $inverterId, ')
          ..write('gatewayId: $gatewayId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('ingestedAt: $ingestedAt, ')
          ..write('batteryStateOfCharge: $batteryStateOfCharge, ')
          ..write('batteryVoltage: $batteryVoltage, ')
          ..write('batteryCurrent: $batteryCurrent, ')
          ..write('chargePower: $chargePower, ')
          ..write('dischargePower: $dischargePower, ')
          ..write('chargeEnergyToday: $chargeEnergyToday, ')
          ..write('dischargeEnergyToday: $dischargeEnergyToday, ')
          ..write('gridImportPower: $gridImportPower, ')
          ..write('gridFrequency: $gridFrequency, ')
          ..write('gridVoltage: $gridVoltage, ')
          ..write('gridCurrent: $gridCurrent, ')
          ..write('gridExportPower: $gridExportPower, ')
          ..write('gridExportEnergyToday: $gridExportEnergyToday, ')
          ..write('gridImportEnergyToday: $gridImportEnergyToday, ')
          ..write('gridChargePower: $gridChargePower, ')
          ..write('solarEnergyToday: $solarEnergyToday, ')
          ..write('solarPower: $solarPower, ')
          ..write('homeLoadPower: $homeLoadPower')
          ..write(')'))
        .toString();
  }
}
