// Snapshot JSON printer plus a compatibility wrapper around the
// profile-specific register decoder.
#include "inverter_snapshot.h"
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
  Serial.print("{");
  Serial.printf("\"modbus_ok\":%s,", s->modbus_ok ? "true" : "false");
  Serial.printf("\"BatteryDischargePower_W\":%.1f,", s->battery_discharge_power_w);
  Serial.printf("\"BatteryChargePower_W\":%.1f,", s->battery_charge_power_w);
  Serial.printf("\"Vbat\":%.1f,", s->vbat);
  Serial.printf("\"Vbat_DSP\":%.1f,", s->vbat_dsp);
  Serial.printf("\"SOC_1014\":%.0f,", s->soc_1014);
  Serial.printf("\"BMS_SOC\":%.0f,", s->bms_soc);
  Serial.printf("\"BMS_BatteryVolt\":%.1f,", s->bms_battery_volt);
  Serial.printf("\"BMS_BatteryCurr\":%.1f,", s->bms_battery_curr);
  Serial.printf("\"BatteryDischargeEnergyToday_kWh\":%.1f,", s->battery_discharge_energy_today_kwh);
  Serial.printf("\"BatteryChargeEnergyToday_kWh\":%.1f,", s->battery_charge_energy_today_kwh);
  Serial.printf("\"GridPac_W\":%.1f,", s->grid_pac_w);
  Serial.printf("\"GridFrequency_Hz\":%.2f,", s->grid_frequency_hz);
  Serial.printf("\"GridVoltage_V\":%.1f,", s->grid_voltage_v);
  Serial.printf("\"GridCurrent_A\":%.1f,", s->grid_current_a);
  Serial.printf("\"PowerToGrid_W\":%.1f,", s->power_to_grid_w);
  Serial.printf("\"EnergyToGridToday_kWh\":%.1f,", s->energy_to_grid_today_kwh);
  Serial.printf("\"ACChargeEnergyToday_kWh\":%.1f,", s->ac_charge_energy_today_kwh);
  Serial.printf("\"ACChargePower_W\":%.1f,", s->ac_charge_power_w);
  Serial.printf("\"EacToday_kWh\":%.1f,", s->eac_today_kwh);
  Serial.printf("\"EAChargeToday_kWh\":%.1f,", s->ea_charge_today_kwh);
  Serial.printf("\"ACChargePower_SPA_W\":%.1f,", s->ac_charge_power_spa_w);
  Serial.printf("\"PVEnergyToday_kWh\":%.1f,", s->pv_energy_today_kwh);
  Serial.printf("\"PowerToUser_W\":%.1f,", s->power_to_user_w);
  Serial.printf("\"LocalLoadPower_W\":%.1f", s->local_load_power_w);
  Serial.println("}");
}
