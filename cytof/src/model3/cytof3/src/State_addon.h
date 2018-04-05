#ifndef STATE_ADDON_H
#define STATE_ADDON_H
#include "State.h"

State gen_state_obj(const Rcpp::List &state_ls) {
  State state;

  state.beta_0 = Rcpp::as<arma::vec>(state_ls["beta_0"]);
  state.beta_1 = Rcpp::as<arma::vec>(state_ls["beta_1"]);
  state.missing_y = Rcpp::as<std::vector<arma::mat>>(state_ls["missing_y"]);
  state.mus_0 = Rcpp::as<arma::vec>(state_ls["mus_0"]);
  state.mus_1 = Rcpp::as<arma::vec>(state_ls["mus_1"]);
  state.sig2_0 = Rcpp::as<arma::mat>(state_ls["sig2_0"]);
  state.sig2_1 = Rcpp::as<arma::mat>(state_ls["sig2_1"]);
  state.s = Rcpp::as<arma::vec>(state_ls["s"]);
  state.gam = Rcpp::as<std::vector<arma::Mat<int>>>(state_ls["gam"]);
  state.eta_0 = Rcpp::as<arma::cube>(state_ls["eta_0"]);
  state.eta_1 = Rcpp::as<arma::cube>(state_ls["eta_1"]);
  state.v = Rcpp::as<arma::vec>(state_ls["v"]);
  state.alpha = Rcpp::as<double>(state_ls["alpha"]);
  state.H = Rcpp::as<arma::mat>(state_ls["H"]);
  state.lam = Rcpp::as<std::vector<std::vector<int>>>(state_ls["lam"]);
  state.W = Rcpp::as<arma::mat>(state_ls["W"]);

  return state;
}

#endif
