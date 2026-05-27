#include <unity.h>

#include "status_led.h"

void setUp(void) {
  status_led_test_set_millis(0);
  status_led_init(2);
  status_led_clear();
}

void tearDown(void) {
  status_led_clear();
}

static void advance(uint32_t value) {
  status_led_test_set_millis(value);
  status_led_poll();
}

void test_status_led_status_pattern_repeats() {
  status_led_set_status(2);

  advance(0);
  TEST_ASSERT_EQUAL(StatusLedMode::Status, status_led_test_mode());
  TEST_ASSERT_EQUAL_UINT8(2, status_led_test_count());
  TEST_ASSERT_TRUE(status_led_test_is_on());

  advance(499);
  TEST_ASSERT_TRUE(status_led_test_is_on());

  advance(500);
  TEST_ASSERT_FALSE(status_led_test_is_on());

  advance(799);
  TEST_ASSERT_FALSE(status_led_test_is_on());

  advance(800);
  TEST_ASSERT_TRUE(status_led_test_is_on());

  advance(1299);
  TEST_ASSERT_TRUE(status_led_test_is_on());

  advance(1300);
  TEST_ASSERT_FALSE(status_led_test_is_on());

  advance(3299);
  TEST_ASSERT_FALSE(status_led_test_is_on());

  advance(3300);
  TEST_ASSERT_TRUE(status_led_test_is_on());
}

void test_status_led_fault_overrides_status_and_restores_status_on_clear() {
  status_led_set_status(3);
  advance(0);
  TEST_ASSERT_EQUAL(StatusLedMode::Status, status_led_test_mode());
  TEST_ASSERT_TRUE(status_led_test_is_on());

  status_led_set_fault(4);
  advance(0);
  TEST_ASSERT_EQUAL(StatusLedMode::Fault, status_led_test_mode());
  TEST_ASSERT_EQUAL_UINT8(4, status_led_test_count());
  TEST_ASSERT_TRUE(status_led_test_is_on());

  advance(150);
  TEST_ASSERT_FALSE(status_led_test_is_on());

  advance(300);
  TEST_ASSERT_TRUE(status_led_test_is_on());

  status_led_set_fault(0);
  advance(300);
  TEST_ASSERT_EQUAL(StatusLedMode::Status, status_led_test_mode());
  TEST_ASSERT_TRUE(status_led_test_is_on());
}

void test_status_led_repeated_set_status_is_idempotent() {
  status_led_set_status(3);
  advance(0);
  TEST_ASSERT_TRUE(status_led_test_is_on());

  advance(250);
  status_led_set_status(3);
  advance(250);
  TEST_ASSERT_FALSE(status_led_test_is_on());

  advance(799);
  TEST_ASSERT_FALSE(status_led_test_is_on());

  advance(800);
  TEST_ASSERT_TRUE(status_led_test_is_on());
}

int main(int argc, char **argv) {
  UNITY_BEGIN();

  RUN_TEST(test_status_led_status_pattern_repeats);
  RUN_TEST(test_status_led_fault_overrides_status_and_restores_status_on_clear);
  RUN_TEST(test_status_led_repeated_set_status_is_idempotent);

  return UNITY_END();
}
