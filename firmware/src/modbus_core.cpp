#include "modbus_core.h"

#include <cstdint>
#include <cstddef>

uint16_t crc16_modbus(const uint8_t *data, size_t len) {
  uint16_t crc = 0xFFFF;
  for (size_t i = 0; i < len; i++) {
    crc ^= data[i];
    for (uint8_t b = 0; b < 8; b++) {
      if (crc & 0x0001) {
        crc >>= 1;
        crc ^= 0xA001;
      } else {
        crc >>= 1;
      }
    }
  }
  return crc;
}

bool parse_modbus_response(const uint8_t *resp, size_t len, uint8_t slave, uint8_t func, std::vector<uint16_t> &outRegs) {
  if (len < 5) return false; // minimum size
  if (resp[0] != slave) return false;
  if (resp[1] == (func | 0x80)) return false; // exception
  if (resp[1] != func) return false;
  uint8_t byteCount = resp[2];
  size_t expectedLen = 3 + byteCount + 2;
  if (len != expectedLen) return false;

  uint16_t rxCrc = ((uint16_t)resp[len - 1] << 8) | resp[len - 2];
  uint16_t calcCrc = crc16_modbus(resp, len - 2);
  if (rxCrc != calcCrc) return false;

  if (byteCount % 2 != 0) return false;
  size_t regs = byteCount / 2;
  outRegs.resize(regs);
  for (size_t i = 0; i < regs; ++i) {
    uint8_t hi = resp[3 + (i * 2)];
    uint8_t lo = resp[3 + (i * 2) + 1];
    outRegs[i] = ((uint16_t)hi << 8) | lo;
  }
  return true;
}
