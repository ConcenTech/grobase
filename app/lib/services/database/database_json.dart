/// Normalizes Supabase/PostgREST JSON so Drift [fromJson] can parse release
/// rows that use nullable columns the offline models treat as required.
///
/// Release inverters often have `last_seen_at = null` until the first snapshot
/// ingest; development seed data always sets it. Without this, systems sync
/// throws a type cast and surfaces as a generic sync error.
class DatabaseJson {
  DatabaseJson._();

  static const _epoch = '1970-01-01T00:00:00.000Z';

  static Map<String, dynamic> inverter(Map<String, dynamic> json) {
    return {
      ...json,
      'last_seen_at': json['last_seen_at'] ?? _epoch,
      'location': location(json['location']),
    };
  }

  static Map<String, dynamic> location(Object? value) {
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      final name = map['name'];
      final latitude = map['latitude'];
      final longitude = map['longitude'];
      if (name is String && latitude is num && longitude is num) {
        return {
          'name': name,
          'latitude': latitude,
          'longitude': longitude,
        };
      }
    }

    return {
      'name': 'Unknown',
      'latitude': 0.0,
      'longitude': 0.0,
    };
  }

  static Map<String, dynamic> snapshot(Map<String, dynamic> json) {
    return {
      ...json,
      'gateway_id': json['gateway_id'] ?? '',
      'battery_soc_percent': _numberOrZero(json['battery_soc_percent']),
      'battery_voltage_v': _numberOrZero(json['battery_voltage_v']),
      'battery_current_a': _numberOrZero(json['battery_current_a']),
      'battery_charge_power_w': _numberOrZero(json['battery_charge_power_w']),
      'battery_discharge_power_w': _numberOrZero(
        json['battery_discharge_power_w'],
      ),
      'battery_charge_energy_today_kwh': _numberOrZero(
        json['battery_charge_energy_today_kwh'],
      ),
      'battery_discharge_energy_today_kwh': _numberOrZero(
        json['battery_discharge_energy_today_kwh'],
      ),
      'grid_active_power_w': _numberOrZero(json['grid_active_power_w']),
      'grid_frequency_hz': _numberOrZero(json['grid_frequency_hz']),
      'grid_voltage_v': _numberOrZero(json['grid_voltage_v']),
      'grid_current_a': _numberOrZero(json['grid_current_a']),
      'grid_export_power_w': _numberOrZero(json['grid_export_power_w']),
      'grid_export_energy_today_kwh': _numberOrZero(
        json['grid_export_energy_today_kwh'],
      ),
      'grid_import_energy_today_kwh': _numberOrZero(
        json['grid_import_energy_today_kwh'],
      ),
      'grid_charge_power_w': _numberOrZero(json['grid_charge_power_w']),
      'solar_energy_today_kwh': _numberOrZero(json['solar_energy_today_kwh']),
      'solar_power_w': _numberOrZero(json['solar_power_w']),
      'home_load_power_w': _numberOrZero(json['home_load_power_w']),
    };
  }

  static Map<String, dynamic> gateway(Map<String, dynamic> json) {
    return {
      ...json,
      'inverter_id': json['inverter_id'] ?? '',
      'provisioned_by': json['provisioned_by'] ?? '',
      'firmware_version': json['firmware_version'] ?? '',
      'last_seen_at': json['last_seen_at'] ?? _epoch,
      'retired_at': json['retired_at'] ?? _epoch,
    };
  }

  static double _numberOrZero(Object? value) {
    if (value is num) return value.toDouble();
    return 0;
  }
}
