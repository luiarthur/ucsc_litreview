// Generated by `./generate`. Do not edit by hand! 
#ifndef LOCKED_ADDON_H
#define LOCKED_ADDON_H
#include "Locked.h"

Locked gen_locked_obj(const Rcpp::List &locked_ls) {
  Locked locked;

  locked.beta_0 = Rcpp::as<bool>(locked_ls["beta_0"]);
  locked.beta_1 = Rcpp::as<bool>(locked_ls["beta_1"]);
  locked.missing_y = Rcpp::as<bool>(locked_ls["missing_y"]);
  locked.mus_0 = Rcpp::as<bool>(locked_ls["mus_0"]);
  locked.mus_1 = Rcpp::as<bool>(locked_ls["mus_1"]);
  locked.sig2_0 = Rcpp::as<bool>(locked_ls["sig2_0"]);
  locked.sig2_1 = Rcpp::as<bool>(locked_ls["sig2_1"]);
  locked.s = Rcpp::as<bool>(locked_ls["s"]);
  locked.gam = Rcpp::as<bool>(locked_ls["gam"]);
  locked.eta_0 = Rcpp::as<bool>(locked_ls["eta_0"]);
  locked.eta_1 = Rcpp::as<bool>(locked_ls["eta_1"]);
  locked.v = Rcpp::as<bool>(locked_ls["v"]);
  locked.alpha = Rcpp::as<bool>(locked_ls["alpha"]);
  locked.H = Rcpp::as<bool>(locked_ls["H"]);
  locked.Z = Rcpp::as<bool>(locked_ls["Z"]);
  locked.lam = Rcpp::as<bool>(locked_ls["lam"]);
  locked.W = Rcpp::as<bool>(locked_ls["W"]);

  return locked;
}

#endif