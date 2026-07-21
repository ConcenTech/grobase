// Snapshot JSON printer plus a compatibility wrapper around the
// profile-specific register decoder.
#include "inverter_snapshot.h"
#include "debug_print.h"
#include "profile_growatt.h"

void fillInverterSnapshot(InverterSnapshot *out,
                          const uint16_t *r1009,
                          const uint16_t *r1086,
                          const uint16_t *r1124,
                          const uint16_t *r2035,
                          const uint16_t *r2097,
                          const uint16_t *r2112) {
  profileGrowattFill(out, r1009, r1086, r1124, r2035, r2097, r2112);
}

void printInverterSnapshotJson(const InverterSnapshot *s) {
  DEBUG_PRINT("{");
  DEBUG_PRINTF("\"modbus_ok\":%s,", s->modbus_ok ? "true" : "false");
  DEBUG_PRINTF("\"BatteryDischargePower_W\":%.1f,", s->battery_discharge_power_w);
  DEBUG_PRINTF("\"BatteryChargePower_W\":%.1f,", s->battery_charge_power_w);
  DEBUG_PRINTF("\"Vbat\":%.1f,", s->vbat);
  DEBUG_PRINTF("\"Vbat_DSP\":%.1f,", s->vbat_dsp);
  DEBUG_PRINTF("\"SOC_1014\":%.0f,", s->soc_1014);
  DEBUG_PRINTF("\"BMS_SOC\":%.0f,", s->bms_soc);
  DEBUG_PRINTF("\"BMS_BatteryVolt\":%.1f,", s->bms_battery_volt);
  DEBUG_PRINTF("\"BMS_BatteryCurr\":%.1f,", s->bms_battery_curr);
  DEBUG_PRINTF("\"BatteryDischargeEnergyToday_kWh\":%.1f,", s->battery_discharge_energy_today_kwh);
  DEBUG_PRINTF("\"BatteryChargeEnergyToday_kWh\":%.1f,", s->battery_charge_energy_today_kwh);
  DEBUG_PRINTF("\"GridPac_W\":%.1f,", s->grid_pac_w);
  DEBUG_PRINTF("\"GridFrequency_Hz\":%.2f,", s->grid_frequency_hz);
  DEBUG_PRINTF("\"GridVoltage_V\":%.1f,", s->grid_voltage_v);
  DEBUG_PRINTF("\"GridCurrent_A\":%.1f,", s->grid_current_a);
  DEBUG_PRINTF("\"PowerToGrid_W\":%.1f,", s->power_to_grid_w);
  DEBUG_PRINTF("\"EnergyToGridToday_kWh\":%.1f,", s->energy_to_grid_today_kwh);
  DEBUG_PRINTF("\"ACChargeEnergyToday_kWh\":%.1f,", s->ac_charge_energy_today_kwh);
  DEBUG_PRINTF("\"ACChargePower_W\":%.1f,", s->ac_charge_power_w);
  DEBUG_PRINTF("\"EacToday_kWh\":%.1f,", s->eac_today_kwh);
  DEBUG_PRINTF("\"EAChargeToday_kWh\":%.1f,", s->ea_charge_today_kwh);
  DEBUG_PRINTF("\"ACChargePower_SPA_W\":%.1f,", s->ac_charge_power_spa_w);
  DEBUG_PRINTF("\"PVEnergyToday_kWh\":%.1f,", s->pv_energy_today_kwh);
  DEBUG_PRINTF("\"PVPower_W\":%.1f,", s->pv_power_w);
  DEBUG_PRINTF("\"PowerToUser_W\":%.1f,", s->power_to_user_w);
  DEBUG_PRINTF("\"HomeLoadPower_W\":%.1f", s->home_load_power_w);
  DEBUG_PRINTLN("}");
}
