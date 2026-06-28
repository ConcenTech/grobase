#pragma once

#include <stdint.h>

// Serial number returned when MODBUS_MOCK is enabled. Use this value when
// provisioning the device in mock mode so boot SN check passes.
static const char MODBUS_MOCK_SERIAL_NUMBER[] = "MOCKINV001";

void modbusMockFillAppRegisters(uint16_t *r1009,
                                uint16_t *r1086,
                                uint16_t *r1124,
                                uint16_t *r2035,
                                uint16_t *r2097,
                                uint16_t *r2112);

void modbusMockFillSerialNumberRegisters(uint16_t regs[5]);
