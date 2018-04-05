#ifndef FIXED_ADDON_H
#define FIXED_ADDON_H
#include "Fixed.h"

Fixed gen_fixed_obj(const Rcpp::List &fixed_ls) {
  Fixed fixed;

  fixed.beta_0 = Rcpp::as<bool>(fixed_ls["beta_0"]);
  fixed.beta_1 = Rcpp::as<bool>(fixed_ls["beta_1"]);
  fixed.missing_y = Rcpp::as<bool>(fixed_ls["missing_y"]);
  fixed.mus_0 = Rcpp::as<bool>(fixed_ls["mus_0"]);
  fixed.mus_1 = Rcpp::as<bool>(fixed_ls["mus_1"]);
  fixed.sig2_0 = Rcpp::as<bool>(fixed_ls["sig2_0"]);
  fixed.sig2_1 = Rcpp::as<bool>(fixed_ls["sig2_1"]);
  fixed.s = Rcpp::as<bool>(fixed_ls["s"]);
  fixed.gam = Rcpp::as<bool>(fixed_ls["gam"]);
  fixed.eta_0 = Rcpp::as<bool>(fixed_ls["eta_0"]);
  fixed.eta_1 = Rcpp::as<bool>(fixed_ls["eta_1"]);
  fixed.v = Rcpp::as<bool>(fixed_ls["v"]);
  fixed.alpha = Rcpp::as<bool>(fixed_ls["alpha"]);
  fixed.H = Rcpp::as<bool>(fixed_ls["H"]);
  fixed.lam = Rcpp::as<bool>(fixed_ls["lam"]);
  fixed.W = Rcpp::as<bool>(fixed_ls["W"]);

  return fixed;
}

#endif
