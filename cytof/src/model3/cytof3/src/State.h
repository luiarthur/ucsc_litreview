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


//State gen_init_obj(const Rcpp::List &init_ls) {
//  using namespace Rcpp;
//  using namespace arma;
//  
//  State state;
//  
//  state.beta_0 = as<vec>(init_ls["beta_0"]);
//  state.beta_1 = as<vec>(init_ls["beta_1"]);
//  state.missing_y = as<std::vector<mat>>(init_ls["missing_y"]);
//  state.mus_0 = as<vec>(init_ls["mus_0"]);
//  state.mus_1 = as<vec>(init_ls["mus_1"]);
//  state.sig2_0 = as<mat>(init_ls["sig2_0"]);
//  state.sig2_1 = as<mat>(init_ls["sig2_1"]);
//  state.s = as<vec>(init_ls["s"]);
//  state.gam = as<std::vector<Mat<int>>>(init_ls["gam"]);
//  state.eta_0 = as<cube>(init_ls["eta_0"]);
//  state.eta_1 = as<cube>(init_ls["eta_1"]);
//  state.v = as<vec>(init_ls["v"]);
//  state.alpha = as<double>(init_ls["alpha"]);
//  state.H = as<mat>(init_ls["H"]);
//  state.lam = as<std::vector<::std::vector<int>>>(init_ls["lam"]);
//  state.W = as<mat>(init_ls["W"]);
//  
//  return state;
//}

#endif
