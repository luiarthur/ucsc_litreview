#include<RcppArmadillo.h>

using namespace Rcpp;

// [[Rcpp::depends(RcppArmadillo)]]


//[[Rcpp::export]]
arma::mat test(const std::vector<arma::mat> &y) {
  
  auto K = y.size();
  Rcout << K << std::endl;

  return y[0];
}

// [[Rcpp::export]]
std::vector<double> test2(double a, double b){
  std::vector<double> out = {a, b};
  return out;
}

struct State {
  double x;
  double y;
};


RCPP_MODULE(mod) {
  class_<State>( "State" )
  .field( "x", &State::x )
  .field( "y", &State::y )
  ;
}


