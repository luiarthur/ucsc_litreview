#ifndef STATE_H
#define STATE_H

#include <RcppArmadillo.h>

struct State {
  Rcpp::NumericVector beta_0; // I
  Rcpp::NumericVector beta_1; // I
  std::vector<Rcpp::NumericMatrix> missing_y; // I x (N[i] x J)
  Rcpp::NumericVector mus_0; // L0
  Rcpp::NumericVector mus_1; // L1
  Rcpp::NumericMatrix sig2_0; // I x L0
  Rcpp::NumericMatrix sig2_1; // I x L1
  Rcpp::NumericVector s; // I
  std::vector<Rcpp::IntegerMatrix> gam; // I x (N[i] x J)
  arma::cube eta_0; // I x J x L0
  arma::cube eta_1; // I x J x L1
  Rcpp::NumericVector v; // K
  double alpha;
  Rcpp::NumericMatrix H; // J x K
  std::vector<Rcpp::IntegerVector> lam; // I x N[i]
  Rcpp::NumericMatrix W; // I x K
};


#endif
