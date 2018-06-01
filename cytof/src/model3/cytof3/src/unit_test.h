#ifndef UNIT_TEST_H
#define UNIT_TEST_H

#include<string>
#include<RcppArmadillo.h>

using namespace Rcpp;
// Enable C++11 via this plugin (Rcpp 0.10.3 or later)
// [[Rcpp::plugins(cpp11)]]

void print_pass_fail_counts(const int counters[2]) {
  const int total_tests = counters[0] + counters[1];
  Rcout << "Passes: " << counters[0] << " / " << total_tests << std::endl;
  Rcout << "Fails:  " << counters[1] << " / " << total_tests << std::endl;
}

template <typename T>
void test_equal(std::string test_name, T computed_value, T expected_value, 
                int counters[2]) {
  const std::string pass_fail = computed_value == expected_value ? "PASS" : "FAIL";
  Rcout << test_name << " | " << "Computed: " << computed_value << 
    " | Expected: " << expected_value << " | Test " << pass_fail << std::endl;
  if (pass_fail == "PASS") counters[0]++; else counters[1]++;
}

template <typename T>
void test_approx(std::string test_name, T computed_value, T expected_value, 
                 double eps, int counters[2]) {
  const std::string pass_fail = abs(computed_value - expected_value) < eps ? "PASS" : "FAIL";
  Rcout << test_name << " | " << "Computed: " << computed_value << 
    " | Expected: " << expected_value << " | Test " << pass_fail << std::endl;
  if (pass_fail == "PASS") counters[0]++; else counters[1]++;
}

#endif
