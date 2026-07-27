// Growatt profile decoding: maps register tables into an InverterSnapshot.

#include "profile_growatt.h"

static uint16_t regAt(uint16_t tableStartReg, const uint16_t *buf, uint16_t tableReg) {
  return buf[tableReg - tableStartReg];
}

static float u16_scaled(uint16_t v, float scale) {
  // Growatt uses 0xFFFF as an unavailable/invalid sentinel.
  if (v == SENTINEL_VALUE) return 0.0f;
  return (float)v * scale;
}

static float i16_scaled(uint16_t v, float scale) {
  return (float)(int16_t)v * scale;
}

static float u32_scaled(uint16_t hi, uint16_t lo, float scale) {
  // All-ones (0xFFFF/0xFFFF) is an unavailable sentinel; do not decode as
  // UINT32_MAX * scale (float32 → ~429496736).
  if (hi == SENTINEL_VALUE && lo == SENTINEL_VALUE) return 0.0f;
  uint32_t v = ((uint32_t)hi << 16) | lo;
  return (float)v * scale;
}

static float i32_scaled(uint16_t hi, uint16_t lo, float scale) {
  int32_t v = (int32_t)(((uint32_t)hi << 16) | lo);
  return (float)v * scale;
}

void profileGrowattFill(InverterSnapshot *out,
            const uint16_t *r1009,
            const uint16_t *r1086,
            const uint16_t *r1124,
            const uint16_t *r2035,
            const uint16_t *r2097,
            const uint16_t *r2112) {
  static const uint16_t R1009_START = 1009;
  static const uint16_t R1086_START = 1086;
  static const uint16_t R1124_START = 1124;
  static const uint16_t R2035_START = 2035;
  static const uint16_t R2097_START = 2097;
  static const uint16_t R2112_START = 2112;

  out->modbus_ok = true;

  out->battery_discharge_power_w =
    u32_scaled(regAt(R1009_START, r1009, 1009), regAt(R1009_START, r1009, 1010), 0.1f);
  out->battery_charge_power_w =
    u32_scaled(regAt(R1009_START, r1009, 1011), regAt(R1009_START, r1009, 1012), 0.1f);
  out->vbat = u16_scaled(regAt(R1009_START, r1009, 1013), 0.1f);
  out->soc_1014 = u16_scaled(regAt(R1009_START, r1009, 1014), 1.0f);
  out->bms_soc = u16_scaled(regAt(R1086_START, r1086, 1086), 1.0f);
  // Protocol leaves BMS V/I units blank; live SPA data matches 0.01 V and
  // signed 0.01 A (e.g. 5300 → 53.0 V, 0xFE46 → -4.5 A).
  out->bms_battery_volt = u16_scaled(regAt(R1086_START, r1086, 1087), 0.01f);
  out->bms_battery_curr = i16_scaled(regAt(R1086_START, r1086, 1088), 0.01f);
  out->vbat_dsp = u16_scaled(regAt(R2097_START, r2097, 2097), 0.1f);

  out->battery_discharge_energy_today_kwh =
    u32_scaled(regAt(R1009_START, r1009, 1052), regAt(R1009_START, r1009, 1053), 0.1f);
  out->battery_charge_energy_today_kwh =
    u32_scaled(regAt(R1009_START, r1009, 1056), regAt(R1009_START, r1009, 1057), 0.1f);

  // Pac is signed (OIG SIZE_32BIT_S); negative observed on live SPA imports.
  out->grid_pac_w =
    i32_scaled(regAt(R2035_START, r2035, 2035), regAt(R2035_START, r2035, 2036), 0.1f);
  out->grid_frequency_hz = u16_scaled(regAt(R2035_START, r2035, 2037), 0.01f);
  out->grid_voltage_v = u16_scaled(regAt(R2035_START, r2035, 2038), 0.1f);
  out->grid_current_a = u16_scaled(regAt(R2035_START, r2035, 2039), 0.1f);
  out->power_to_grid_w =
    u32_scaled(regAt(R1009_START, r1009, 1029), regAt(R1009_START, r1009, 1030), 0.1f);

  out->energy_to_grid_today_kwh =
    u32_scaled(regAt(R1009_START, r1009, 1048), regAt(R1009_START, r1009, 1049), 0.1f);
  // Doc unit is "kwh" without 0.1; live 70 vs EACharge 7 implies 0.1 kWh scale.
  out->ac_charge_energy_today_kwh =
    u32_scaled(regAt(R1124_START, r1124, 1124), regAt(R1124_START, r1124, 1125), 0.1f);
  out->ac_charge_power_w =
    u32_scaled(regAt(R1124_START, r1124, 1128), regAt(R1124_START, r1124, 1129), 1.0f);
  out->eac_today_kwh =
    u32_scaled(regAt(R2035_START, r2035, 2053), regAt(R2035_START, r2035, 2054), 0.1f);
  out->ea_charge_today_kwh =
    u32_scaled(regAt(R2112_START, r2112, 2112), regAt(R2112_START, r2112, 2113), 0.1f);
  out->ac_charge_power_spa_w =
    u32_scaled(regAt(R2112_START, r2112, 2116), regAt(R2112_START, r2112, 2117), 1.0f);

  // SPA: "Today generate energy" (2053-2054), not EPVAll_Today (1149-1150).
  out->pv_energy_today_kwh = out->eac_today_kwh;
  // SPA CT2: ExtraACPower from the connected PV inverter.
  // Live dumps: 1131–1132 stay 0; 2102–2103 carry the real value (same doc name).
  out->pv_power_w =
    u32_scaled(regAt(R2097_START, r2097, 2102), regAt(R2097_START, r2097, 2103), 0.1f);

  out->power_to_user_w =
    u32_scaled(regAt(R1009_START, r1009, 1021), regAt(R1009_START, r1009, 1022), 0.1f);
  // House load: matches solar + import − export − charge + discharge on live SPA.
  // PSystem (1145–46) is not house load (tracks PV when exporting).
  out->home_load_power_w =
    u32_scaled(regAt(R1009_START, r1009, 1037), regAt(R1009_START, r1009, 1038), 0.1f);
}
