// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:grobase/models/database/gateway_event.drift.dart' as i1;
import 'package:grobase/models/database/gateway_event.dart' as i2;
import 'package:grobase/models/database/converters.dart' as i3;

typedef $$GatewayEventsTableCreateCompanionBuilder =
    i1.GatewayEventsCompanion Function({
      required int id,
      required String gatewayId,
      required String inverterId,
      required i2.GatewayEventLevel level,
      required String code,
      required String message,
      required Map<String, dynamic> metadata,
      required DateTime recordedAt,
      required DateTime ingestedAt,
      i0.Value<int> rowid,
    });
typedef $$GatewayEventsTableUpdateCompanionBuilder =
    i1.GatewayEventsCompanion Function({
      i0.Value<int> id,
      i0.Value<String> gatewayId,
      i0.Value<String> inverterId,
      i0.Value<i2.GatewayEventLevel> level,
      i0.Value<String> code,
      i0.Value<String> message,
      i0.Value<Map<String, dynamic>> metadata,
      i0.Value<DateTime> recordedAt,
      i0.Value<DateTime> ingestedAt,
      i0.Value<int> rowid,
    });

class $$GatewayEventsTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$GatewayEventsTable> {
  $$GatewayEventsTableFilterComposer({
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

  i0.ColumnFilters<String> get gatewayId => $composableBuilder(
    column: $table.gatewayId,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get inverterId => $composableBuilder(
    column: $table.inverterId,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<
    i2.GatewayEventLevel,
    i2.GatewayEventLevel,
    String
  >
  get level => $composableBuilder(
    column: $table.level,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<
    Map<String, dynamic>,
    Map<String, dynamic>,
    String
  >
  get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
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
}

class $$GatewayEventsTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$GatewayEventsTable> {
  $$GatewayEventsTableOrderingComposer({
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

  i0.ColumnOrderings<String> get gatewayId => $composableBuilder(
    column: $table.gatewayId,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get inverterId => $composableBuilder(
    column: $table.inverterId,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
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
}

class $$GatewayEventsTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$GatewayEventsTable> {
  $$GatewayEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  i0.GeneratedColumn<String> get gatewayId =>
      $composableBuilder(column: $table.gatewayId, builder: (column) => column);

  i0.GeneratedColumn<String> get inverterId => $composableBuilder(
    column: $table.inverterId,
    builder: (column) => column,
  );

  i0.GeneratedColumnWithTypeConverter<i2.GatewayEventLevel, String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  i0.GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  i0.GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

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
}

class $$GatewayEventsTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i1.$GatewayEventsTable,
          i1.GatewayEvent,
          i1.$$GatewayEventsTableFilterComposer,
          i1.$$GatewayEventsTableOrderingComposer,
          i1.$$GatewayEventsTableAnnotationComposer,
          $$GatewayEventsTableCreateCompanionBuilder,
          $$GatewayEventsTableUpdateCompanionBuilder,
          (
            i1.GatewayEvent,
            i0.BaseReferences<
              i0.GeneratedDatabase,
              i1.$GatewayEventsTable,
              i1.GatewayEvent
            >,
          ),
          i1.GatewayEvent,
          i0.PrefetchHooks Function()
        > {
  $$GatewayEventsTableTableManager(
    i0.GeneratedDatabase db,
    i1.$GatewayEventsTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i1.$$GatewayEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              i1.$$GatewayEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              i1.$$GatewayEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                i0.Value<int> id = const i0.Value.absent(),
                i0.Value<String> gatewayId = const i0.Value.absent(),
                i0.Value<String> inverterId = const i0.Value.absent(),
                i0.Value<i2.GatewayEventLevel> level = const i0.Value.absent(),
                i0.Value<String> code = const i0.Value.absent(),
                i0.Value<String> message = const i0.Value.absent(),
                i0.Value<Map<String, dynamic>> metadata =
                    const i0.Value.absent(),
                i0.Value<DateTime> recordedAt = const i0.Value.absent(),
                i0.Value<DateTime> ingestedAt = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i1.GatewayEventsCompanion(
                id: id,
                gatewayId: gatewayId,
                inverterId: inverterId,
                level: level,
                code: code,
                message: message,
                metadata: metadata,
                recordedAt: recordedAt,
                ingestedAt: ingestedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int id,
                required String gatewayId,
                required String inverterId,
                required i2.GatewayEventLevel level,
                required String code,
                required String message,
                required Map<String, dynamic> metadata,
                required DateTime recordedAt,
                required DateTime ingestedAt,
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i1.GatewayEventsCompanion.insert(
                id: id,
                gatewayId: gatewayId,
                inverterId: inverterId,
                level: level,
                code: code,
                message: message,
                metadata: metadata,
                recordedAt: recordedAt,
                ingestedAt: ingestedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), i0.BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GatewayEventsTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i1.$GatewayEventsTable,
      i1.GatewayEvent,
      i1.$$GatewayEventsTableFilterComposer,
      i1.$$GatewayEventsTableOrderingComposer,
      i1.$$GatewayEventsTableAnnotationComposer,
      $$GatewayEventsTableCreateCompanionBuilder,
      $$GatewayEventsTableUpdateCompanionBuilder,
      (
        i1.GatewayEvent,
        i0.BaseReferences<
          i0.GeneratedDatabase,
          i1.$GatewayEventsTable,
          i1.GatewayEvent
        >,
      ),
      i1.GatewayEvent,
      i0.PrefetchHooks Function()
    >;

class $GatewayEventsTable extends i2.GatewayEvents
    with i0.TableInfo<$GatewayEventsTable, i1.GatewayEvent> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GatewayEventsTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<int> id = i0.GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: i0.DriftSqlType.int,
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
  late final i0.GeneratedColumnWithTypeConverter<i2.GatewayEventLevel, String>
  level = i0.GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<i2.GatewayEventLevel>(i1.$GatewayEventsTable.$converterlevel);
  static const i0.VerificationMeta _codeMeta = const i0.VerificationMeta(
    'code',
  );
  @override
  late final i0.GeneratedColumn<String> code = i0.GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const i0.VerificationMeta _messageMeta = const i0.VerificationMeta(
    'message',
  );
  @override
  late final i0.GeneratedColumn<String> message = i0.GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final i0.GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  metadata =
      i0.GeneratedColumn<String>(
        'metadata',
        aliasedName,
        false,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Map<String, dynamic>>(
        i1.$GatewayEventsTable.$convertermetadata,
      );
  @override
  late final i0.GeneratedColumnWithTypeConverter<DateTime, double> recordedAt =
      i0.GeneratedColumn<double>(
        'recorded_at',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      ).withConverter<DateTime>(i1.$GatewayEventsTable.$converterrecordedAt);
  @override
  late final i0.GeneratedColumnWithTypeConverter<DateTime, double> ingestedAt =
      i0.GeneratedColumn<double>(
        'ingested_at',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      ).withConverter<DateTime>(i1.$GatewayEventsTable.$converteringestedAt);
  @override
  List<i0.GeneratedColumn> get $columns => [
    id,
    gatewayId,
    inverterId,
    level,
    code,
    message,
    metadata,
    recordedAt,
    ingestedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gateway_events';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i1.GatewayEvent> instance, {
    bool isInserting = false,
  }) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('gateway_id')) {
      context.handle(
        _gatewayIdMeta,
        gatewayId.isAcceptableOrUnknown(data['gateway_id']!, _gatewayIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gatewayIdMeta);
    }
    if (data.containsKey('inverter_id')) {
      context.handle(
        _inverterIdMeta,
        inverterId.isAcceptableOrUnknown(data['inverter_id']!, _inverterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_inverterIdMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => const {};
  @override
  i1.GatewayEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.GatewayEvent(
      id: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gatewayId: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}gateway_id'],
      )!,
      inverterId: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}inverter_id'],
      )!,
      level: i1.$GatewayEventsTable.$converterlevel.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}level'],
        )!,
      ),
      code: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      message: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      metadata: i1.$GatewayEventsTable.$convertermetadata.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}metadata'],
        )!,
      ),
      recordedAt: i1.$GatewayEventsTable.$converterrecordedAt.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.double,
          data['${effectivePrefix}recorded_at'],
        )!,
      ),
      ingestedAt: i1.$GatewayEventsTable.$converteringestedAt.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.double,
          data['${effectivePrefix}ingested_at'],
        )!,
      ),
    );
  }

  @override
  $GatewayEventsTable createAlias(String alias) {
    return $GatewayEventsTable(attachedDatabase, alias);
  }

  static i0.JsonTypeConverter2<i2.GatewayEventLevel, String, String>
  $converterlevel = const i2.GatewayEventLevelConverter();
  static i0.JsonTypeConverter2<
    Map<String, dynamic>,
    String,
    Map<String, dynamic>
  >
  $convertermetadata = const i3.JsonConverter();
  static i0.JsonTypeConverter2<DateTime, double, String> $converterrecordedAt =
      const i3.DateTimeConverter();
  static i0.JsonTypeConverter2<DateTime, double, String> $converteringestedAt =
      const i3.DateTimeConverter();
}

class GatewayEvent extends i0.DataClass
    implements i0.Insertable<i1.GatewayEvent> {
  final int id;
  final String gatewayId;
  final String inverterId;
  final i2.GatewayEventLevel level;
  final String code;
  final String message;
  final Map<String, dynamic> metadata;
  final DateTime recordedAt;
  final DateTime ingestedAt;
  const GatewayEvent({
    required this.id,
    required this.gatewayId,
    required this.inverterId,
    required this.level,
    required this.code,
    required this.message,
    required this.metadata,
    required this.recordedAt,
    required this.ingestedAt,
  });
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<int>(id);
    map['gateway_id'] = i0.Variable<String>(gatewayId);
    map['inverter_id'] = i0.Variable<String>(inverterId);
    {
      map['level'] = i0.Variable<String>(
        i1.$GatewayEventsTable.$converterlevel.toSql(level),
      );
    }
    map['code'] = i0.Variable<String>(code);
    map['message'] = i0.Variable<String>(message);
    {
      map['metadata'] = i0.Variable<String>(
        i1.$GatewayEventsTable.$convertermetadata.toSql(metadata),
      );
    }
    {
      map['recorded_at'] = i0.Variable<double>(
        i1.$GatewayEventsTable.$converterrecordedAt.toSql(recordedAt),
      );
    }
    {
      map['ingested_at'] = i0.Variable<double>(
        i1.$GatewayEventsTable.$converteringestedAt.toSql(ingestedAt),
      );
    }
    return map;
  }

  i1.GatewayEventsCompanion toCompanion(bool nullToAbsent) {
    return i1.GatewayEventsCompanion(
      id: i0.Value(id),
      gatewayId: i0.Value(gatewayId),
      inverterId: i0.Value(inverterId),
      level: i0.Value(level),
      code: i0.Value(code),
      message: i0.Value(message),
      metadata: i0.Value(metadata),
      recordedAt: i0.Value(recordedAt),
      ingestedAt: i0.Value(ingestedAt),
    );
  }

  factory GatewayEvent.fromJson(
    Map<String, dynamic> json, {
    i0.ValueSerializer? serializer,
  }) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return GatewayEvent(
      id: serializer.fromJson<int>(json['id']),
      gatewayId: serializer.fromJson<String>(json['gateway_id']),
      inverterId: serializer.fromJson<String>(json['inverter_id']),
      level: i1.$GatewayEventsTable.$converterlevel.fromJson(
        serializer.fromJson<String>(json['level']),
      ),
      code: serializer.fromJson<String>(json['code']),
      message: serializer.fromJson<String>(json['message']),
      metadata: i1.$GatewayEventsTable.$convertermetadata.fromJson(
        serializer.fromJson<Map<String, dynamic>>(json['metadata']),
      ),
      recordedAt: i1.$GatewayEventsTable.$converterrecordedAt.fromJson(
        serializer.fromJson<String>(json['recorded_at']),
      ),
      ingestedAt: i1.$GatewayEventsTable.$converteringestedAt.fromJson(
        serializer.fromJson<String>(json['ingested_at']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gateway_id': serializer.toJson<String>(gatewayId),
      'inverter_id': serializer.toJson<String>(inverterId),
      'level': serializer.toJson<String>(
        i1.$GatewayEventsTable.$converterlevel.toJson(level),
      ),
      'code': serializer.toJson<String>(code),
      'message': serializer.toJson<String>(message),
      'metadata': serializer.toJson<Map<String, dynamic>>(
        i1.$GatewayEventsTable.$convertermetadata.toJson(metadata),
      ),
      'recorded_at': serializer.toJson<String>(
        i1.$GatewayEventsTable.$converterrecordedAt.toJson(recordedAt),
      ),
      'ingested_at': serializer.toJson<String>(
        i1.$GatewayEventsTable.$converteringestedAt.toJson(ingestedAt),
      ),
    };
  }

  i1.GatewayEvent copyWith({
    int? id,
    String? gatewayId,
    String? inverterId,
    i2.GatewayEventLevel? level,
    String? code,
    String? message,
    Map<String, dynamic>? metadata,
    DateTime? recordedAt,
    DateTime? ingestedAt,
  }) => i1.GatewayEvent(
    id: id ?? this.id,
    gatewayId: gatewayId ?? this.gatewayId,
    inverterId: inverterId ?? this.inverterId,
    level: level ?? this.level,
    code: code ?? this.code,
    message: message ?? this.message,
    metadata: metadata ?? this.metadata,
    recordedAt: recordedAt ?? this.recordedAt,
    ingestedAt: ingestedAt ?? this.ingestedAt,
  );
  GatewayEvent copyWithCompanion(i1.GatewayEventsCompanion data) {
    return GatewayEvent(
      id: data.id.present ? data.id.value : this.id,
      gatewayId: data.gatewayId.present ? data.gatewayId.value : this.gatewayId,
      inverterId: data.inverterId.present
          ? data.inverterId.value
          : this.inverterId,
      level: data.level.present ? data.level.value : this.level,
      code: data.code.present ? data.code.value : this.code,
      message: data.message.present ? data.message.value : this.message,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      ingestedAt: data.ingestedAt.present
          ? data.ingestedAt.value
          : this.ingestedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GatewayEvent(')
          ..write('id: $id, ')
          ..write('gatewayId: $gatewayId, ')
          ..write('inverterId: $inverterId, ')
          ..write('level: $level, ')
          ..write('code: $code, ')
          ..write('message: $message, ')
          ..write('metadata: $metadata, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('ingestedAt: $ingestedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gatewayId,
    inverterId,
    level,
    code,
    message,
    metadata,
    recordedAt,
    ingestedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.GatewayEvent &&
          other.id == this.id &&
          other.gatewayId == this.gatewayId &&
          other.inverterId == this.inverterId &&
          other.level == this.level &&
          other.code == this.code &&
          other.message == this.message &&
          other.metadata == this.metadata &&
          other.recordedAt == this.recordedAt &&
          other.ingestedAt == this.ingestedAt);
}

class GatewayEventsCompanion extends i0.UpdateCompanion<i1.GatewayEvent> {
  final i0.Value<int> id;
  final i0.Value<String> gatewayId;
  final i0.Value<String> inverterId;
  final i0.Value<i2.GatewayEventLevel> level;
  final i0.Value<String> code;
  final i0.Value<String> message;
  final i0.Value<Map<String, dynamic>> metadata;
  final i0.Value<DateTime> recordedAt;
  final i0.Value<DateTime> ingestedAt;
  final i0.Value<int> rowid;
  const GatewayEventsCompanion({
    this.id = const i0.Value.absent(),
    this.gatewayId = const i0.Value.absent(),
    this.inverterId = const i0.Value.absent(),
    this.level = const i0.Value.absent(),
    this.code = const i0.Value.absent(),
    this.message = const i0.Value.absent(),
    this.metadata = const i0.Value.absent(),
    this.recordedAt = const i0.Value.absent(),
    this.ingestedAt = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  GatewayEventsCompanion.insert({
    required int id,
    required String gatewayId,
    required String inverterId,
    required i2.GatewayEventLevel level,
    required String code,
    required String message,
    required Map<String, dynamic> metadata,
    required DateTime recordedAt,
    required DateTime ingestedAt,
    this.rowid = const i0.Value.absent(),
  }) : id = i0.Value(id),
       gatewayId = i0.Value(gatewayId),
       inverterId = i0.Value(inverterId),
       level = i0.Value(level),
       code = i0.Value(code),
       message = i0.Value(message),
       metadata = i0.Value(metadata),
       recordedAt = i0.Value(recordedAt),
       ingestedAt = i0.Value(ingestedAt);
  static i0.Insertable<i1.GatewayEvent> custom({
    i0.Expression<int>? id,
    i0.Expression<String>? gatewayId,
    i0.Expression<String>? inverterId,
    i0.Expression<String>? level,
    i0.Expression<String>? code,
    i0.Expression<String>? message,
    i0.Expression<String>? metadata,
    i0.Expression<double>? recordedAt,
    i0.Expression<double>? ingestedAt,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (gatewayId != null) 'gateway_id': gatewayId,
      if (inverterId != null) 'inverter_id': inverterId,
      if (level != null) 'level': level,
      if (code != null) 'code': code,
      if (message != null) 'message': message,
      if (metadata != null) 'metadata': metadata,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (ingestedAt != null) 'ingested_at': ingestedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.GatewayEventsCompanion copyWith({
    i0.Value<int>? id,
    i0.Value<String>? gatewayId,
    i0.Value<String>? inverterId,
    i0.Value<i2.GatewayEventLevel>? level,
    i0.Value<String>? code,
    i0.Value<String>? message,
    i0.Value<Map<String, dynamic>>? metadata,
    i0.Value<DateTime>? recordedAt,
    i0.Value<DateTime>? ingestedAt,
    i0.Value<int>? rowid,
  }) {
    return i1.GatewayEventsCompanion(
      id: id ?? this.id,
      gatewayId: gatewayId ?? this.gatewayId,
      inverterId: inverterId ?? this.inverterId,
      level: level ?? this.level,
      code: code ?? this.code,
      message: message ?? this.message,
      metadata: metadata ?? this.metadata,
      recordedAt: recordedAt ?? this.recordedAt,
      ingestedAt: ingestedAt ?? this.ingestedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<int>(id.value);
    }
    if (gatewayId.present) {
      map['gateway_id'] = i0.Variable<String>(gatewayId.value);
    }
    if (inverterId.present) {
      map['inverter_id'] = i0.Variable<String>(inverterId.value);
    }
    if (level.present) {
      map['level'] = i0.Variable<String>(
        i1.$GatewayEventsTable.$converterlevel.toSql(level.value),
      );
    }
    if (code.present) {
      map['code'] = i0.Variable<String>(code.value);
    }
    if (message.present) {
      map['message'] = i0.Variable<String>(message.value);
    }
    if (metadata.present) {
      map['metadata'] = i0.Variable<String>(
        i1.$GatewayEventsTable.$convertermetadata.toSql(metadata.value),
      );
    }
    if (recordedAt.present) {
      map['recorded_at'] = i0.Variable<double>(
        i1.$GatewayEventsTable.$converterrecordedAt.toSql(recordedAt.value),
      );
    }
    if (ingestedAt.present) {
      map['ingested_at'] = i0.Variable<double>(
        i1.$GatewayEventsTable.$converteringestedAt.toSql(ingestedAt.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GatewayEventsCompanion(')
          ..write('id: $id, ')
          ..write('gatewayId: $gatewayId, ')
          ..write('inverterId: $inverterId, ')
          ..write('level: $level, ')
          ..write('code: $code, ')
          ..write('message: $message, ')
          ..write('metadata: $metadata, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('ingestedAt: $ingestedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}
