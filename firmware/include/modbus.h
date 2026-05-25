
#pragma once

#// Modbus RTU helper API (request framing, CRC, chunked reads).
#// Implementations live in `src/modbus.cpp`. This module exposes
#// an init function plus read helpers used by the main firmware.

#include <Arduino.h>

// Initialize Modbus serial and related state. Call once from `setup()`.
void modbusInit();

uint16_t crc16_modbus(const uint8_t *data, size_t len);

bool readRegisters04(uint8_t slave, uint16_t startReg, uint16_t count, uint16_t *outRegs);

bool readRange04Chunked(uint16_t pduStartReg, uint16_t count, uint16_t *outRegs);

bool readAppRegisters(uint16_t *r1009,
                      uint16_t *r1086,
                      uint16_t *r1124,
                      uint16_t *r2035,
                      uint16_t *r2097,
                      uint16_t *r2112);
