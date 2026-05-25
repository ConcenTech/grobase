// Pure C++ Modbus core utilities (CRC and response parsing).
#pragma once

#include <cstddef>
#include <cstdint>
#include <vector>

// Compute Modbus RTU CRC-16 (poly 0xA001), initial 0xFFFF.
uint16_t crc16_modbus(const uint8_t *data, size_t len);

// Parse a Modbus Read Holding Registers (0x03/0x04) response frame.
// resp: pointer to response buffer, len: total length
// slave: expected slave id, func: expected function code (e.g. 0x04)
// outRegs: filled with decoded 16-bit register values on success
// Returns true on valid frame and CRC, false otherwise.
bool parse_modbus_response(const uint8_t *resp, size_t len, uint8_t slave, uint8_t func, std::vector<uint16_t> &outRegs);
