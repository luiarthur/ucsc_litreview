#include "addOne.h"
#include "mcmc.h"

//' SomethingCool
//' @export
// [[Rcpp::export]]
double magicAdd(double a) {
  // something(a) returns a + a + 1 = 2a + 1.
  Rcout << "Input: " << a << std::endl;
  return a + addOne(a);
}

//' CoolLogit
//' @export
// [[Rcpp::export]]
double coolLogit(double p, double a, double b) {
  Rcout << "Input: " << p << std::endl;
  return logit(p, a, b);
}

//' CoolRTrunc
//' @export
// [[Rcpp::export]]
double coolRTrunc(double m, double s, double lo, double hi) {
  //Rcout << "Input: " << m << std::endl;
  return rtnorm(m,s,lo,hi);
}

