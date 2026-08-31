import 'package:drift/drift.dart';
import 'package:logging/logging.dart';

import '../../models/database/app_database.dart';
import '../../models/database/inverter.drift.dart';
import '../../models/database/inverter_member.drift.dart';
import '../../models/database/inverter_snapshot.drift.dart';

class OfflineDatabaseService {
  OfflineDatabaseService(this._db);

  final AppDatabase _db;
  final _logger = Logger('OfflineDatabaseService');

  Stream<List<InverterSnapshot>> inverterSnapshots(
    String inverterId,
    DateTime dateTime,
  ) {
    try {
      final queryStartDate = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
      );
      final queryEndDate = queryStartDate.add(const Duration(days: 1));
      final q = _db.inverterSnapshots.select()
        ..where(
          (e) => e.recordedAt.isBiggerOrEqualValue(
            queryStartDate.millisecondsSinceEpoch / 1000,
          ),
        )
        ..where(
          (e) => e.recordedAt.isSmallerThanValue(
            queryEndDate.millisecondsSinceEpoch / 1000,
          ),
        )
        ..where((e) => e.inverterId.equals(inverterId));

      return q
          .watch() //
          .handleError((e, s) {
            _logger.severe('Failure emitting inverter snapshots', e, s);
          });
    } catch (e, stackTrace) {
      _logger.severe(
        'Failed to create inverter snapshots stream',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  Stream<InverterSnapshot?> latestInverterSnapshot(String inverterId) {
    try {
      final q = _db.inverterSnapshots.select()
        ..where((e) => e.inverterId.equals(inverterId))
        ..orderBy([(e) => OrderingTerm.desc(e.recordedAt)])
        ..limit(1);

      return q
          .watchSingleOrNull() //
          .handleError((e, s) {
            _logger.severe('Failure emitting latest inverter snapshot', e, s);
          });
    } catch (e, stackTrace) {
      _logger.severe(
        'Failed to create latest inverter snapshot stream',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<List<Inverter>> getInverters() async {
    try {
      final q = _db.inverters.select();
      return await q.get();
    } catch (e, stackTrace) {
      _logger.severe('Failed to get inverters', e, stackTrace);
      rethrow;
    }
  }

  Stream<List<Inverter>> inverters() {
    try {
      final q = _db.inverters.select();
      return q
          .watch() //
          .handleError((e, s) {
            _logger.severe('Failure emitting inverters', e, s);
          });
    } catch (e, stackTrace) {
      _logger.severe('Failed to create inverters stream', e, stackTrace);
      rethrow;
    }
  }

  Future<void> setInverters(List<Inverter> inverters) async {
    try {
      await _db.transaction(() async {
        await _db.inverters.deleteAll();
        await _db.inverters.insertAll(inverters);
      });
    } catch (e, s) {
      _logger.severe('Failed to set inverters', e, s);
      rethrow;
    }
  }

  /// If userId is provided, all existing memberships for that user will be
  /// deleted and replaced with the new memberships.
  ///
  /// Otherwise, the memberships will be added to the existing memberships.
  Future<void> setInverterMembers(
    List<InverterMember> members, [
    String? userId,
  ]) async {
    try {
      await _db.transaction(() async {
        if (userId != null) {
          await _db.inverterMembers.deleteWhere((e) => e.userId.equals(userId));
        }
        await _db.inverterMembers.insertAll(members);
      });
    } catch (e, s) {
      _logger.severe('Failed to set inverter members', e, s);
      rethrow;
    }
  }

  Stream<InverterMember?> inverterMembership(String userId, String inverterId) {
    try {
      final q = _db.inverterMembers.select()
        ..where((e) => e.userId.equals(userId))
        ..where((e) => e.inverterId.equals(inverterId));
      return q.watchSingleOrNull();
    } catch (e, s) {
      _logger.severe('Failed to get inverter membership', e, s);
      rethrow;
    }
  }

  Future<void> addInverter(Inverter inverter) async {
    try {
      await _db.inverters.insertOne(inverter);
    } catch (e, s) {
      _logger.severe('Failed to add inverter', e, s);
      rethrow;
    }
  }

  Future<void> upsertInverter(Inverter inverter) async {
    try {
      await _db.inverters.insertOnConflictUpdate(inverter);
    } catch (e, s) {
      _logger.severe('Failed to upsert inverter', e, s);
      rethrow;
    }
  }

  Future<void> removeInverter(String inverterId) async {
    try {
      await _db.inverters.deleteWhere((e) => e.id.equals(inverterId));
    } catch (e, s) {
      _logger.severe('Failed to remove inverter', e, s);
      rethrow;
    }
  }

  Future<void> removeSnapshots(String inverterId) async {
    try {
      await _db.inverterSnapshots.deleteWhere(
        (e) => e.inverterId.equals(inverterId),
      );
    } catch (e, s) {
      _logger.severe('Failed to remove snapshots', e, s);
      rethrow;
    }
  }

  Future<void> updateInverter(Inverter inverter) async {
    try {
      await _db.inverters.insertOnConflictUpdate(inverter);
    } catch (e, s) {
      _logger.severe('Failed to update inverter', e, s);
      rethrow;
    }
  }

  Future<void> deleteInverter(String inverterId) async {
    try {
      await _db.inverters.deleteWhere((e) => e.id.equals(inverterId));
    } catch (e, s) {
      _logger.severe('Failed to delete inverter', e, s);
      rethrow;
    }
  }

  Future<int> getInverterCount() async {
    try {
      return await _db.inverters.count().getSingle();
    } catch (e, s) {
      _logger.severe('Failed to get inverter count', e, s);
      rethrow;
    }
  }

  Future<void> addSnapshots(List<InverterSnapshot> snapshots) async {
    try {
      await _db.inverterSnapshots.insertAll(
        snapshots,
        mode: InsertMode.insertOrIgnore,
      );
    } catch (e, s) {
      _logger.severe('Failed to add snapshots', e, s);
      rethrow;
    }
  }

  Future<DateTime?> getInverterLastSnapshotTime(String inverterId) async {
    try {
      final q = _db.inverterSnapshots.select()
        ..where((e) => e.inverterId.equals(inverterId))
        ..orderBy([(e) => OrderingTerm.desc(e.recordedAt)])
        ..limit(1);
      final snapshot = await q.getSingleOrNull();
      return snapshot?.recordedAt;
    } catch (e, s) {
      _logger.severe('Failed to get inverter last snapshot time', e, s);
      rethrow;
    }
  }

  Future<DateTime?> getInverterLastSnapshotTimeForDate(
    String inverterId,
    DateTime date,
  ) async {
    try {
      final queryStartDate = DateTime(date.year, date.month, date.day);
      final queryEndDate = queryStartDate.add(const Duration(days: 1));
      final q = _db.inverterSnapshots.select()
        ..where((e) => e.inverterId.equals(inverterId))
        ..where(
          (e) => e.recordedAt.isBiggerOrEqualValue(
            queryStartDate.millisecondsSinceEpoch / 1000,
          ),
        )
        ..where(
          (e) => e.recordedAt.isSmallerThanValue(
            queryEndDate.millisecondsSinceEpoch / 1000,
          ),
        )
        ..orderBy([(e) => OrderingTerm.desc(e.recordedAt)])
        ..limit(1);
      final snapshot = await q.getSingleOrNull();
      return snapshot?.recordedAt;
    } catch (e, s) {
      _logger.severe('Failed to get inverter last snapshot time', e, s);
      rethrow;
    }
  }

  Future<void> clear() async {
    try {
      await _db.transaction(() async {
        for (var table in _db.allTables) {
          await table.deleteAll();
        }
      });
    } catch (e, s) {
      _logger.severe('Failed to clear database', e, s);
      rethrow;
    }
  }
}
