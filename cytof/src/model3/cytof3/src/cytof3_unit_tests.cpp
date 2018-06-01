//#include "mcmc.h"
#include "unit_test.h"

//' Cytof3 Unit Tests
//' @export
// [[Rcpp::export]]
void cytof3_unit_tests_cpp() {
  // Initialize pass / fail counters
  int counters[2] = {0,0};
  
  // Put Tests Here ////

  // Test pinvgamma and qinvgamma
  //test_approx<double>("test: pinvgamma(3, 4, 2)",
  //    mcmc::pinvgamma(3,4,2), .995, 1E-3, counters);
  //test_approx("test: qinvgamma(3, 4, 2)",
  //    mcmc::qinvgamma(.3,4,2), .420, 1E-3, counters);
  //test_approx("test: pinvgamma(3, 4, 2, true)",
  //    mcmc::pinvgamma(3,4,2,true), -0.004868, 1E-3, counters);
  //test_approx("test: qinvgamma(log(.3), 4, 2, true)",
  //    mcmc::qinvgamma(log(.3),4,2,true), .420, 1E-3, counters);

  // End of Tests ////

  print_pass_fail_counts(counters);
}
