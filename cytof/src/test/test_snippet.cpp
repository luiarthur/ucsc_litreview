#include<RcppArmadillo.h>

using namespace Rcpp;

// [[Rcpp::depends(RcppArmadillo)]]

//[[Rcpp::export]]
arma::vec test(List y) {
  
  auto K = y.size();
  Rcout << K;
  auto y_0 = y[0];

  return y_0;
}
