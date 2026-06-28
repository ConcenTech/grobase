#include "status_led.h"

#ifndef LED_BUILTIN
#define LED_BUILTIN 2
#endif

namespace {
const int LED_PIN = LED_BUILTIN;
// 1. Core Blink Function placed at the top so long/short can see it
void blink(int count, int ms) {

  static const uint32_t SEQUENCE_PAUSE_MS = 1000;

  for (int i = 0; i < count; i++) {
    digitalWrite(LED_PIN, HIGH);
    vTaskDelay(pdMS_TO_TICKS(ms));
    digitalWrite(LED_PIN, LOW);

    if (i < count - 1) {
      vTaskDelay(pdMS_TO_TICKS(ms));
    } else {
      vTaskDelay(pdMS_TO_TICKS(SEQUENCE_PAUSE_MS));
    }
  }
}

void longBlink(int count) {
  static const uint32_t LONG_BLINK_MS = 500;
  blink(count, LONG_BLINK_MS);
}

void shortBlink(int count) {
  static const uint32_t SHORT_BLINK_MS = 150;
  blink(count, SHORT_BLINK_MS);
}

// Keep the state variable safely hidden inside the namespace
volatile StatusLed currentState = StatusLed::BOOT;

// 3. The Actual FreeRTOS Task
void ledStatusTask(void *parameter) {
  for (;;) {
    switch (currentState) {
    case StatusLed::BOOT:
      longBlink(2);
      break;
    case StatusLed::SETUP:
      longBlink(3);
      break;
    case StatusLed::WIFI_CONNECTING:
      longBlink(4);
      break;
    case StatusLed::PROVISIONING:
      longBlink(5);
      break;

    case StatusLed::PROVISIONED:
      digitalWrite(LED_PIN, HIGH);
      vTaskDelay(pdMS_TO_TICKS(1000)); // Prevents WDT Crash!
      break;

    case StatusLed::SN_READ_FAILED:
      shortBlink(2);
      break;
    case StatusLed::WIFI_FAILED:
      shortBlink(3);
      break;
    case StatusLed::SN_MISMATCH:
      shortBlink(4);
      break;
    case StatusLed::PROVISION_FAILED:
      shortBlink(5);
      break;
    case StatusLed::CLOUD_UNREACHABLE:
      shortBlink(6);
      break;
    case StatusLed::MODBUS_FAILED:
      shortBlink(7);
      break;
    }
  }
}

} // namespace

void initStatusLed() {
  pinMode(LED_PIN, OUTPUT);
  xTaskCreate(ledStatusTask,   // Function to execute
              "ledStatusTask", // Name of the task
              2048,            // Stack size in words
              NULL,            // Task input parameter
              1,               // Priority of the task
              NULL             // Task handle.
  );
}

// 2. Public Setter Function (This lives outside the namespace)
void setStatusLed(StatusLed newState) { currentState = newState; }