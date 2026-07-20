#// Defines the `InverterSnapshot` data structure and helpers to
#// populate/print it from Modbus register tables.
#pragma once

#include <Arduino.h>

struct InverterSnapshot {
  bool modbus_ok;

  float battery_discharge_power_w;
  float battery_charge_power_w;
  float vbat;
  float vbat_dsp;
  float soc_1014;
  float bms_soc;
  float bms_battery_volt;
  float bms_battery_curr;
  float battery_discharge_energy_today_kwh;
  float battery_charge_energy_today_kwh;

  float grid_pac_w;
  float grid_frequency_hz;
  float grid_voltage_v;
  float grid_current_a;
  float power_to_grid_w;
  float energy_to_grid_today_kwh;
  float ac_charge_energy_today_kwh;
  float ac_charge_power_w;
  float eac_today_kwh;
  float ea_charge_today_kwh;
  float ac_charge_power_spa_w;

  float pv_energy_today_kwh;
  /// ExtraACPower (1131–1132): AC power from the SPA-connected PV inverter.
  float pv_power_w;
  float power_to_user_w;
  float local_load_power_w;
  /// PSystem (1145–1146): system/house load power.
  float system_power_w;
};

void fillInverterSnapshot(InverterSnapshot *out,
                          const uint16_t *r1009,
                          const uint16_t *r1086,
                          const uint16_t *r1124,
                          const uint16_t *r2035,
                          const uint16_t *r2097,
                          const uint16_t *r2112);

void printInverterSnapshotJson(const InverterSnapshot *s);
