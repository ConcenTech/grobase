#include <unity.h>

#include "../src/profile_growatt.cpp"

void setUp(void) {
}

void tearDown(void) {
}

static void fill_sample_tables(uint16_t *r1009,
                               uint16_t *r1086,
                               uint16_t *r1124,
                               uint16_t *r2035,
                               uint16_t *r2097,
                               uint16_t *r2112) {
  for (int i = 0; i < 51; ++i) r1009[i] = 0;
  for (int i = 0; i < 3; ++i) r1086[i] = 0;
  for (int i = 0; i < 27; ++i) r1124[i] = 0;
  for (int i = 0; i < 20; ++i) r2035[i] = 0;
  for (int i = 0; i < 1; ++i) r2097[i] = 0;
  for (int i = 0; i < 6; ++i) r2112[i] = 0;

  r1009[1009 - 1009] = 0x0000;
  r1009[1010 - 1009] = 0x0064; // 10.0 W
  r1009[1011 - 1009] = 0x0000;
  r1009[1012 - 1009] = 0x00C8; // 20.0 W
  r1009[1013 - 1009] = 0x00FA; // 25.0 V
  r1009[1014 - 1009] = 0x0032; // 50 %
  r1009[1021 - 1009] = 0x0000;
  r1009[1022 - 1009] = 0x0190; // 40.0 W import
  r1009[1029 - 1009] = 0x0000;
  r1009[1030 - 1009] = 0x00FA; // 25.0 W export
  r1009[1037 - 1009] = 0x0000;
  r1009[1038 - 1009] = 0x01F4; // 50.0 W
  r1009[1048 - 1009] = 0x0000;
  r1009[1049 - 1009] = 0x012C; // 30.0 kWh
  r1009[1052 - 1009] = 0x0000;
  r1009[1053 - 1009] = 0x00C8; // 20.0 kWh
  r1009[1056 - 1009] = 0x0000;
  r1009[1057 - 1009] = 0x0064; // 10.0 kWh

  r1086[0] = 80;
  r1086[1] = 260;
  // -3.30 A as int16 (0xFECE), scale 0.01 A
  r1086[2] = (uint16_t)(int16_t)(-330);

  r1124[1124 - 1124] = 0x0000;
  r1124[1125 - 1124] = 0x000A;
  r1124[1128 - 1124] = 0x0000;
  r1124[1129 - 1124] = 0x0014;
  r1124[1131 - 1124] = 0x0000;
  r1124[1132 - 1124] = 0x2710; // 1000.0 W Extra AC / solar
  r1124[1133 - 1124] = 0x0000;
  r1124[1134 - 1124] = 0x0078; // 12.0 kWh Eextra today
  r1124[1149 - 1124] = 0x0000;
  r1124[1150 - 1124] = 0x001E;

  r2035[2035 - 2035] = 0x0000;
  r2035[2036 - 2035] = 0x03E8; // 100.0 W
  r2035[2037 - 2035] = 5000;    // 50.00 Hz
  r2035[2038 - 2035] = 2300;    // 230.0 V
  r2035[2039 - 2035] = 123;     // 12.3 A
  r2035[2053 - 2035] = 0x0000;
  r2035[2054 - 2035] = 0x0064;  // 10.0 kWh

  r2097[0] = 251; // 25.1 V

  r2112[2112 - 2112] = 0x0000;
  r2112[2113 - 2112] = 0x004D;  // 7.7 kWh
  r2112[2116 - 2112] = 0x0000;
  r2112[2117 - 2112] = 0x03E8;  // 1000 W
}

void test_profile_growatt_fill_maps_expected_fields() {
  uint16_t r1009[51];
  uint16_t r1086[3];
  uint16_t r1124[27];
  uint16_t r2035[20];
  uint16_t r2097[1];
  uint16_t r2112[6];
  fill_sample_tables(r1009, r1086, r1124, r2035, r2097, r2112);

  InverterSnapshot snapshot = {};
  profileGrowattFill(&snapshot, r1009, r1086, r1124, r2035, r2097, r2112);

  TEST_ASSERT_TRUE(snapshot.modbus_ok);
  TEST_ASSERT_EQUAL_FLOAT(10.0f, snapshot.battery_discharge_power_w);
  TEST_ASSERT_EQUAL_FLOAT(20.0f, snapshot.battery_charge_power_w);
  TEST_ASSERT_EQUAL_FLOAT(25.0f, snapshot.vbat);
  TEST_ASSERT_EQUAL_FLOAT(50.0f, snapshot.soc_1014);
  TEST_ASSERT_EQUAL_FLOAT(80.0f, snapshot.bms_soc);
  TEST_ASSERT_EQUAL_FLOAT(26.0f, snapshot.bms_battery_volt);
  TEST_ASSERT_EQUAL_FLOAT(-3.3f, snapshot.bms_battery_curr);
  TEST_ASSERT_EQUAL_FLOAT(25.1f, snapshot.vbat_dsp);
  TEST_ASSERT_EQUAL_FLOAT(40.0f, snapshot.power_to_user_w);
  TEST_ASSERT_EQUAL_FLOAT(50.0f, snapshot.local_load_power_w);
  TEST_ASSERT_EQUAL_FLOAT(100.0f, snapshot.grid_pac_w);
  TEST_ASSERT_EQUAL_FLOAT(50.00f, snapshot.grid_frequency_hz);
  TEST_ASSERT_EQUAL_FLOAT(230.0f, snapshot.grid_voltage_v);
  TEST_ASSERT_EQUAL_FLOAT(12.3f, snapshot.grid_current_a);
  TEST_ASSERT_EQUAL_FLOAT(10.0f, snapshot.eac_today_kwh);
  TEST_ASSERT_EQUAL_FLOAT(1000.0f, snapshot.extra_ac_power_w);
  TEST_ASSERT_EQUAL_FLOAT(12.0f, snapshot.eextra_today_kwh);
  TEST_ASSERT_EQUAL_FLOAT(12.0f, snapshot.pv_energy_today_kwh);
  TEST_ASSERT_EQUAL_FLOAT(7.7f, snapshot.ea_charge_today_kwh);
  TEST_ASSERT_EQUAL_FLOAT(1000.0f, snapshot.ac_charge_power_spa_w);
}

void test_profile_growatt_signed_pac_does_not_underflow() {
  uint16_t r1009[51];
  uint16_t r1086[3];
  uint16_t r1124[27];
  uint16_t r2035[20];
  uint16_t r2097[1];
  uint16_t r2112[6];
  fill_sample_tables(r1009, r1086, r1124, r2035, r2097, r2112);

  // -1000.0 W as int32 @ 0.1 W → raw -10000 = 0xFFFFD8F0
  r2035[2035 - 2035] = 0xFFFF;
  r2035[2036 - 2035] = 0xD8F0;

  InverterSnapshot snapshot = {};
  profileGrowattFill(&snapshot, r1009, r1086, r1124, r2035, r2097, r2112);

  TEST_ASSERT_EQUAL_FLOAT(-1000.0f, snapshot.grid_pac_w);
}

int main(int argc, char **argv) {
  UNITY_BEGIN();

  RUN_TEST(test_profile_growatt_fill_maps_expected_fields);
  RUN_TEST(test_profile_growatt_signed_pac_does_not_underflow);

  return UNITY_END();
}
