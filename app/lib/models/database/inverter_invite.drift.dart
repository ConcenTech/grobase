// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:grobase/models/database/inverter_invite.drift.dart' as i1;
import 'package:grobase/models/database/inverter_invite.dart' as i2;
import 'package:grobase/models/database/converters.dart' as i3;

typedef $$InverterInvitesTableCreateCompanionBuilder =
    i1.InverterInvitesCompanion Function({
      required String id,
      required String token,
      required DateTime createdAt,
      required DateTime expiresAt,
      i0.Value<DateTime?> acceptedAt,
      i0.Value<int> rowid,
    });
typedef $$InverterInvitesTableUpdateCompanionBuilder =
    i1.InverterInvitesCompanion Function({
      i0.Value<String> id,
      i0.Value<String> token,
      i0.Value<DateTime> createdAt,
      i0.Value<DateTime> expiresAt,
      i0.Value<DateTime?> acceptedAt,
      i0.Value<int> rowid,
    });

class $$InverterInvitesTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$InverterInvitesTable> {
  $$InverterInvitesTableFilterComposer({
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

  i0.ColumnFilters<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<DateTime, DateTime, double> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => i0.ColumnWithTypeConverterFilters(column),
      );

  i0.ColumnWithTypeConverterFilters<DateTime, DateTime, double> get expiresAt =>
      $composableBuilder(
        column: $table.expiresAt,
        builder: (column) => i0.ColumnWithTypeConverterFilters(column),
      );

  i0.ColumnWithTypeConverterFilters<DateTime?, DateTime, double>
  get acceptedAt => $composableBuilder(
    column: $table.acceptedAt,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );
}

class $$InverterInvitesTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$InverterInvitesTable> {
  $$InverterInvitesTableOrderingComposer({
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

  i0.ColumnOrderings<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get acceptedAt => $composableBuilder(
    column: $table.acceptedAt,
    builder: (column) => i0.ColumnOrderings(column),
  );
}

class $$InverterInvitesTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$InverterInvitesTable> {
  $$InverterInvitesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  i0.GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<DateTime, double> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<DateTime, double> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<DateTime?, double> get acceptedAt =>
      $composableBuilder(
        column: $table.acceptedAt,
        builder: (column) => column,
      );
}

class $$InverterInvitesTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i1.$InverterInvitesTable,
          i1.InverterInvite,
          i1.$$InverterInvitesTableFilterComposer,
          i1.$$InverterInvitesTableOrderingComposer,
          i1.$$InverterInvitesTableAnnotationComposer,
          $$InverterInvitesTableCreateCompanionBuilder,
          $$InverterInvitesTableUpdateCompanionBuilder,
          (
            i1.InverterInvite,
            i0.BaseReferences<
              i0.GeneratedDatabase,
              i1.$InverterInvitesTable,
              i1.InverterInvite
            >,
          ),
          i1.InverterInvite,
          i0.PrefetchHooks Function()
        > {
  $$InverterInvitesTableTableManager(
    i0.GeneratedDatabase db,
    i1.$InverterInvitesTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i1.$$InverterInvitesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              i1.$$InverterInvitesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => i1
              .$$InverterInvitesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                i0.Value<String> id = const i0.Value.absent(),
                i0.Value<String> token = const i0.Value.absent(),
                i0.Value<DateTime> createdAt = const i0.Value.absent(),
                i0.Value<DateTime> expiresAt = const i0.Value.absent(),
                i0.Value<DateTime?> acceptedAt = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i1.InverterInvitesCompanion(
                id: id,
                token: token,
                createdAt: createdAt,
                expiresAt: expiresAt,
                acceptedAt: acceptedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String token,
                required DateTime createdAt,
                required DateTime expiresAt,
                i0.Value<DateTime?> acceptedAt = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i1.InverterInvitesCompanion.insert(
                id: id,
                token: token,
                createdAt: createdAt,
                expiresAt: expiresAt,
                acceptedAt: acceptedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), i0.BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InverterInvitesTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i1.$InverterInvitesTable,
      i1.InverterInvite,
      i1.$$InverterInvitesTableFilterComposer,
      i1.$$InverterInvitesTableOrderingComposer,
      i1.$$InverterInvitesTableAnnotationComposer,
      $$InverterInvitesTableCreateCompanionBuilder,
      $$InverterInvitesTableUpdateCompanionBuilder,
      (
        i1.InverterInvite,
        i0.BaseReferences<
          i0.GeneratedDatabase,
          i1.$InverterInvitesTable,
          i1.InverterInvite
        >,
      ),
      i1.InverterInvite,
      i0.PrefetchHooks Function()
    >;

class $InverterInvitesTable extends i2.InverterInvites
    with i0.TableInfo<$InverterInvitesTable, i1.InverterInvite> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InverterInvitesTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<String> id = i0.GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const i0.VerificationMeta _tokenMeta = const i0.VerificationMeta(
    'token',
  );
  @override
  late final i0.GeneratedColumn<String> token = i0.GeneratedColumn<String>(
    'token',
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
      ).withConverter<DateTime>(i1.$InverterInvitesTable.$convertercreatedAt);
  @override
  late final i0.GeneratedColumnWithTypeConverter<DateTime, double> expiresAt =
      i0.GeneratedColumn<double>(
        'expires_at',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      ).withConverter<DateTime>(i1.$InverterInvitesTable.$converterexpiresAt);
  @override
  late final i0.GeneratedColumnWithTypeConverter<DateTime?, double> acceptedAt =
      i0.GeneratedColumn<double>(
        'accepted_at',
        aliasedName,
        true,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>(i1.$InverterInvitesTable.$converteracceptedAt);
  @override
  List<i0.GeneratedColumn> get $columns => [
    id,
    token,
    createdAt,
    expiresAt,
    acceptedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inverter_invites';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i1.InverterInvite> instance, {
    bool isInserting = false,
  }) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('token')) {
      context.handle(
        _tokenMeta,
        token.isAcceptableOrUnknown(data['token']!, _tokenMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.InverterInvite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.InverterInvite(
      id: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      token: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}token'],
      )!,
      createdAt: i1.$InverterInvitesTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.double,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      expiresAt: i1.$InverterInvitesTable.$converterexpiresAt.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.double,
          data['${effectivePrefix}expires_at'],
        )!,
      ),
      acceptedAt: i1.$InverterInvitesTable.$converteracceptedAt.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.double,
          data['${effectivePrefix}accepted_at'],
        ),
      ),
    );
  }

  @override
  $InverterInvitesTable createAlias(String alias) {
    return $InverterInvitesTable(attachedDatabase, alias);
  }

  static i0.JsonTypeConverter2<DateTime, double, String> $convertercreatedAt =
      const i3.DateTimeConverter();
  static i0.JsonTypeConverter2<DateTime, double, String> $converterexpiresAt =
      const i3.DateTimeConverter();
  static i0.JsonTypeConverter2<DateTime?, double?, String?>
  $converteracceptedAt = const i3.NullableDateTimeConverter();
}

class InverterInvite extends i0.DataClass
    implements i0.Insertable<i1.InverterInvite> {
  final String id;
  final String token;
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime? acceptedAt;
  const InverterInvite({
    required this.id,
    required this.token,
    required this.createdAt,
    required this.expiresAt,
    this.acceptedAt,
  });
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['token'] = i0.Variable<String>(token);
    {
      map['created_at'] = i0.Variable<double>(
        i1.$InverterInvitesTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['expires_at'] = i0.Variable<double>(
        i1.$InverterInvitesTable.$converterexpiresAt.toSql(expiresAt),
      );
    }
    if (!nullToAbsent || acceptedAt != null) {
      map['accepted_at'] = i0.Variable<double>(
        i1.$InverterInvitesTable.$converteracceptedAt.toSql(acceptedAt),
      );
    }
    return map;
  }

  i1.InverterInvitesCompanion toCompanion(bool nullToAbsent) {
    return i1.InverterInvitesCompanion(
      id: i0.Value(id),
      token: i0.Value(token),
      createdAt: i0.Value(createdAt),
      expiresAt: i0.Value(expiresAt),
      acceptedAt: acceptedAt == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(acceptedAt),
    );
  }

  factory InverterInvite.fromJson(
    Map<String, dynamic> json, {
    i0.ValueSerializer? serializer,
  }) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return InverterInvite(
      id: serializer.fromJson<String>(json['id']),
      token: serializer.fromJson<String>(json['token']),
      createdAt: i1.$InverterInvitesTable.$convertercreatedAt.fromJson(
        serializer.fromJson<String>(json['created_at']),
      ),
      expiresAt: i1.$InverterInvitesTable.$converterexpiresAt.fromJson(
        serializer.fromJson<String>(json['expires_at']),
      ),
      acceptedAt: i1.$InverterInvitesTable.$converteracceptedAt.fromJson(
        serializer.fromJson<String?>(json['accepted_at']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'token': serializer.toJson<String>(token),
      'created_at': serializer.toJson<String>(
        i1.$InverterInvitesTable.$convertercreatedAt.toJson(createdAt),
      ),
      'expires_at': serializer.toJson<String>(
        i1.$InverterInvitesTable.$converterexpiresAt.toJson(expiresAt),
      ),
      'accepted_at': serializer.toJson<String?>(
        i1.$InverterInvitesTable.$converteracceptedAt.toJson(acceptedAt),
      ),
    };
  }

  i1.InverterInvite copyWith({
    String? id,
    String? token,
    DateTime? createdAt,
    DateTime? expiresAt,
    i0.Value<DateTime?> acceptedAt = const i0.Value.absent(),
  }) => i1.InverterInvite(
    id: id ?? this.id,
    token: token ?? this.token,
    createdAt: createdAt ?? this.createdAt,
    expiresAt: expiresAt ?? this.expiresAt,
    acceptedAt: acceptedAt.present ? acceptedAt.value : this.acceptedAt,
  );
  InverterInvite copyWithCompanion(i1.InverterInvitesCompanion data) {
    return InverterInvite(
      id: data.id.present ? data.id.value : this.id,
      token: data.token.present ? data.token.value : this.token,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      acceptedAt: data.acceptedAt.present
          ? data.acceptedAt.value
          : this.acceptedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InverterInvite(')
          ..write('id: $id, ')
          ..write('token: $token, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('acceptedAt: $acceptedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, token, createdAt, expiresAt, acceptedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.InverterInvite &&
          other.id == this.id &&
          other.token == this.token &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt &&
          other.acceptedAt == this.acceptedAt);
}

class InverterInvitesCompanion extends i0.UpdateCompanion<i1.InverterInvite> {
  final i0.Value<String> id;
  final i0.Value<String> token;
  final i0.Value<DateTime> createdAt;
  final i0.Value<DateTime> expiresAt;
  final i0.Value<DateTime?> acceptedAt;
  final i0.Value<int> rowid;
  const InverterInvitesCompanion({
    this.id = const i0.Value.absent(),
    this.token = const i0.Value.absent(),
    this.createdAt = const i0.Value.absent(),
    this.expiresAt = const i0.Value.absent(),
    this.acceptedAt = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  InverterInvitesCompanion.insert({
    required String id,
    required String token,
    required DateTime createdAt,
    required DateTime expiresAt,
    this.acceptedAt = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  }) : id = i0.Value(id),
       token = i0.Value(token),
       createdAt = i0.Value(createdAt),
       expiresAt = i0.Value(expiresAt);
  static i0.Insertable<i1.InverterInvite> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? token,
    i0.Expression<double>? createdAt,
    i0.Expression<double>? expiresAt,
    i0.Expression<double>? acceptedAt,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (token != null) 'token': token,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (acceptedAt != null) 'accepted_at': acceptedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.InverterInvitesCompanion copyWith({
    i0.Value<String>? id,
    i0.Value<String>? token,
    i0.Value<DateTime>? createdAt,
    i0.Value<DateTime>? expiresAt,
    i0.Value<DateTime?>? acceptedAt,
    i0.Value<int>? rowid,
  }) {
    return i1.InverterInvitesCompanion(
      id: id ?? this.id,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<String>(id.value);
    }
    if (token.present) {
      map['token'] = i0.Variable<String>(token.value);
    }
    if (createdAt.present) {
      map['created_at'] = i0.Variable<double>(
        i1.$InverterInvitesTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (expiresAt.present) {
      map['expires_at'] = i0.Variable<double>(
        i1.$InverterInvitesTable.$converterexpiresAt.toSql(expiresAt.value),
      );
    }
    if (acceptedAt.present) {
      map['accepted_at'] = i0.Variable<double>(
        i1.$InverterInvitesTable.$converteracceptedAt.toSql(acceptedAt.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InverterInvitesCompanion(')
          ..write('id: $id, ')
          ..write('token: $token, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('acceptedAt: $acceptedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}
