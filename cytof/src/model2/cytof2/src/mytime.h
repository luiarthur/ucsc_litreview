#include<ctime>

void print_time(const char* msg, std::clock_t start_time) {
  // prints time in seconds
  Rcout << msg << ": " << double(std::clock() - start_time) / CLOCKS_PER_SEC << std::endl;
}
