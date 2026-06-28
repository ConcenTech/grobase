#include <unity.h>

#include "status_led.h"

void setUp(void) {
  initStatusLed();
}

void tearDown(void) {
}


int main(int argc, char **argv) {
  UNITY_BEGIN();

  return UNITY_END();
}
