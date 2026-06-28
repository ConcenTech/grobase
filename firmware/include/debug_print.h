#ifndef DEBUG_PRINT_H
#define DEBUG_PRINT_H

#ifndef DEBUG_MODE
#define DEBUG_MODE 0
#endif

#if DEBUG_MODE
  #include <Arduino.h>

  #define DEBUG_PRINT(...)   Serial.print(__VA_ARGS__)
  #define DEBUG_PRINTLN(...) Serial.println(__VA_ARGS__)
  #define DEBUG_PRINTF(...)  Serial.printf(__VA_ARGS__)
#else
  #define DEBUG_PRINT(...)   do {} while (0)
  #define DEBUG_PRINTLN(...) do {} while (0)
  #define DEBUG_PRINTF(...)  do {} while (0)
#endif

#endif // DEBUG_PRINT_H
