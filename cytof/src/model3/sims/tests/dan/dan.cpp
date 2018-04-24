#include<Rcpp.h>
using namespace Rcpp;

//[[Rcpp::export]]
void addOne(NumericVector y) {
  y[0] += 1;
}

//[[Rcpp::export]]
void set999(NumericVector y) {
  y[0] = 999;
}

