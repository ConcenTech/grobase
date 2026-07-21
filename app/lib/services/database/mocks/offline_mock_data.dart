import 'dart:math' as math;

import '../../../models/database/inverter.drift.dart';
import '../../../models/database/inverter_snapshot.drift.dart';
import '../../../models/location.dart';

/// In-memory demo dataset used by [MockOnlineDatabaseService].
///
/// Mirrors `supabase/seed.sql` (Home with 24h snapshots, Beach House current,
/// Workshop one day stale).
class OfflineMockDataset {
  const OfflineMockDataset({required this.inverters, required this.snapshots});

  final List<Inverter> inverters;
  final List<InverterSnapshot> snapshots;
}

class OfflineMockData {
  OfflineMockData._();

  static const homeId = 'b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a22';
  static const homeGatewayId = 'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a33';
  static const beachId = 'b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a23';
  static const beachGatewayId = 'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a34';
  static const workshopId = 'b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a24';
  static const workshopGatewayId = 'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a35';

  static OfflineMockDataset build() {
    final now = DateTime.now().copyWith(
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
    final start = now.subtract(const Duration(hours: 24));
    final yesterday = now.subtract(const Duration(days: 1));

    final inverters = [
      Inverter(
        id: homeId,
        inverterSn: 'SN-DEMO-0001',
        displayName: 'Home',
        createdAt: start,
        lastSeenAt: now,
        location: const Location(
          name: 'London',
          latitude: 51.5074,
          longitude: -0.1278,
        ),
      ),
      Inverter(
        id: beachId,
        inverterSn: 'SN-DEMO-0002',
        displayName: 'Beach House',
        createdAt: start,
        lastSeenAt: now,
        location: const Location(
          name: 'Brighton',
          latitude: 50.8225,
          longitude: -0.1372,
        ),
      ),
      Inverter(
        id: workshopId,
        inverterSn: 'SN-DEMO-0003',
        displayName: 'Workshop',
        createdAt: start,
        lastSeenAt: yesterday,
        location: const Location(
          name: 'Manchester',
          latitude: 53.4808,
          longitude: -2.2426,
        ),
      ),
    ];

    final snapshots = <InverterSnapshot>[
      ..._homeSnapshots(start: start, end: now),
      _singleSnapshot(
        id: 10000,
        inverterId: beachId,
        gatewayId: beachGatewayId,
        recordedAt: now,
        batterySoc: 72,
        batteryVoltage: 52.1,
        batteryCurrent: 8.5,
        chargePower: 450,
        dischargePower: 0,
        chargeEnergyToday: 3.2,
        dischargeEnergyToday: 0.4,
        gridImportPower: 0,
        gridVoltage: 231,
        gridCurrent: 0,
        gridExportPower: 1200,
        gridExportEnergyToday: 4.8,
        gridImportEnergyToday: 0.2,
        solarEnergyToday: 12.5,
        solarPower: 2800,
        homeLoadPower: 1150,
      ),
      _singleSnapshot(
        id: 10001,
        inverterId: workshopId,
        gatewayId: workshopGatewayId,
        recordedAt: yesterday,
        batterySoc: 38,
        batteryVoltage: 50.4,
        batteryCurrent: -12,
        chargePower: 0,
        dischargePower: 620,
        chargeEnergyToday: 1.1,
        dischargeEnergyToday: 2.8,
        gridImportPower: 450,
        gridVoltage: 229,
        gridCurrent: 2,
        gridExportPower: 0,
        gridExportEnergyToday: 0.6,
        gridImportEnergyToday: 3.4,
        solarEnergyToday: 6.1,
        solarPower: 0,
        homeLoadPower: 980,
      ),
    ];

    return OfflineMockDataset(inverters: inverters, snapshots: snapshots);
  }

  static List<InverterSnapshot> _homeSnapshots({
    required DateTime start,
    required DateTime end,
  }) {
    final points = <_MetricPoint>[];

    for (
      var t = start;
      !t.isAfter(end);
      t = t.add(const Duration(minutes: 5))
    ) {
      final hourFrac = t.hour + t.minute / 60.0;
      final solarPower = math.max(
        0.0,
        5200.0 *
            math.max(0.0, math.sin(_radians((hourFrac - 6.0) * 180.0 / 12.0))),
      );
      final homeLoad =
          650.0 +
          900.0 *
              (hourFrac >= 7 && hourFrac < 10
                  ? 1.0
                  : hourFrac >= 17 && hourFrac < 22
                  ? 1.2
                  : hourFrac < 6
                  ? 0.35
                  : 0.7) +
          80.0 * math.sin(_radians(t.minute * 12.0));
      final batterySoc = math.max(
        15.0,
        math.min(
          98.0,
          55.0 + 25.0 * math.sin(_radians((hourFrac - 6.0) * 15.0)),
        ),
      );
      final charge = math.max(0.0, solarPower - homeLoad);
      final discharge = math.max(0.0, homeLoad - solarPower);
      final gridExport = math.max(0.0, solarPower - homeLoad - 500.0);
      final gridImport = math.max(0.0, homeLoad - solarPower - 800.0);

      points.add(
        _MetricPoint(
          recordedAt: t,
          hourFrac: hourFrac,
          solarPower: solarPower,
          homeLoad: homeLoad,
          batterySoc: batterySoc,
          charge: charge,
          discharge: discharge,
          gridExport: gridExport,
          gridImport: gridImport,
        ),
      );
    }

    final chargeToday = <DateTime, double>{};
    final dischargeToday = <DateTime, double>{};
    final exportToday = <DateTime, double>{};
    final importToday = <DateTime, double>{};
    final solarToday = <DateTime, double>{};

    final snapshots = <InverterSnapshot>[];
    var id = 1;

    for (final p in points) {
      final day = DateTime(
        p.recordedAt.year,
        p.recordedAt.month,
        p.recordedAt.day,
      );
      chargeToday[day] = (chargeToday[day] ?? 0) + p.charge / 12000.0;
      dischargeToday[day] = (dischargeToday[day] ?? 0) + p.discharge / 12000.0;
      exportToday[day] = (exportToday[day] ?? 0) + p.gridExport / 12000.0;
      importToday[day] = (importToday[day] ?? 0) + p.gridImport / 12000.0;
      solarToday[day] = (solarToday[day] ?? 0) + p.solarPower / 12000.0;

      final batteryVoltage =
          51.2 + 1.5 * math.sin(_radians((p.hourFrac - 6.0) * 15.0));
      final batteryCurrent = p.charge > 0
          ? p.charge / 51.2
          : -p.discharge / 51.2;

      snapshots.add(
        InverterSnapshot(
          id: id++,
          inverterId: homeId,
          gatewayId: homeGatewayId,
          recordedAt: p.recordedAt,
          ingestedAt: p.recordedAt.add(const Duration(seconds: 2)),
          batteryStateOfCharge: p.batterySoc,
          batteryVoltage: batteryVoltage,
          batteryCurrent: batteryCurrent,
          chargePower: p.charge,
          dischargePower: p.discharge,
          chargeEnergyToday: _round3(chargeToday[day]!),
          dischargeEnergyToday: _round3(dischargeToday[day]!),
          gridImportPower: p.gridImport,
          gridFrequency: 50,
          gridVoltage: 230 + 2 * math.sin(_radians(p.recordedAt.minute * 6.0)),
          gridCurrent: (p.gridImport + p.gridExport) / 230.0,
          gridExportPower: p.gridExport,
          gridExportEnergyToday: _round3(exportToday[day]!),
          gridImportEnergyToday: _round3(importToday[day]!),
          gridChargePower: 0,
          solarEnergyToday: _round3(solarToday[day]!),
          solarPower: p.solarPower,
          homeLoadPower: p.homeLoad,
        ),
      );
    }

    return snapshots;
  }

  static InverterSnapshot _singleSnapshot({
    required int id,
    required String inverterId,
    required String gatewayId,
    required DateTime recordedAt,
    required double batterySoc,
    required double batteryVoltage,
    required double batteryCurrent,
    required double chargePower,
    required double dischargePower,
    required double chargeEnergyToday,
    required double dischargeEnergyToday,
    required double gridImportPower,
    required double gridVoltage,
    required double gridCurrent,
    required double gridExportPower,
    required double gridExportEnergyToday,
    required double gridImportEnergyToday,
    required double solarEnergyToday,
    required double solarPower,
    required double homeLoadPower,
  }) {
    return InverterSnapshot(
      id: id,
      inverterId: inverterId,
      gatewayId: gatewayId,
      recordedAt: recordedAt,
      ingestedAt: recordedAt.add(const Duration(seconds: 2)),
      batteryStateOfCharge: batterySoc,
      batteryVoltage: batteryVoltage,
      batteryCurrent: batteryCurrent,
      chargePower: chargePower,
      dischargePower: dischargePower,
      chargeEnergyToday: chargeEnergyToday,
      dischargeEnergyToday: dischargeEnergyToday,
      gridImportPower: gridImportPower,
      gridFrequency: 50,
      gridVoltage: gridVoltage,
      gridCurrent: gridCurrent,
      gridExportPower: gridExportPower,
      gridExportEnergyToday: gridExportEnergyToday,
      gridImportEnergyToday: gridImportEnergyToday,
      gridChargePower: 0,
      solarEnergyToday: solarEnergyToday,
      solarPower: solarPower,
      homeLoadPower: homeLoadPower,
    );
  }

  static double _radians(double degrees) => degrees * math.pi / 180.0;

  static double _round3(double value) => (value * 1000).round() / 1000.0;
}

class _MetricPoint {
  const _MetricPoint({
    required this.recordedAt,
    required this.hourFrac,
    required this.solarPower,
    required this.homeLoad,
    required this.batterySoc,
    required this.charge,
    required this.discharge,
    required this.gridExport,
    required this.gridImport,
  });

  final DateTime recordedAt;
  final double hourFrac;
  final double solarPower;
  final double homeLoad;
  final double batterySoc;
  final double charge;
  final double discharge;
  final double gridExport;
  final double gridImport;
}
