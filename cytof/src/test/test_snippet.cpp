#include<RcppArmadillo.h>

using namespace Rcpp;

// [[Rcpp::depends(RcppArmadillo)]]

struct State {
  double x;
  double y;
};

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

RCPP_MODULE(mod_state) {
  class_<State>( "State" )
  .field_readonly( "x", &State::x )
  .field_readonly( "y", &State::y )
  ;
}

// [[Rcpp::export]]
State test3(double x, double y) {
  return State{x, y};
}
