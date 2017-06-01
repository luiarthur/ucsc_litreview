void print_time(clock_t start_time) {
  Rcout << double(clock() - start_time) / CLOCKS_PER_SEC << std::endl;
}
