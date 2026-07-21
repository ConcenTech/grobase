import 'package:drift/drift.dart';

import 'converters.dart';

class InverterSnapshots extends Table {
  @JsonKey('id')
  IntColumn get id => integer()();
  @JsonKey('inverter_id')
  TextColumn get inverterId => text()();
  @JsonKey('gateway_id')
  TextColumn get gatewayId => text()();
  @JsonKey('recorded_at')
  RealColumn get recordedAt => real().map(const DateTimeConverter())();
  @JsonKey('ingested_at')
  RealColumn get ingestedAt => real().map(const DateTimeConverter())();
  @JsonKey('battery_soc_percent')
  RealColumn get batteryStateOfCharge => real()();
  @JsonKey('battery_voltage_v')
  RealColumn get batteryVoltage => real()();
  @JsonKey('battery_current_a')
  RealColumn get batteryCurrent => real()();
  @JsonKey('battery_charge_power_w')
  RealColumn get chargePower => real()();
  @JsonKey('battery_discharge_power_w')
  RealColumn get dischargePower => real()();
  @JsonKey('battery_charge_energy_today_kwh')
  RealColumn get chargeEnergyToday => real()();
  @JsonKey('battery_discharge_energy_today_kwh')
  RealColumn get dischargeEnergyToday => real()();
  @JsonKey('grid_import_power_w')
  RealColumn get gridImportPower => real()();
  @JsonKey('grid_frequency_hz')
  RealColumn get gridFrequency => real()();
  @JsonKey('grid_voltage_v')
  RealColumn get gridVoltage => real()();
  @JsonKey('grid_current_a')
  RealColumn get gridCurrent => real()();
  @JsonKey('grid_export_power_w')
  RealColumn get gridExportPower => real()();
  @JsonKey('grid_export_energy_today_kwh')
  RealColumn get gridExportEnergyToday => real()();
  @JsonKey('grid_import_energy_today_kwh')
  RealColumn get gridImportEnergyToday => real()();
  @JsonKey('grid_charge_power_w')
  RealColumn get gridChargePower => real()();
  @JsonKey('solar_energy_today_kwh')
  RealColumn get solarEnergyToday => real()();
  @JsonKey('solar_power_w')
  RealColumn get solarPower => real()();
  @JsonKey('home_load_power_w')
  RealColumn get homeLoadPower => real()();

  @override
  Set<Column> get primaryKey => {id};
}
