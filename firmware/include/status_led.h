#pragma once

// Non-blocking status LED helper.
// Provides long blink "status" patterns and short blink "fault" patterns.

#include <Arduino.h>

void status_led_init(int pin);
// Set status pattern (long blinks). Pass count (1..6). 0 = off.
void status_led_set_status(uint8_t count);
// Set fault pattern (short blinks). Pass count (2..6). 0 = clear fault.
void status_led_set_fault(uint8_t count);
// Clear any status or fault and turn LED off.
void status_led_clear();
// Poll the LED state machine (call frequently from loop()).
void status_led_poll();
