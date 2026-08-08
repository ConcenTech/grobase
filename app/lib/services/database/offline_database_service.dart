import 'package:drift/drift.dart';
import 'package:logging/logging.dart';

import '../../models/database/app_database.dart';
import '../../models/database/inverter.drift.dart';
import '../../models/database/inverter_snapshot.drift.dart';

class OfflineDatabaseService {
  OfflineDatabaseService(this._db);

  final AppDatabase _db;
  final _logger = Logger('OfflineDatabaseService');

  /// Snapshots recorded on [day]'s local calendar date (defaults to today).
  ///
  /// The lower bound is fixed for the lifetime of the returned stream — callers
  /// must recreate it when the civil day changes.
  Stream<List<InverterSnapshot>> todaysInverterSnapshots(
    String inverterId, {
    DateTime? day,
  }) {
    try {
      final base = day ?? DateTime.now();
      final today =
          DateTime(base.year, base.month, base.day).millisecondsSinceEpoch /
          1000;

      final q = _db.inverterSnapshots.select()
        ..where((e) => e.recordedAt.isBiggerOrEqualValue(today))
        ..where((e) => e.inverterId.equals(inverterId));

      return q
          .watch() //
          .handleError((e, s) {
            _logger.severe('Failure emitting todays inverter snapshots', e, s);
          });
    } catch (e, stackTrace) {
      _logger.severe(
        'Failed to create todays inverter snapshots stream',
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

  // Future<void> removeSnapshot(String snapshotId) async {
  //   try {
  //     await _db.inverterSnapshots.deleteWhere((e) => e.id.equals(snapshotId));
  //   } catch (e, s) {
  //     _logger.severe('Failed to remove snapshot', e, s);
  //     rethrow;
  //   }
  // }

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
