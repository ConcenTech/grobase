#pragma once

#ifndef MODBUS_DEBUG
#define MODBUS_DEBUG 0
#endif

#// Defines the `InverterSnapshot` data structure and helpers to
#// populate/print it from Modbus register tables.

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

  /// SPA AC-port power (2035–36 Pac), signed. Not site grid import/export.
  float grid_pac_w;
  float grid_frequency_hz;
  float grid_voltage_v;
  float grid_current_a;
  /// Pactogrid (1029–30): power exported to the utility grid.
  float power_to_grid_w;
  float energy_to_grid_today_kwh;
  float ac_charge_energy_today_kwh;
  float ac_charge_power_w;
  float eac_today_kwh;
  float ea_charge_today_kwh;
  float ac_charge_power_spa_w;

  float pv_energy_today_kwh;
  /// ExtraACPower (2102–2103): AC power from the SPA-connected PV inverter.
  /// (1131–1132 is the same doc field but reads 0 on live SPA hardware.)
  float pv_power_w;
  /// Pactouser (1021–22): power imported from the utility grid to the house.
  float power_to_user_w;
  /// PLocalLoad (1037–38): whole-house load (grid + solar + battery contribution).
  float home_load_power_w;

#if MODBUS_DEBUG
  /// Pre-built JSON object for inverter_snapshots.metadata (empty if unused).
  String modbus_debug_metadata;
#endif
};

void fillInverterSnapshot(InverterSnapshot *out,
                          const uint16_t *r1009,
                          const uint16_t *r1086,
                          const uint16_t *r1124,
                          const uint16_t *r2035,
                          const uint16_t *r2097,
                          const uint16_t *r2112);

void printInverterSnapshotJson(const InverterSnapshot *s);
