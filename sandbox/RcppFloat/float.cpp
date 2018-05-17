#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]
using namespace Rcpp;

// [[Rcpp::export]]
arma::Mat<float> addOne(arma::Mat<float> X) {
  return X + 1;
}
