#include "status_led.h"

#ifndef LED_BUILTIN
#define LED_BUILTIN 2
#endif

enum class LedMode { Off, Status, Fault };

static int g_pin = LED_BUILTIN;
static LedMode g_mode = LedMode::Off;
static uint8_t g_count = 0; // blinks per sequence
static uint8_t g_index = 0; // current blink index
static uint32_t g_phaseStart = 0;
static bool g_ledOn = false;

// Timing constants (ms)
static const uint32_t LONG_ON = 500;
static const uint32_t LONG_OFF = 300;
static const uint32_t SHORT_ON = 150;
static const uint32_t SHORT_OFF = 150;
static const uint32_t SEQUENCE_PAUSE = 2000;

void status_led_init(int pin) {
  g_pin = pin;
  pinMode(g_pin, OUTPUT);
  digitalWrite(g_pin, LOW);
  g_mode = LedMode::Off;
  g_count = 0;
  g_index = 0;
  g_phaseStart = millis();
  g_ledOn = false;
}

void status_led_set_status(uint8_t count) {
  if (count == 0) {
    status_led_clear();
    return;
  }
  g_mode = LedMode::Status;
  g_count = count;
  g_index = 0;
  g_phaseStart = millis();
  g_ledOn = false;
}

void status_led_set_fault(uint8_t count) {
  if (count == 0) {
    status_led_clear();
    return;
  }
  g_mode = LedMode::Fault;
  g_count = count;
  g_index = 0;
  g_phaseStart = millis();
  g_ledOn = false;
}

void status_led_clear() {
  g_mode = LedMode::Off;
  g_count = 0;
  g_index = 0;
  g_ledOn = false;
  digitalWrite(g_pin, LOW);
}

void status_led_poll() {
  uint32_t now = millis();
  if (g_mode == LedMode::Off || g_count == 0) {
    return;
  }

  if (g_mode == LedMode::Status) {
    // Long blink sequence
    if (!g_ledOn) {
      // Currently off; determine if we should turn on for next blink
      uint32_t elapsed = now - g_phaseStart;
      if (g_index < g_count) {
        // within blink sequence: wait LONG_OFF then turn on
        if (elapsed >= LONG_OFF) {
          digitalWrite(g_pin, HIGH);
          g_ledOn = true;
          g_phaseStart = now;
        }
      } else {
        // between sequences: wait pause then reset
        if (elapsed >= SEQUENCE_PAUSE) {
          g_index = 0;
          g_phaseStart = now;
        }
      }
    } else {
      // LED is on; turn off after LONG_ON and advance
      if (now - g_phaseStart >= LONG_ON) {
        digitalWrite(g_pin, LOW);
        g_ledOn = false;
        g_index++;
        g_phaseStart = now;
      }
    }
  } else if (g_mode == LedMode::Fault) {
    // Short blink sequence
    if (!g_ledOn) {
      uint32_t elapsed = now - g_phaseStart;
      if (g_index < g_count) {
        if (elapsed >= SHORT_OFF) {
          digitalWrite(g_pin, HIGH);
          g_ledOn = true;
          g_phaseStart = now;
        }
      } else {
        if (elapsed >= SEQUENCE_PAUSE) {
          g_index = 0;
          g_phaseStart = now;
        }
      }
    } else {
      if (now - g_phaseStart >= SHORT_ON) {
        digitalWrite(g_pin, LOW);
        g_ledOn = false;
        g_index++;
        g_phaseStart = now;
      }
    }
  }
}
