#include <string>

void print_pass_fail_counts(const int counters[2]) {
  const int total_tests = counters[0] + counters[1];
  Rcout << "Passes: " << counters[0] << " / " << total_tests << std::endl;
  Rcout << "Fails:  " << counters[1] << " / " << total_tests << std::endl;
}

template <typename T>
void test_equal(std::string test_name, T computed_value, T expected_value, 
                int counters[2]) {
  const auto pass_fail = computed_value == expected_value ? "PASS" : "FAIL";
  Rcout << test_name << " | " << "Computed: " << computed_value << 
    " | Expected: " << expected_value << " | Test " << pass_fail << std::endl;
  if (pass_fail == "PASS") counters[0]++; else counters[1]++;
}

template <typename T>
void test_approx(std::string test_name, T computed_value, T expected_value, 
                 double eps, int counters[2]) {
  const auto pass_fail = abs(computed_value - expected_value) < eps ? "PASS" : "FAIL";
  Rcout << test_name << " | " << "Computed: " << computed_value << 
    " | Expected: " << expected_value << " | Test " << pass_fail << std::endl;
  if (pass_fail == "PASS") counters[0]++; else counters[1]++;
}


//' My Unit Tests
//' @export
// [[Rcpp::export]]
void unit_tests() {
  // Initialize pass / fail counters
  int counters[2] = {0,0};

  // Put Tests Here ////
  const double dtnorm_res1 = dtnorm(0, 0, 1, 0, INFINITY);
  test_approx<double>("dtnorm(0,0,1,0,Inf)", dtnorm_res1, .797885, 1E-6, counters);

  const double dtnorm_res2 = dtnorm(-1, 0, 1, 0, INFINITY);
  test_equal<double>("dtnorm(-1,0,1,0,Inf)", dtnorm_res2, 0, counters);

  const double N=100000;
  arma::vec x(N);
  const double rig_a = 3;
  const double rig_b = 4;
  for (int i=0; i<N; i++) x[i] = rinvgamma(rig_a, rig_b);
  test_approx<double>("Mean of InverseGamma(3,4)", arma::mean(x), rig_b / (rig_a-1), 1E-2, counters);
  // End of Tests ////

  print_pass_fail_counts(counters);
}
