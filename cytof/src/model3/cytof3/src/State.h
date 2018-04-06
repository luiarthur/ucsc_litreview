#ifndef STATE_H
#define STATE_H

#include <RcppArmadillo.h>

struct State {
  arma::vec beta_0; // I
  arma::vec beta_1; // I
  std::vector<arma::mat> missing_y; // I x (N[i] x J)
  arma::vec mus_0; // L0
  arma::vec mus_1; // L1
  arma::mat sig2_0; // I x L0
  arma::mat sig2_1; // I x L1
  arma::vec s; // I
  std::vector<arma::Mat<int>> gam; // I x (N[i] x J)
  arma::cube eta_0; // I x J x L0
  arma::cube eta_1; // I x J x L1
  arma::vec v; // K
  double alpha;
  arma::mat H; // J x K
  std::vector<std::vector<int>> lam; // I x N[i]
  arma::mat W; // I x K
};


#endif
