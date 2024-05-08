/**
 * Copyright (c) 2020 Raspberry Pi (Trading) Ltd.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include <stdio.h>
#include "pico/stdlib.h"
#include "pico/multicore.h"
#include "hardware/gpio.h"

#include "joybus.hpp"

int report_counter = 0;
GCReport gc_report = defaultGcReport;

GCReport gen_report() {
    report_counter++;
    return gc_report;
}

void enterModeVeneer() {
    enterMode(0, gen_report);
}

int main() {
    stdio_init_all();

    gpio_init(0);
    gpio_set_dir(0, false);

    gpio_init(9);
    gpio_set_dir(9, false); // drive as tristate

    gpio_init(10);
    gpio_put(10, false);
    gpio_set_dir(10, true); // external transistor

    gpio_init(11);
    gpio_set_dir(11, false); // drive as tristate

    gpio_init(12);
    gpio_set_dir(12, false); // drive as tristate

    multicore_launch_core1(enterModeVeneer);

    while (true) {
      printf("reports: %i\n", report_counter);
      uint16_t ch = getchar_timeout_us(10000);
      if(ch != 0xffff) {
        if(ch == '1') {
          gpio_put(9, true);
          gpio_set_dir(9, true);
          sleep_ms(100);
          gpio_set_dir(9, false);
        }
        if(ch == '2') {
          gpio_put(10, true);
          sleep_ms(100);
          gpio_put(10, false);
        }
        if(ch == '3') {
          gpio_put(11, true);
          gpio_set_dir(11, true);
          sleep_ms(100);
          gpio_set_dir(11, false);
        }
        if(ch == '4') {
          gpio_put(12, true);
          gpio_set_dir(12, true);
          sleep_ms(100);
          gpio_set_dir(12, false);
        }
        if(ch == 'w') {
	  gc_report.dUp = 1;
          sleep_ms(100);
	  gc_report.dUp = 0;
        }
        if(ch == 'a') {
	  gc_report.dLeft = 1;
          sleep_ms(100);
	  gc_report.dLeft = 0;
        }
        if(ch == 's') {
	  gc_report.dDown = 1;
          sleep_ms(100);
	  gc_report.dDown = 0;
        }
        if(ch == 'd') {
	  gc_report.dRight = 1;
          sleep_ms(100);
	  gc_report.dRight = 0;
        }
        if(ch == ' ') {
	  gc_report.start = 1;
          sleep_ms(100);
	  gc_report.start = 0;
        }
      }
      sleep_ms(10);
    }
    return 0;
}
