// Example Modbus register tables for bench testing without an inverter.
// Values match firmware/test/test_profile_growatt.cpp so snapshot decoding
// produces known, realistic readings.

#include "modbus_mock.h"

void modbusMockFillAppRegisters(uint16_t *r1009,
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
  r1009[1022 - 1009] = 0x0190; // 40.0 W
  r1009[1029 - 1009] = 0x0000;
  r1009[1030 - 1009] = 0x00FA; // 25.0 W
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
  r1086[2] = 123;

  r1124[1124 - 1124] = 0x0000;
  r1124[1125 - 1124] = 0x000A;
  r1124[1128 - 1124] = 0x0000;
  r1124[1129 - 1124] = 0x0014;
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

void modbusMockFillSerialNumberRegisters(uint16_t regs[5]) {
  const char *sn = MODBUS_MOCK_SERIAL_NUMBER;
  for (int i = 0; i < 5; ++i) {
    char hi = sn[i * 2] ? sn[i * 2] : ' ';
    char lo = sn[i * 2 + 1] ? sn[i * 2 + 1] : ' ';
    regs[i] = ((uint16_t)(uint8_t)hi << 8) | (uint8_t)lo;
  }
}
