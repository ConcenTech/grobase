// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inverter_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InverterSnapshot _$InverterSnapshotFromJson(Map<String, dynamic> json) =>
    _InverterSnapshot(
      id: (json['id'] as num).toInt(),
      inverterId: json['inverter_id'] as String,
      gatewayId: json['gateway_id'] as String,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
      ingestedAt: DateTime.parse(json['ingested_at'] as String),
      batteryStateOfCharge: (json['battery_soc_percent'] as num).toDouble(),
      batteryVoltage: (json['battery_voltage_v'] as num).toDouble(),
      batteryCurrent: (json['battery_current_a'] as num).toDouble(),
      chargePower: (json['battery_charge_power_w'] as num).toDouble(),
      dischargePower: (json['battery_discharge_power_w'] as num).toDouble(),
      chargeEnergyToday: (json['battery_charge_energy_today_kwh'] as num)
          .toDouble(),
      dischargeEnergyToday: (json['battery_discharge_energy_today_kwh'] as num)
          .toDouble(),
      gridActivePower: (json['grid_active_power_w'] as num).toDouble(),
      gridFrequency: (json['grid_frequency_hz'] as num).toDouble(),
      gridVoltage: (json['grid_voltage_v'] as num).toDouble(),
      gridCurrent: (json['grid_current_a'] as num).toDouble(),
      gridExportPower: (json['grid_export_power_w'] as num).toDouble(),
      gridExportEnergyToday: (json['grid_export_energy_today_kwh'] as num)
          .toDouble(),
      gridImportEnergyToday: (json['grid_import_energy_today_kwh'] as num)
          .toDouble(),
      gridChargePower: (json['grid_charge_power_w'] as num).toDouble(),
      solarEnergyToday: (json['solar_energy_today_kwh'] as num).toDouble(),
      solarPower: (json['solar_power_w'] as num).toDouble(),
      homeLoadPower: (json['home_load_power_w'] as num).toDouble(),
    );

Map<String, dynamic> _$InverterSnapshotToJson(_InverterSnapshot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inverter_id': instance.inverterId,
      'gateway_id': instance.gatewayId,
      'recorded_at': instance.recordedAt.toIso8601String(),
      'ingested_at': instance.ingestedAt.toIso8601String(),
      'battery_soc_percent': instance.batteryStateOfCharge,
      'battery_voltage_v': instance.batteryVoltage,
      'battery_current_a': instance.batteryCurrent,
      'battery_charge_power_w': instance.chargePower,
      'battery_discharge_power_w': instance.dischargePower,
      'battery_charge_energy_today_kwh': instance.chargeEnergyToday,
      'battery_discharge_energy_today_kwh': instance.dischargeEnergyToday,
      'grid_active_power_w': instance.gridActivePower,
      'grid_frequency_hz': instance.gridFrequency,
      'grid_voltage_v': instance.gridVoltage,
      'grid_current_a': instance.gridCurrent,
      'grid_export_power_w': instance.gridExportPower,
      'grid_export_energy_today_kwh': instance.gridExportEnergyToday,
      'grid_import_energy_today_kwh': instance.gridImportEnergyToday,
      'grid_charge_power_w': instance.gridChargePower,
      'solar_energy_today_kwh': instance.solarEnergyToday,
      'solar_power_w': instance.solarPower,
      'home_load_power_w': instance.homeLoadPower,
    };
