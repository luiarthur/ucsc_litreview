
/*** my_timer.h
 * This script creates a macro timer for functions.
 * To use this macro, just wrap the macro TIME_CODE around your code like this:
 *
 * TIME_CODE(bool: show_time, string: message, any_arbitrary_code_or_function_call)
 *
 * For example,
 *
 * TIME_CODE(true, "This is the elapsed time: ", int x = 100)
 *
 * If show_time = true, then the timings will show. Otherwise, the times will not show.
 */

#ifndef MY_TIMER_H
#define MY_TIMER_H
#include <chrono> // for timing

#define TIME_CODE(MSG, CODE) \
  if (true) { \
    auto MY_START_TIME = std::chrono::high_resolution_clock::now(); \
    CODE; \
    auto MY_END_TIME = std::chrono::high_resolution_clock::now(); \
    std::chrono::duration<double> elapsed = MY_END_TIME - MY_START_TIME; \
    std::cout << MSG << ": " << elapsed.count() << "s" << std::endl; \
  };

#endif
