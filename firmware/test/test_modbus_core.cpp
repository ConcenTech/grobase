#include <unity.h>

#include "modbus_core.h"

void setUp(void) {
}

void tearDown(void) {
}

void test_modbus_core_crc_and_parse_valid_frame() {
  const uint8_t slave = 1;
  const uint8_t func = 0x04;
  const uint16_t regs[] = {0x0001, 0x0002};

  std::vector<uint8_t> frame;
  frame.push_back(slave);
  frame.push_back(func);
  frame.push_back(sizeof(regs));
  for (uint16_t reg : regs) {
    frame.push_back((uint8_t)(reg >> 8));
    frame.push_back((uint8_t)(reg & 0xFF));
  }

  uint16_t crc = crc16_modbus(frame.data(), frame.size());
  frame.push_back((uint8_t)(crc & 0xFF));
  frame.push_back((uint8_t)((crc >> 8) & 0xFF));

  std::vector<uint16_t> decoded;
  TEST_ASSERT_TRUE(parse_modbus_response(frame.data(), frame.size(), slave, func, decoded));
  TEST_ASSERT_EQUAL_UINT16_ARRAY(regs, decoded.data(), 2);
}

void test_modbus_core_rejects_corrupted_crc() {
  const uint8_t slave = 1;
  const uint8_t func = 0x04;
  const uint16_t regs[] = {0x1234};

  std::vector<uint8_t> frame;
  frame.push_back(slave);
  frame.push_back(func);
  frame.push_back(sizeof(regs));
  frame.push_back((uint8_t)(regs[0] >> 8));
  frame.push_back((uint8_t)(regs[0] & 0xFF));

  uint16_t crc = crc16_modbus(frame.data(), frame.size());
  frame.push_back((uint8_t)(crc & 0xFF));
  frame.push_back((uint8_t)((crc >> 8) & 0xFF));
  frame[4] ^= 0xFF;

  std::vector<uint16_t> decoded;
  TEST_ASSERT_FALSE(parse_modbus_response(frame.data(), frame.size(), slave, func, decoded));
}

void test_modbus_core_rejects_exception_frame() {
  const uint8_t slave = 1;
  const uint8_t func = 0x04;

  std::vector<uint8_t> frame = {slave, (uint8_t)(func | 0x80), 0x02};
  uint16_t crc = crc16_modbus(frame.data(), frame.size());
  frame.push_back((uint8_t)(crc & 0xFF));
  frame.push_back((uint8_t)((crc >> 8) & 0xFF));

  std::vector<uint16_t> decoded;
  TEST_ASSERT_FALSE(parse_modbus_response(frame.data(), frame.size(), slave, func, decoded));
}

void test_modbus_core_sn_read_request_frame() {
  // Growatt SPA serial number: FC 0x03, holding regs 23-27 (doc "#" = PDU address).
  const uint8_t req[] = {0x01, 0x03, 0x00, 0x17, 0x00, 0x05};
  const uint16_t crc = crc16_modbus(req, sizeof(req));
  TEST_ASSERT_EQUAL_HEX16(0xCD35, crc);
}

int main(int argc, char **argv) {
  UNITY_BEGIN();

  RUN_TEST(test_modbus_core_crc_and_parse_valid_frame);
  RUN_TEST(test_modbus_core_rejects_corrupted_crc);
  RUN_TEST(test_modbus_core_rejects_exception_frame);
  RUN_TEST(test_modbus_core_sn_read_request_frame);

  return UNITY_END();
}
