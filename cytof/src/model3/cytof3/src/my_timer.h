/*** my_timer.h
 * This script creates a macro timer for functions.
 * To use this macro, INIT_TIMER; must first be invoked once and only once!
 * Then, TIME_CODE(bool: show_time, string: message, code); will do the trick.
 * If show_time = true, then the timings will show. Otherwise, the times will not show.
 */

#ifndef MY_TIMER_H
#define MY_TIMER_H

#define INIT_TIMER std::clock_t start_time;
#define TIME_CODE(show_timing, s, code) if (show_timings) {start_time = std::clock(); code; print_time(s, start_time);} else {code;};

#include <ctime>

void print_time(const char* msg, std::clock_t start_time) {
  // prints time in seconds
  Rcout << msg << ": " << double(std::clock() - start_time) / CLOCKS_PER_SEC << "s" << std::endl;
}


#endif
