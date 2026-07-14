// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:grobase/models/database/gateway.drift.dart' as i1;
import 'package:grobase/models/database/gateway.dart' as i2;
import 'package:grobase/models/database/converters.dart' as i3;

typedef $$GatewaysTableCreateCompanionBuilder =
    i1.GatewaysCompanion Function({
      required String id,
      required String hardwareId,
      required String inverterId,
      required i2.GatewayStatus status,
      required String provisionedBy,
      required DateTime lastSeenAt,
      required String firmwareVersion,
      required DateTime createdAt,
      required DateTime retiredAt,
      i0.Value<int> rowid,
    });
typedef $$GatewaysTableUpdateCompanionBuilder =
    i1.GatewaysCompanion Function({
      i0.Value<String> id,
      i0.Value<String> hardwareId,
      i0.Value<String> inverterId,
      i0.Value<i2.GatewayStatus> status,
      i0.Value<String> provisionedBy,
      i0.Value<DateTime> lastSeenAt,
      i0.Value<String> firmwareVersion,
      i0.Value<DateTime> createdAt,
      i0.Value<DateTime> retiredAt,
      i0.Value<int> rowid,
    });

class $$GatewaysTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$GatewaysTable> {
  $$GatewaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get hardwareId => $composableBuilder(
    column: $table.hardwareId,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get inverterId => $composableBuilder(
    column: $table.inverterId,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<i2.GatewayStatus, i2.GatewayStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnFilters<String> get provisionedBy => $composableBuilder(
    column: $table.provisionedBy,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<DateTime, DateTime, double>
  get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnFilters<String> get firmwareVersion => $composableBuilder(
    column: $table.firmwareVersion,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<DateTime, DateTime, double> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => i0.ColumnWithTypeConverterFilters(column),
      );

  i0.ColumnWithTypeConverterFilters<DateTime, DateTime, double> get retiredAt =>
      $composableBuilder(
        column: $table.retiredAt,
        builder: (column) => i0.ColumnWithTypeConverterFilters(column),
      );
}

class $$GatewaysTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$GatewaysTable> {
  $$GatewaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get hardwareId => $composableBuilder(
    column: $table.hardwareId,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get inverterId => $composableBuilder(
    column: $table.inverterId,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get provisionedBy => $composableBuilder(
    column: $table.provisionedBy,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get firmwareVersion => $composableBuilder(
    column: $table.firmwareVersion,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get retiredAt => $composableBuilder(
    column: $table.retiredAt,
    builder: (column) => i0.ColumnOrderings(column),
  );
}

class $$GatewaysTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$GatewaysTable> {
  $$GatewaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  i0.GeneratedColumn<String> get hardwareId => $composableBuilder(
    column: $table.hardwareId,
    builder: (column) => column,
  );

  i0.GeneratedColumn<String> get inverterId => $composableBuilder(
    column: $table.inverterId,
    builder: (column) => column,
  );

  i0.GeneratedColumnWithTypeConverter<i2.GatewayStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  i0.GeneratedColumn<String> get provisionedBy => $composableBuilder(
    column: $table.provisionedBy,
    builder: (column) => column,
  );

  i0.GeneratedColumnWithTypeConverter<DateTime, double> get lastSeenAt =>
      $composableBuilder(
        column: $table.lastSeenAt,
        builder: (column) => column,
      );

  i0.GeneratedColumn<String> get firmwareVersion => $composableBuilder(
    column: $table.firmwareVersion,
    builder: (column) => column,
  );

  i0.GeneratedColumnWithTypeConverter<DateTime, double> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<DateTime, double> get retiredAt =>
      $composableBuilder(column: $table.retiredAt, builder: (column) => column);
}

class $$GatewaysTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i1.$GatewaysTable,
          i1.Gateway,
          i1.$$GatewaysTableFilterComposer,
          i1.$$GatewaysTableOrderingComposer,
          i1.$$GatewaysTableAnnotationComposer,
          $$GatewaysTableCreateCompanionBuilder,
          $$GatewaysTableUpdateCompanionBuilder,
          (
            i1.Gateway,
            i0.BaseReferences<
              i0.GeneratedDatabase,
              i1.$GatewaysTable,
              i1.Gateway
            >,
          ),
          i1.Gateway,
          i0.PrefetchHooks Function()
        > {
  $$GatewaysTableTableManager(i0.GeneratedDatabase db, i1.$GatewaysTable table)
    : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i1.$$GatewaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              i1.$$GatewaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              i1.$$GatewaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                i0.Value<String> id = const i0.Value.absent(),
                i0.Value<String> hardwareId = const i0.Value.absent(),
                i0.Value<String> inverterId = const i0.Value.absent(),
                i0.Value<i2.GatewayStatus> status = const i0.Value.absent(),
                i0.Value<String> provisionedBy = const i0.Value.absent(),
                i0.Value<DateTime> lastSeenAt = const i0.Value.absent(),
                i0.Value<String> firmwareVersion = const i0.Value.absent(),
                i0.Value<DateTime> createdAt = const i0.Value.absent(),
                i0.Value<DateTime> retiredAt = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i1.GatewaysCompanion(
                id: id,
                hardwareId: hardwareId,
                inverterId: inverterId,
                status: status,
                provisionedBy: provisionedBy,
                lastSeenAt: lastSeenAt,
                firmwareVersion: firmwareVersion,
                createdAt: createdAt,
                retiredAt: retiredAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String hardwareId,
                required String inverterId,
                required i2.GatewayStatus status,
                required String provisionedBy,
                required DateTime lastSeenAt,
                required String firmwareVersion,
                required DateTime createdAt,
                required DateTime retiredAt,
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i1.GatewaysCompanion.insert(
                id: id,
                hardwareId: hardwareId,
                inverterId: inverterId,
                status: status,
                provisionedBy: provisionedBy,
                lastSeenAt: lastSeenAt,
                firmwareVersion: firmwareVersion,
                createdAt: createdAt,
                retiredAt: retiredAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), i0.BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GatewaysTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i1.$GatewaysTable,
      i1.Gateway,
      i1.$$GatewaysTableFilterComposer,
      i1.$$GatewaysTableOrderingComposer,
      i1.$$GatewaysTableAnnotationComposer,
      $$GatewaysTableCreateCompanionBuilder,
      $$GatewaysTableUpdateCompanionBuilder,
      (
        i1.Gateway,
        i0.BaseReferences<i0.GeneratedDatabase, i1.$GatewaysTable, i1.Gateway>,
      ),
      i1.Gateway,
      i0.PrefetchHooks Function()
    >;

class $GatewaysTable extends i2.Gateways
    with i0.TableInfo<$GatewaysTable, i1.Gateway> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GatewaysTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<String> id = i0.GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const i0.VerificationMeta _hardwareIdMeta = const i0.VerificationMeta(
    'hardwareId',
  );
  @override
  late final i0.GeneratedColumn<String> hardwareId = i0.GeneratedColumn<String>(
    'hardware_id',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  late final i0.GeneratedColumnWithTypeConverter<i2.GatewayStatus, String>
  status = i0.GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<i2.GatewayStatus>(i1.$GatewaysTable.$converterstatus);
  static const i0.VerificationMeta _provisionedByMeta =
      const i0.VerificationMeta('provisionedBy');
  @override
  late final i0.GeneratedColumn<String> provisionedBy =
      i0.GeneratedColumn<String>(
        'provisioned_by',
        aliasedName,
        false,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  late final i0.GeneratedColumnWithTypeConverter<DateTime, double> lastSeenAt =
      i0.GeneratedColumn<double>(
        'last_seen_at',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      ).withConverter<DateTime>(i1.$GatewaysTable.$converterlastSeenAt);
  static const i0.VerificationMeta _firmwareVersionMeta =
      const i0.VerificationMeta('firmwareVersion');
  @override
  late final i0.GeneratedColumn<String> firmwareVersion =
      i0.GeneratedColumn<String>(
        'firmware_version',
        aliasedName,
        false,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  late final i0.GeneratedColumnWithTypeConverter<DateTime, double> createdAt =
      i0.GeneratedColumn<double>(
        'created_at',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      ).withConverter<DateTime>(i1.$GatewaysTable.$convertercreatedAt);
  @override
  late final i0.GeneratedColumnWithTypeConverter<DateTime, double> retiredAt =
      i0.GeneratedColumn<double>(
        'retired_at',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      ).withConverter<DateTime>(i1.$GatewaysTable.$converterretiredAt);
  @override
  List<i0.GeneratedColumn> get $columns => [
    id,
    hardwareId,
    inverterId,
    status,
    provisionedBy,
    lastSeenAt,
    firmwareVersion,
    createdAt,
    retiredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gateways';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i1.Gateway> instance, {
    bool isInserting = false,
  }) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('hardware_id')) {
      context.handle(
        _hardwareIdMeta,
        hardwareId.isAcceptableOrUnknown(data['hardware_id']!, _hardwareIdMeta),
      );
    } else if (isInserting) {
      context.missing(_hardwareIdMeta);
    }
    if (data.containsKey('inverter_id')) {
      context.handle(
        _inverterIdMeta,
        inverterId.isAcceptableOrUnknown(data['inverter_id']!, _inverterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_inverterIdMeta);
    }
    if (data.containsKey('provisioned_by')) {
      context.handle(
        _provisionedByMeta,
        provisionedBy.isAcceptableOrUnknown(
          data['provisioned_by']!,
          _provisionedByMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_provisionedByMeta);
    }
    if (data.containsKey('firmware_version')) {
      context.handle(
        _firmwareVersionMeta,
        firmwareVersion.isAcceptableOrUnknown(
          data['firmware_version']!,
          _firmwareVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firmwareVersionMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => const {};
  @override
  i1.Gateway map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.Gateway(
      id: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      hardwareId: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}hardware_id'],
      )!,
      inverterId: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}inverter_id'],
      )!,
      status: i1.$GatewaysTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      provisionedBy: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}provisioned_by'],
      )!,
      lastSeenAt: i1.$GatewaysTable.$converterlastSeenAt.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.double,
          data['${effectivePrefix}last_seen_at'],
        )!,
      ),
      firmwareVersion: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}firmware_version'],
      )!,
      createdAt: i1.$GatewaysTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.double,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      retiredAt: i1.$GatewaysTable.$converterretiredAt.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.double,
          data['${effectivePrefix}retired_at'],
        )!,
      ),
    );
  }

  @override
  $GatewaysTable createAlias(String alias) {
    return $GatewaysTable(attachedDatabase, alias);
  }

  static i0.JsonTypeConverter2<i2.GatewayStatus, String, String>
  $converterstatus = const i2.GatewayStatusConverter();
  static i0.JsonTypeConverter2<DateTime, double, String> $converterlastSeenAt =
      const i3.DateTimeConverter();
  static i0.JsonTypeConverter2<DateTime, double, String> $convertercreatedAt =
      const i3.DateTimeConverter();
  static i0.JsonTypeConverter2<DateTime, double, String> $converterretiredAt =
      const i3.DateTimeConverter();
}

class Gateway extends i0.DataClass implements i0.Insertable<i1.Gateway> {
  final String id;
  final String hardwareId;
  final String inverterId;
  final i2.GatewayStatus status;
  final String provisionedBy;
  final DateTime lastSeenAt;
  final String firmwareVersion;
  final DateTime createdAt;
  final DateTime retiredAt;
  const Gateway({
    required this.id,
    required this.hardwareId,
    required this.inverterId,
    required this.status,
    required this.provisionedBy,
    required this.lastSeenAt,
    required this.firmwareVersion,
    required this.createdAt,
    required this.retiredAt,
  });
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['hardware_id'] = i0.Variable<String>(hardwareId);
    map['inverter_id'] = i0.Variable<String>(inverterId);
    {
      map['status'] = i0.Variable<String>(
        i1.$GatewaysTable.$converterstatus.toSql(status),
      );
    }
    map['provisioned_by'] = i0.Variable<String>(provisionedBy);
    {
      map['last_seen_at'] = i0.Variable<double>(
        i1.$GatewaysTable.$converterlastSeenAt.toSql(lastSeenAt),
      );
    }
    map['firmware_version'] = i0.Variable<String>(firmwareVersion);
    {
      map['created_at'] = i0.Variable<double>(
        i1.$GatewaysTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['retired_at'] = i0.Variable<double>(
        i1.$GatewaysTable.$converterretiredAt.toSql(retiredAt),
      );
    }
    return map;
  }

  i1.GatewaysCompanion toCompanion(bool nullToAbsent) {
    return i1.GatewaysCompanion(
      id: i0.Value(id),
      hardwareId: i0.Value(hardwareId),
      inverterId: i0.Value(inverterId),
      status: i0.Value(status),
      provisionedBy: i0.Value(provisionedBy),
      lastSeenAt: i0.Value(lastSeenAt),
      firmwareVersion: i0.Value(firmwareVersion),
      createdAt: i0.Value(createdAt),
      retiredAt: i0.Value(retiredAt),
    );
  }

  factory Gateway.fromJson(
    Map<String, dynamic> json, {
    i0.ValueSerializer? serializer,
  }) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return Gateway(
      id: serializer.fromJson<String>(json['id']),
      hardwareId: serializer.fromJson<String>(json['hardware_id']),
      inverterId: serializer.fromJson<String>(json['inverter_id']),
      status: i1.$GatewaysTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      provisionedBy: serializer.fromJson<String>(json['provisioned_by']),
      lastSeenAt: i1.$GatewaysTable.$converterlastSeenAt.fromJson(
        serializer.fromJson<String>(json['last_seen_at']),
      ),
      firmwareVersion: serializer.fromJson<String>(json['firmware_version']),
      createdAt: i1.$GatewaysTable.$convertercreatedAt.fromJson(
        serializer.fromJson<String>(json['created_at']),
      ),
      retiredAt: i1.$GatewaysTable.$converterretiredAt.fromJson(
        serializer.fromJson<String>(json['retired_at']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'hardware_id': serializer.toJson<String>(hardwareId),
      'inverter_id': serializer.toJson<String>(inverterId),
      'status': serializer.toJson<String>(
        i1.$GatewaysTable.$converterstatus.toJson(status),
      ),
      'provisioned_by': serializer.toJson<String>(provisionedBy),
      'last_seen_at': serializer.toJson<String>(
        i1.$GatewaysTable.$converterlastSeenAt.toJson(lastSeenAt),
      ),
      'firmware_version': serializer.toJson<String>(firmwareVersion),
      'created_at': serializer.toJson<String>(
        i1.$GatewaysTable.$convertercreatedAt.toJson(createdAt),
      ),
      'retired_at': serializer.toJson<String>(
        i1.$GatewaysTable.$converterretiredAt.toJson(retiredAt),
      ),
    };
  }

  i1.Gateway copyWith({
    String? id,
    String? hardwareId,
    String? inverterId,
    i2.GatewayStatus? status,
    String? provisionedBy,
    DateTime? lastSeenAt,
    String? firmwareVersion,
    DateTime? createdAt,
    DateTime? retiredAt,
  }) => i1.Gateway(
    id: id ?? this.id,
    hardwareId: hardwareId ?? this.hardwareId,
    inverterId: inverterId ?? this.inverterId,
    status: status ?? this.status,
    provisionedBy: provisionedBy ?? this.provisionedBy,
    lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    firmwareVersion: firmwareVersion ?? this.firmwareVersion,
    createdAt: createdAt ?? this.createdAt,
    retiredAt: retiredAt ?? this.retiredAt,
  );
  Gateway copyWithCompanion(i1.GatewaysCompanion data) {
    return Gateway(
      id: data.id.present ? data.id.value : this.id,
      hardwareId: data.hardwareId.present
          ? data.hardwareId.value
          : this.hardwareId,
      inverterId: data.inverterId.present
          ? data.inverterId.value
          : this.inverterId,
      status: data.status.present ? data.status.value : this.status,
      provisionedBy: data.provisionedBy.present
          ? data.provisionedBy.value
          : this.provisionedBy,
      lastSeenAt: data.lastSeenAt.present
          ? data.lastSeenAt.value
          : this.lastSeenAt,
      firmwareVersion: data.firmwareVersion.present
          ? data.firmwareVersion.value
          : this.firmwareVersion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retiredAt: data.retiredAt.present ? data.retiredAt.value : this.retiredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Gateway(')
          ..write('id: $id, ')
          ..write('hardwareId: $hardwareId, ')
          ..write('inverterId: $inverterId, ')
          ..write('status: $status, ')
          ..write('provisionedBy: $provisionedBy, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('firmwareVersion: $firmwareVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('retiredAt: $retiredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    hardwareId,
    inverterId,
    status,
    provisionedBy,
    lastSeenAt,
    firmwareVersion,
    createdAt,
    retiredAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.Gateway &&
          other.id == this.id &&
          other.hardwareId == this.hardwareId &&
          other.inverterId == this.inverterId &&
          other.status == this.status &&
          other.provisionedBy == this.provisionedBy &&
          other.lastSeenAt == this.lastSeenAt &&
          other.firmwareVersion == this.firmwareVersion &&
          other.createdAt == this.createdAt &&
          other.retiredAt == this.retiredAt);
}

class GatewaysCompanion extends i0.UpdateCompanion<i1.Gateway> {
  final i0.Value<String> id;
  final i0.Value<String> hardwareId;
  final i0.Value<String> inverterId;
  final i0.Value<i2.GatewayStatus> status;
  final i0.Value<String> provisionedBy;
  final i0.Value<DateTime> lastSeenAt;
  final i0.Value<String> firmwareVersion;
  final i0.Value<DateTime> createdAt;
  final i0.Value<DateTime> retiredAt;
  final i0.Value<int> rowid;
  const GatewaysCompanion({
    this.id = const i0.Value.absent(),
    this.hardwareId = const i0.Value.absent(),
    this.inverterId = const i0.Value.absent(),
    this.status = const i0.Value.absent(),
    this.provisionedBy = const i0.Value.absent(),
    this.lastSeenAt = const i0.Value.absent(),
    this.firmwareVersion = const i0.Value.absent(),
    this.createdAt = const i0.Value.absent(),
    this.retiredAt = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  GatewaysCompanion.insert({
    required String id,
    required String hardwareId,
    required String inverterId,
    required i2.GatewayStatus status,
    required String provisionedBy,
    required DateTime lastSeenAt,
    required String firmwareVersion,
    required DateTime createdAt,
    required DateTime retiredAt,
    this.rowid = const i0.Value.absent(),
  }) : id = i0.Value(id),
       hardwareId = i0.Value(hardwareId),
       inverterId = i0.Value(inverterId),
       status = i0.Value(status),
       provisionedBy = i0.Value(provisionedBy),
       lastSeenAt = i0.Value(lastSeenAt),
       firmwareVersion = i0.Value(firmwareVersion),
       createdAt = i0.Value(createdAt),
       retiredAt = i0.Value(retiredAt);
  static i0.Insertable<i1.Gateway> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? hardwareId,
    i0.Expression<String>? inverterId,
    i0.Expression<String>? status,
    i0.Expression<String>? provisionedBy,
    i0.Expression<double>? lastSeenAt,
    i0.Expression<String>? firmwareVersion,
    i0.Expression<double>? createdAt,
    i0.Expression<double>? retiredAt,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (hardwareId != null) 'hardware_id': hardwareId,
      if (inverterId != null) 'inverter_id': inverterId,
      if (status != null) 'status': status,
      if (provisionedBy != null) 'provisioned_by': provisionedBy,
      if (lastSeenAt != null) 'last_seen_at': lastSeenAt,
      if (firmwareVersion != null) 'firmware_version': firmwareVersion,
      if (createdAt != null) 'created_at': createdAt,
      if (retiredAt != null) 'retired_at': retiredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.GatewaysCompanion copyWith({
    i0.Value<String>? id,
    i0.Value<String>? hardwareId,
    i0.Value<String>? inverterId,
    i0.Value<i2.GatewayStatus>? status,
    i0.Value<String>? provisionedBy,
    i0.Value<DateTime>? lastSeenAt,
    i0.Value<String>? firmwareVersion,
    i0.Value<DateTime>? createdAt,
    i0.Value<DateTime>? retiredAt,
    i0.Value<int>? rowid,
  }) {
    return i1.GatewaysCompanion(
      id: id ?? this.id,
      hardwareId: hardwareId ?? this.hardwareId,
      inverterId: inverterId ?? this.inverterId,
      status: status ?? this.status,
      provisionedBy: provisionedBy ?? this.provisionedBy,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      createdAt: createdAt ?? this.createdAt,
      retiredAt: retiredAt ?? this.retiredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<String>(id.value);
    }
    if (hardwareId.present) {
      map['hardware_id'] = i0.Variable<String>(hardwareId.value);
    }
    if (inverterId.present) {
      map['inverter_id'] = i0.Variable<String>(inverterId.value);
    }
    if (status.present) {
      map['status'] = i0.Variable<String>(
        i1.$GatewaysTable.$converterstatus.toSql(status.value),
      );
    }
    if (provisionedBy.present) {
      map['provisioned_by'] = i0.Variable<String>(provisionedBy.value);
    }
    if (lastSeenAt.present) {
      map['last_seen_at'] = i0.Variable<double>(
        i1.$GatewaysTable.$converterlastSeenAt.toSql(lastSeenAt.value),
      );
    }
    if (firmwareVersion.present) {
      map['firmware_version'] = i0.Variable<String>(firmwareVersion.value);
    }
    if (createdAt.present) {
      map['created_at'] = i0.Variable<double>(
        i1.$GatewaysTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (retiredAt.present) {
      map['retired_at'] = i0.Variable<double>(
        i1.$GatewaysTable.$converterretiredAt.toSql(retiredAt.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GatewaysCompanion(')
          ..write('id: $id, ')
          ..write('hardwareId: $hardwareId, ')
          ..write('inverterId: $inverterId, ')
          ..write('status: $status, ')
          ..write('provisionedBy: $provisionedBy, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('firmwareVersion: $firmwareVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('retiredAt: $retiredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}
