#include "unit_test.h"

//' Cytof3 Unit Tests
//' @export
// [[Rcpp::export]]
void cytof3_unit_tests_cpp() {
  // Initialize pass / fail counters
  int counters[2] = {0,0};
  
  // Put Tests Here ////

  // End of Tests ////

  print_pass_fail_counts(counters);
}
