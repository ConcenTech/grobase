// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:grobase/models/database/inverter_member.drift.dart' as i1;
import 'package:grobase/models/database/inverter_member.dart' as i2;
import 'package:grobase/models/database/converters.dart' as i3;

typedef $$InverterMembersTableCreateCompanionBuilder =
    i1.InverterMembersCompanion Function({
      required String inverterId,
      required String userId,
      required i2.InverterMemberRole role,
      required DateTime createdAt,
      i0.Value<int> rowid,
    });
typedef $$InverterMembersTableUpdateCompanionBuilder =
    i1.InverterMembersCompanion Function({
      i0.Value<String> inverterId,
      i0.Value<String> userId,
      i0.Value<i2.InverterMemberRole> role,
      i0.Value<DateTime> createdAt,
      i0.Value<int> rowid,
    });

class $$InverterMembersTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$InverterMembersTable> {
  $$InverterMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnFilters<String> get inverterId => $composableBuilder(
    column: $table.inverterId,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<
    i2.InverterMemberRole,
    i2.InverterMemberRole,
    String
  >
  get role => $composableBuilder(
    column: $table.role,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<DateTime, DateTime, double> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => i0.ColumnWithTypeConverterFilters(column),
      );
}

class $$InverterMembersTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$InverterMembersTable> {
  $$InverterMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnOrderings<String> get inverterId => $composableBuilder(
    column: $table.inverterId,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => i0.ColumnOrderings(column),
  );
}

class $$InverterMembersTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$InverterMembersTable> {
  $$InverterMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.GeneratedColumn<String> get inverterId => $composableBuilder(
    column: $table.inverterId,
    builder: (column) => column,
  );

  i0.GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<i2.InverterMemberRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<DateTime, double> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$InverterMembersTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i1.$InverterMembersTable,
          i1.InverterMember,
          i1.$$InverterMembersTableFilterComposer,
          i1.$$InverterMembersTableOrderingComposer,
          i1.$$InverterMembersTableAnnotationComposer,
          $$InverterMembersTableCreateCompanionBuilder,
          $$InverterMembersTableUpdateCompanionBuilder,
          (
            i1.InverterMember,
            i0.BaseReferences<
              i0.GeneratedDatabase,
              i1.$InverterMembersTable,
              i1.InverterMember
            >,
          ),
          i1.InverterMember,
          i0.PrefetchHooks Function()
        > {
  $$InverterMembersTableTableManager(
    i0.GeneratedDatabase db,
    i1.$InverterMembersTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i1.$$InverterMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              i1.$$InverterMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => i1
              .$$InverterMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                i0.Value<String> inverterId = const i0.Value.absent(),
                i0.Value<String> userId = const i0.Value.absent(),
                i0.Value<i2.InverterMemberRole> role = const i0.Value.absent(),
                i0.Value<DateTime> createdAt = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i1.InverterMembersCompanion(
                inverterId: inverterId,
                userId: userId,
                role: role,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String inverterId,
                required String userId,
                required i2.InverterMemberRole role,
                required DateTime createdAt,
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i1.InverterMembersCompanion.insert(
                inverterId: inverterId,
                userId: userId,
                role: role,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), i0.BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InverterMembersTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i1.$InverterMembersTable,
      i1.InverterMember,
      i1.$$InverterMembersTableFilterComposer,
      i1.$$InverterMembersTableOrderingComposer,
      i1.$$InverterMembersTableAnnotationComposer,
      $$InverterMembersTableCreateCompanionBuilder,
      $$InverterMembersTableUpdateCompanionBuilder,
      (
        i1.InverterMember,
        i0.BaseReferences<
          i0.GeneratedDatabase,
          i1.$InverterMembersTable,
          i1.InverterMember
        >,
      ),
      i1.InverterMember,
      i0.PrefetchHooks Function()
    >;

class $InverterMembersTable extends i2.InverterMembers
    with i0.TableInfo<$InverterMembersTable, i1.InverterMember> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InverterMembersTable(this.attachedDatabase, [this._alias]);
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
  static const i0.VerificationMeta _userIdMeta = const i0.VerificationMeta(
    'userId',
  );
  @override
  late final i0.GeneratedColumn<String> userId = i0.GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final i0.GeneratedColumnWithTypeConverter<i2.InverterMemberRole, String>
  role =
      i0.GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<i2.InverterMemberRole>(
        i1.$InverterMembersTable.$converterrole,
      );
  @override
  late final i0.GeneratedColumnWithTypeConverter<DateTime, double> createdAt =
      i0.GeneratedColumn<double>(
        'created_at',
        aliasedName,
        false,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: true,
      ).withConverter<DateTime>(i1.$InverterMembersTable.$convertercreatedAt);
  @override
  List<i0.GeneratedColumn> get $columns => [
    inverterId,
    userId,
    role,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inverter_members';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i1.InverterMember> instance, {
    bool isInserting = false,
  }) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('inverter_id')) {
      context.handle(
        _inverterIdMeta,
        inverterId.isAcceptableOrUnknown(data['inverter_id']!, _inverterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_inverterIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {inverterId, userId};
  @override
  i1.InverterMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.InverterMember(
      inverterId: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}inverter_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      role: i1.$InverterMembersTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
      ),
      createdAt: i1.$InverterMembersTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.double,
          data['${effectivePrefix}created_at'],
        )!,
      ),
    );
  }

  @override
  $InverterMembersTable createAlias(String alias) {
    return $InverterMembersTable(attachedDatabase, alias);
  }

  static i0.JsonTypeConverter2<i2.InverterMemberRole, String, String>
  $converterrole = const i2.InverterMemberRoleConverter();
  static i0.JsonTypeConverter2<DateTime, double, String> $convertercreatedAt =
      const i3.DateTimeConverter();
}

class InverterMember extends i0.DataClass
    implements i0.Insertable<i1.InverterMember> {
  final String inverterId;
  final String userId;
  final i2.InverterMemberRole role;
  final DateTime createdAt;
  const InverterMember({
    required this.inverterId,
    required this.userId,
    required this.role,
    required this.createdAt,
  });
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['inverter_id'] = i0.Variable<String>(inverterId);
    map['user_id'] = i0.Variable<String>(userId);
    {
      map['role'] = i0.Variable<String>(
        i1.$InverterMembersTable.$converterrole.toSql(role),
      );
    }
    {
      map['created_at'] = i0.Variable<double>(
        i1.$InverterMembersTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    return map;
  }

  i1.InverterMembersCompanion toCompanion(bool nullToAbsent) {
    return i1.InverterMembersCompanion(
      inverterId: i0.Value(inverterId),
      userId: i0.Value(userId),
      role: i0.Value(role),
      createdAt: i0.Value(createdAt),
    );
  }

  factory InverterMember.fromJson(
    Map<String, dynamic> json, {
    i0.ValueSerializer? serializer,
  }) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return InverterMember(
      inverterId: serializer.fromJson<String>(json['inverter_id']),
      userId: serializer.fromJson<String>(json['user_id']),
      role: i1.$InverterMembersTable.$converterrole.fromJson(
        serializer.fromJson<String>(json['role']),
      ),
      createdAt: i1.$InverterMembersTable.$convertercreatedAt.fromJson(
        serializer.fromJson<String>(json['created_at']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'inverter_id': serializer.toJson<String>(inverterId),
      'user_id': serializer.toJson<String>(userId),
      'role': serializer.toJson<String>(
        i1.$InverterMembersTable.$converterrole.toJson(role),
      ),
      'created_at': serializer.toJson<String>(
        i1.$InverterMembersTable.$convertercreatedAt.toJson(createdAt),
      ),
    };
  }

  i1.InverterMember copyWith({
    String? inverterId,
    String? userId,
    i2.InverterMemberRole? role,
    DateTime? createdAt,
  }) => i1.InverterMember(
    inverterId: inverterId ?? this.inverterId,
    userId: userId ?? this.userId,
    role: role ?? this.role,
    createdAt: createdAt ?? this.createdAt,
  );
  InverterMember copyWithCompanion(i1.InverterMembersCompanion data) {
    return InverterMember(
      inverterId: data.inverterId.present
          ? data.inverterId.value
          : this.inverterId,
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InverterMember(')
          ..write('inverterId: $inverterId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(inverterId, userId, role, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.InverterMember &&
          other.inverterId == this.inverterId &&
          other.userId == this.userId &&
          other.role == this.role &&
          other.createdAt == this.createdAt);
}

class InverterMembersCompanion extends i0.UpdateCompanion<i1.InverterMember> {
  final i0.Value<String> inverterId;
  final i0.Value<String> userId;
  final i0.Value<i2.InverterMemberRole> role;
  final i0.Value<DateTime> createdAt;
  final i0.Value<int> rowid;
  const InverterMembersCompanion({
    this.inverterId = const i0.Value.absent(),
    this.userId = const i0.Value.absent(),
    this.role = const i0.Value.absent(),
    this.createdAt = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  InverterMembersCompanion.insert({
    required String inverterId,
    required String userId,
    required i2.InverterMemberRole role,
    required DateTime createdAt,
    this.rowid = const i0.Value.absent(),
  }) : inverterId = i0.Value(inverterId),
       userId = i0.Value(userId),
       role = i0.Value(role),
       createdAt = i0.Value(createdAt);
  static i0.Insertable<i1.InverterMember> custom({
    i0.Expression<String>? inverterId,
    i0.Expression<String>? userId,
    i0.Expression<String>? role,
    i0.Expression<double>? createdAt,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (inverterId != null) 'inverter_id': inverterId,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.InverterMembersCompanion copyWith({
    i0.Value<String>? inverterId,
    i0.Value<String>? userId,
    i0.Value<i2.InverterMemberRole>? role,
    i0.Value<DateTime>? createdAt,
    i0.Value<int>? rowid,
  }) {
    return i1.InverterMembersCompanion(
      inverterId: inverterId ?? this.inverterId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (inverterId.present) {
      map['inverter_id'] = i0.Variable<String>(inverterId.value);
    }
    if (userId.present) {
      map['user_id'] = i0.Variable<String>(userId.value);
    }
    if (role.present) {
      map['role'] = i0.Variable<String>(
        i1.$InverterMembersTable.$converterrole.toSql(role.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = i0.Variable<double>(
        i1.$InverterMembersTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InverterMembersCompanion(')
          ..write('inverterId: $inverterId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}
