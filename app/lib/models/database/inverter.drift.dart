// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:grobase/models/database/inverter.drift.dart' as i1;
import 'package:grobase/models/location.dart' as i2;
import 'package:grobase/models/database/inverter.dart' as i3;
import 'package:grobase/models/database/converters.dart' as i4;

typedef $$InvertersTableCreateCompanionBuilder =
    i1.InvertersCompanion Function({
      required String id,
      required String inverterSn,
      required String displayName,
      required DateTime createdAt,
      i0.Value<DateTime?> lastSeenAt,
      required i2.Location location,
      i0.Value<int> rowid,
    });
typedef $$InvertersTableUpdateCompanionBuilder =
    i1.InvertersCompanion Function({
      i0.Value<String> id,
      i0.Value<String> inverterSn,
      i0.Value<String> displayName,
      i0.Value<DateTime> createdAt,
      i0.Value<DateTime?> lastSeenAt,
      i0.Value<i2.Location> location,
      i0.Value<int> rowid,
    });

class $$InvertersTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$InvertersTable> {
  $$InvertersTableFilterComposer({
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

  i0.ColumnFilters<String> get inverterSn => $composableBuilder(
    column: $table.inverterSn,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<DateTime, DateTime, double> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => i0.ColumnWithTypeConverterFilters(column),
      );

  i0.ColumnWithTypeConverterFilters<DateTime?, DateTime, double>
  get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<i2.Location, i2.Location, String>
  get location => $composableBuilder(
    column: $table.location,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );
}

class $$InvertersTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$InvertersTable> {
  $$InvertersTableOrderingComposer({
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

  i0.ColumnOrderings<String> get inverterSn => $composableBuilder(
    column: $table.inverterSn,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => i0.ColumnOrderings(column),
  );
}

class $$InvertersTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$InvertersTable> {
  $$InvertersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  i0.GeneratedColumn<String> get inverterSn => $composableBuilder(
    column: $table.inverterSn,
    builder: (column) => column,
  );

  i0.GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  i0.GeneratedColumnWithTypeConverter<DateTime, double> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<DateTime?, double> get lastSeenAt =>
      $composableBuilder(
        column: $table.lastSeenAt,
        builder: (column) => column,
      );

  i0.GeneratedColumnWithTypeConverter<i2.Location, String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);
}

class $$InvertersTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i1.$InvertersTable,
          i1.Inverter,
          i1.$$InvertersTableFilterComposer,
          i1.$$InvertersTableOrderingComposer,
          i1.$$InvertersTableAnnotationComposer,
          $$InvertersTableCreateCompanionBuilder,
          $$InvertersTableUpdateCompanionBuilder,
          (
            i1.Inverter,
            i0.BaseReferences<
              i0.GeneratedDatabase,
              i1.$InvertersTable,
              i1.Inverter
            >,
          ),
          i1.Inverter,
          i0.PrefetchHooks Function()
        > {
  $$InvertersTableTableManager(
    i0.GeneratedDatabase db,
    i1.$InvertersTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i1.$$InvertersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              i1.$$InvertersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              i1.$$InvertersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                i0.Value<String> id = const i0.Value.absent(),
                i0.Value<String> inverterSn = const i0.Value.absent(),
                i0.Value<String> displayName = const i0.Value.absent(),
                i0.Value<DateTime> createdAt = const i0.Value.absent(),
                i0.Value<DateTime?> lastSeenAt = const i0.Value.absent(),
                i0.Value<i2.Location> location = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i1.InvertersCompanion(
                id: id,
                inverterSn: inverterSn,
                displayName: displayName,
                createdAt: createdAt,
                lastSeenAt: lastSeenAt,
                location: location,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String inverterSn,
                required String displayName,
                required DateTime createdAt,
                i0.Value<DateTime?> lastSeenAt = const i0.Value.absent(),
                required i2.Location location,
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i1.InvertersCompanion.insert(
                id: id,
                inverterSn: inverterSn,
                displayName: displayName,
                createdAt: createdAt,
                lastSeenAt: lastSeenAt,
                location: location,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), i0.BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InvertersTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i1.$InvertersTable,
      i1.Inverter,
      i1.$$InvertersTableFilterComposer,
      i1.$$InvertersTableOrderingComposer,
      i1.$$InvertersTableAnnotationComposer,
      $$InvertersTableCreateCompanionBuilder,
      $$InvertersTableUpdateCompanionBuilder,
      (
        i1.Inverter,
        i0.BaseReferences<
          i0.GeneratedDatabase,
          i1.$InvertersTable,
          i1.Inverter
        >,
      ),
      i1.Inverter,
      i0.PrefetchHooks Function()
    >;

class $InvertersTable extends i3.Inverters
    with i0.TableInfo<$InvertersTable, i1.Inverter> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvertersTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<String> id = i0.GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const i0.VerificationMeta _inverterSnMeta = const i0.VerificationMeta(
    'inverterSn',
  );
  @override
  late final i0.GeneratedColumn<String> inverterSn = i0.GeneratedColumn<String>(
    'inverter_sn',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const i0.VerificationMeta _displayNameMeta = const i0.VerificationMeta(
    'displayName',
  );
  @override
  late final i0.GeneratedColumn<String> displayName =
      i0.GeneratedColumn<String>(
        'display_name',
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
      ).withConverter<DateTime>(i1.$InvertersTable.$convertercreatedAt);
  @override
  late final i0.GeneratedColumnWithTypeConverter<DateTime?, double> lastSeenAt =
      i0.GeneratedColumn<double>(
        'last_seen_at',
        aliasedName,
        true,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>(i1.$InvertersTable.$converterlastSeenAt);
  @override
  late final i0.GeneratedColumnWithTypeConverter<i2.Location, String> location =
      i0.GeneratedColumn<String>(
        'location',
        aliasedName,
        false,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<i2.Location>(i1.$InvertersTable.$converterlocation);
  @override
  List<i0.GeneratedColumn> get $columns => [
    id,
    inverterSn,
    displayName,
    createdAt,
    lastSeenAt,
    location,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inverters';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i1.Inverter> instance, {
    bool isInserting = false,
  }) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('inverter_sn')) {
      context.handle(
        _inverterSnMeta,
        inverterSn.isAcceptableOrUnknown(data['inverter_sn']!, _inverterSnMeta),
      );
    } else if (isInserting) {
      context.missing(_inverterSnMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => const {};
  @override
  i1.Inverter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.Inverter(
      id: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      inverterSn: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}inverter_sn'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      createdAt: i1.$InvertersTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.double,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      lastSeenAt: i1.$InvertersTable.$converterlastSeenAt.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.double,
          data['${effectivePrefix}last_seen_at'],
        ),
      ),
      location: i1.$InvertersTable.$converterlocation.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}location'],
        )!,
      ),
    );
  }

  @override
  $InvertersTable createAlias(String alias) {
    return $InvertersTable(attachedDatabase, alias);
  }

  static i0.JsonTypeConverter2<DateTime, double, String> $convertercreatedAt =
      const i4.DateTimeConverter();
  static i0.JsonTypeConverter2<DateTime?, double?, String?>
  $converterlastSeenAt = const i4.NullableDateTimeConverter();
  static i0.JsonTypeConverter2<i2.Location, String, Map<String, dynamic>>
  $converterlocation = const i3.LocationConverter();
}

class Inverter extends i0.DataClass implements i0.Insertable<i1.Inverter> {
  final String id;
  final String inverterSn;
  final String displayName;
  final DateTime createdAt;
  final DateTime? lastSeenAt;
  final i2.Location location;
  const Inverter({
    required this.id,
    required this.inverterSn,
    required this.displayName,
    required this.createdAt,
    this.lastSeenAt,
    required this.location,
  });
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['inverter_sn'] = i0.Variable<String>(inverterSn);
    map['display_name'] = i0.Variable<String>(displayName);
    {
      map['created_at'] = i0.Variable<double>(
        i1.$InvertersTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    if (!nullToAbsent || lastSeenAt != null) {
      map['last_seen_at'] = i0.Variable<double>(
        i1.$InvertersTable.$converterlastSeenAt.toSql(lastSeenAt),
      );
    }
    {
      map['location'] = i0.Variable<String>(
        i1.$InvertersTable.$converterlocation.toSql(location),
      );
    }
    return map;
  }

  i1.InvertersCompanion toCompanion(bool nullToAbsent) {
    return i1.InvertersCompanion(
      id: i0.Value(id),
      inverterSn: i0.Value(inverterSn),
      displayName: i0.Value(displayName),
      createdAt: i0.Value(createdAt),
      lastSeenAt: lastSeenAt == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(lastSeenAt),
      location: i0.Value(location),
    );
  }

  factory Inverter.fromJson(
    Map<String, dynamic> json, {
    i0.ValueSerializer? serializer,
  }) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return Inverter(
      id: serializer.fromJson<String>(json['id']),
      inverterSn: serializer.fromJson<String>(json['inverter_sn']),
      displayName: serializer.fromJson<String>(json['display_name']),
      createdAt: i1.$InvertersTable.$convertercreatedAt.fromJson(
        serializer.fromJson<String>(json['created_at']),
      ),
      lastSeenAt: i1.$InvertersTable.$converterlastSeenAt.fromJson(
        serializer.fromJson<String?>(json['last_seen_at']),
      ),
      location: i1.$InvertersTable.$converterlocation.fromJson(
        serializer.fromJson<Map<String, dynamic>>(json['location']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'inverter_sn': serializer.toJson<String>(inverterSn),
      'display_name': serializer.toJson<String>(displayName),
      'created_at': serializer.toJson<String>(
        i1.$InvertersTable.$convertercreatedAt.toJson(createdAt),
      ),
      'last_seen_at': serializer.toJson<String?>(
        i1.$InvertersTable.$converterlastSeenAt.toJson(lastSeenAt),
      ),
      'location': serializer.toJson<Map<String, dynamic>>(
        i1.$InvertersTable.$converterlocation.toJson(location),
      ),
    };
  }

  i1.Inverter copyWith({
    String? id,
    String? inverterSn,
    String? displayName,
    DateTime? createdAt,
    i0.Value<DateTime?> lastSeenAt = const i0.Value.absent(),
    i2.Location? location,
  }) => i1.Inverter(
    id: id ?? this.id,
    inverterSn: inverterSn ?? this.inverterSn,
    displayName: displayName ?? this.displayName,
    createdAt: createdAt ?? this.createdAt,
    lastSeenAt: lastSeenAt.present ? lastSeenAt.value : this.lastSeenAt,
    location: location ?? this.location,
  );
  Inverter copyWithCompanion(i1.InvertersCompanion data) {
    return Inverter(
      id: data.id.present ? data.id.value : this.id,
      inverterSn: data.inverterSn.present
          ? data.inverterSn.value
          : this.inverterSn,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastSeenAt: data.lastSeenAt.present
          ? data.lastSeenAt.value
          : this.lastSeenAt,
      location: data.location.present ? data.location.value : this.location,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Inverter(')
          ..write('id: $id, ')
          ..write('inverterSn: $inverterSn, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('location: $location')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, inverterSn, displayName, createdAt, lastSeenAt, location);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.Inverter &&
          other.id == this.id &&
          other.inverterSn == this.inverterSn &&
          other.displayName == this.displayName &&
          other.createdAt == this.createdAt &&
          other.lastSeenAt == this.lastSeenAt &&
          other.location == this.location);
}

class InvertersCompanion extends i0.UpdateCompanion<i1.Inverter> {
  final i0.Value<String> id;
  final i0.Value<String> inverterSn;
  final i0.Value<String> displayName;
  final i0.Value<DateTime> createdAt;
  final i0.Value<DateTime?> lastSeenAt;
  final i0.Value<i2.Location> location;
  final i0.Value<int> rowid;
  const InvertersCompanion({
    this.id = const i0.Value.absent(),
    this.inverterSn = const i0.Value.absent(),
    this.displayName = const i0.Value.absent(),
    this.createdAt = const i0.Value.absent(),
    this.lastSeenAt = const i0.Value.absent(),
    this.location = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  InvertersCompanion.insert({
    required String id,
    required String inverterSn,
    required String displayName,
    required DateTime createdAt,
    this.lastSeenAt = const i0.Value.absent(),
    required i2.Location location,
    this.rowid = const i0.Value.absent(),
  }) : id = i0.Value(id),
       inverterSn = i0.Value(inverterSn),
       displayName = i0.Value(displayName),
       createdAt = i0.Value(createdAt),
       location = i0.Value(location);
  static i0.Insertable<i1.Inverter> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? inverterSn,
    i0.Expression<String>? displayName,
    i0.Expression<double>? createdAt,
    i0.Expression<double>? lastSeenAt,
    i0.Expression<String>? location,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (inverterSn != null) 'inverter_sn': inverterSn,
      if (displayName != null) 'display_name': displayName,
      if (createdAt != null) 'created_at': createdAt,
      if (lastSeenAt != null) 'last_seen_at': lastSeenAt,
      if (location != null) 'location': location,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.InvertersCompanion copyWith({
    i0.Value<String>? id,
    i0.Value<String>? inverterSn,
    i0.Value<String>? displayName,
    i0.Value<DateTime>? createdAt,
    i0.Value<DateTime?>? lastSeenAt,
    i0.Value<i2.Location>? location,
    i0.Value<int>? rowid,
  }) {
    return i1.InvertersCompanion(
      id: id ?? this.id,
      inverterSn: inverterSn ?? this.inverterSn,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      location: location ?? this.location,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<String>(id.value);
    }
    if (inverterSn.present) {
      map['inverter_sn'] = i0.Variable<String>(inverterSn.value);
    }
    if (displayName.present) {
      map['display_name'] = i0.Variable<String>(displayName.value);
    }
    if (createdAt.present) {
      map['created_at'] = i0.Variable<double>(
        i1.$InvertersTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (lastSeenAt.present) {
      map['last_seen_at'] = i0.Variable<double>(
        i1.$InvertersTable.$converterlastSeenAt.toSql(lastSeenAt.value),
      );
    }
    if (location.present) {
      map['location'] = i0.Variable<String>(
        i1.$InvertersTable.$converterlocation.toSql(location.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvertersCompanion(')
          ..write('id: $id, ')
          ..write('inverterSn: $inverterSn, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('location: $location, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}
