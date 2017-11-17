#include <Rcpp.h>
#include "addOne.h"

using namespace Rcpp;

//' SomethingCool
//' @param a A double
//' @export
// [[Rcpp::export]]
double magicAdd(double a) {
  // something(a) returns a + a + 1 = 2a + 1.
  Rcout << "Input: " << a << std::endl;
  return a + addOne(a);
}

