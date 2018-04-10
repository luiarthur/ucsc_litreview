#ifndef UPDATE_THETA_H
#define UPDATE_THETA_H

#include "mcmc.h"

#include "Data.h"
#include "Prior.h"
#include "State.h"
#include "Locked.h"

#include "update_beta.h" // metropolis
#include "update_missing_y.h" // metropolis
#include "update_mus.h" // gibbs
#include "update_sig2.h" // gibbs
#include "update_s.h" // gibbs
#include "update_gam.h" // gibbs
#include "update_eta.h" // gibbs
#include "update_v.h" // metropolis
#include "update_alpha.h" // gibbs
#include "update_H.h" // metropolis
#include "update_Z.h" // deterministic
#include "update_lam.h" // gibbs
#include "update_W.h" // gibbs

void update_theta(State &state, const Data &data, const Prior &prior, const Locked &locked, int thin_some=1) {
  Rcpp::Rcout << 1 << std::endl;
  update_beta(state, data, prior, locked); // metropolis
  Rcpp::Rcout << 2 << std::endl;
  update_missing_y(state, data, prior, locked); // metropolis
  Rcpp::Rcout << 3 << std::endl;
  update_mus(state, data, prior, locked);
  Rcpp::Rcout << 4 << std::endl;
  update_sig2(state, data, prior, locked);
  Rcpp::Rcout << 5 << std::endl;
  update_s(state, data, prior, locked);
  Rcpp::Rcout << 6 << std::endl;
  update_gam(state, data, prior, locked);
  Rcpp::Rcout << 7 << std::endl;
  update_eta(state, data, prior, locked);
  Rcpp::Rcout << 8 << std::endl;
  update_v(state, data, prior, locked); // metropolis
  Rcpp::Rcout << 9 << std::endl;
  update_H(state, data, prior, locked); // metropolis
  Rcpp::Rcout << 10 << std::endl;
  update_lam(state, data, prior, locked);
  Rcpp::Rcout << 11 << std::endl;
  update_W(state, data, prior, locked);
}

#endif
