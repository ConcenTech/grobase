#include "status_led.h"

#ifndef LED_BUILTIN
#define LED_BUILTIN 2
#endif

namespace {

enum class LedMode { Off, Status, Fault };

static int g_pin = LED_BUILTIN;
static uint8_t g_statusCount = 0;
static uint8_t g_faultCount = 0;
static LedMode g_activeMode = LedMode::Off;
static uint8_t g_activeCount = 0;
static uint8_t g_remainingBlinks = 0;
static bool g_ledOn = false;
static uint32_t g_phaseStartMs = 0;
static uint32_t g_testNowMs = 0;
static bool g_useTestNow = false;

static const uint32_t LONG_ON_MS = 500;
static const uint32_t LONG_OFF_MS = 300;
static const uint32_t SHORT_ON_MS = 150;
static const uint32_t SHORT_OFF_MS = 150;
static const uint32_t SEQUENCE_PAUSE_MS = 2000;

static uint32_t nowMs() {
  return g_useTestNow ? g_testNowMs : millis();
}

static void writeLed(bool on) {
  g_ledOn = on;
  digitalWrite(g_pin, on ? HIGH : LOW);
}

static LedMode requestedMode() {
  if (g_faultCount > 0) {
    return LedMode::Fault;
  }
  if (g_statusCount > 0) {
    return LedMode::Status;
  }
  return LedMode::Off;
}

static uint8_t requestedCount(LedMode mode) {
  switch (mode) {
    case LedMode::Fault:
      return g_faultCount;
    case LedMode::Status:
      return g_statusCount;
    case LedMode::Off:
    default:
      return 0;
  }
}

static uint32_t onDuration(LedMode mode) {
  return mode == LedMode::Fault ? SHORT_ON_MS : LONG_ON_MS;
}

static uint32_t offDuration(LedMode mode) {
  return mode == LedMode::Fault ? SHORT_OFF_MS : LONG_OFF_MS;
}

static void resetActivePattern(LedMode mode, uint8_t count, uint32_t now) {
  g_activeMode = mode;
  g_activeCount = count;
  g_remainingBlinks = count;
  g_phaseStartMs = now;
  if (mode == LedMode::Off || count == 0) {
    writeLed(false);
    g_activeMode = LedMode::Off;
    g_activeCount = 0;
    g_remainingBlinks = 0;
    return;
  }

  // Start a new sequence immediately with the LED on.
  writeLed(true);
}

static void syncActivePattern(uint32_t now) {
  LedMode desiredMode = requestedMode();
  uint8_t desiredCount = requestedCount(desiredMode);

  if (desiredMode != g_activeMode || desiredCount != g_activeCount) {
    resetActivePattern(desiredMode, desiredCount, now);
  }

  if (g_activeMode == LedMode::Off || g_activeCount == 0) {
    writeLed(false);
    return;
  }

  if (g_remainingBlinks == 0) {
    // Pause between sequences, then restart.
    if ((now - g_phaseStartMs) >= SEQUENCE_PAUSE_MS) {
      resetActivePattern(g_activeMode, g_activeCount, now);
    }
    return;
  }

  const uint32_t elapsed = now - g_phaseStartMs;
  if (g_ledOn) {
    if (elapsed >= onDuration(g_activeMode)) {
      writeLed(false);
      g_remainingBlinks--;
      g_phaseStartMs = now;
      if (g_remainingBlinks == 0) {
        // Finished current sequence; pause before restarting.
        return;
      }
    }
  } else {
    if (elapsed >= offDuration(g_activeMode)) {
      writeLed(true);
      g_phaseStartMs = now;
    }
  }
}

}  // namespace

void status_led_init(int pin) {
  g_pin = pin;
  pinMode(g_pin, OUTPUT);
  writeLed(false);
  g_statusCount = 0;
  g_faultCount = 0;
  g_activeMode = LedMode::Off;
  g_activeCount = 0;
  g_remainingBlinks = 0;
  g_phaseStartMs = nowMs();
}

void status_led_set_status(uint8_t count) {
  if (count == 0) {
    g_statusCount = 0;
    if (g_faultCount == 0) {
      g_activeMode = LedMode::Off;
      g_activeCount = 0;
      g_remainingBlinks = 0;
      writeLed(false);
    }
    return;
  }

  if (g_statusCount == count) {
    return;
  }

  g_statusCount = count;
  if (g_faultCount == 0) {
    resetActivePattern(LedMode::Status, g_statusCount, nowMs());
  }
}

void status_led_set_fault(uint8_t count) {
  if (count == 0) {
    g_faultCount = 0;
    if (g_statusCount > 0) {
      resetActivePattern(LedMode::Status, g_statusCount, nowMs());
    } else {
      status_led_clear();
    }
    return;
  }

  if (g_faultCount == count) {
    return;
  }

  g_faultCount = count;
  resetActivePattern(LedMode::Fault, g_faultCount, nowMs());
}

void status_led_clear() {
  g_statusCount = 0;
  g_faultCount = 0;
  g_activeMode = LedMode::Off;
  g_activeCount = 0;
  g_remainingBlinks = 0;
  g_phaseStartMs = nowMs();
  writeLed(false);
}

void status_led_poll() {
  syncActivePattern(nowMs());
}

#ifdef UNIT_TEST
void status_led_test_set_millis(uint32_t value) {
  g_useTestNow = true;
  g_testNowMs = value;
}

StatusLedMode status_led_test_mode() {
  switch (g_activeMode) {
    case LedMode::Status:
      return StatusLedMode::Status;
    case LedMode::Fault:
      return StatusLedMode::Fault;
    case LedMode::Off:
    default:
      return StatusLedMode::Off;
  }
}

uint8_t status_led_test_count() {
  return g_activeCount;
}

bool status_led_test_is_on() {
  return g_ledOn;
}
#endif
