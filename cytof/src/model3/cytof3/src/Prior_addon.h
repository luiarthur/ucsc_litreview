#ifndef PRIOR_ADDON_H
#define PRIOR_ADDON_H
#include "Prior.h"

Prior gen_prior_obj(const Rcpp::List &prior_ls) {
  Prior prior;

  prior.c0 = Rcpp::as<double>(prior_ls["c0"]);
  prior.c1 = Rcpp::as<double>(prior_ls["c1"]);
  prior.m_beta0 = Rcpp::as<double>(prior_ls["m_beta0"]);
  prior.s2_beta0 = Rcpp::as<double>(prior_ls["s2_beta0"]);
  prior.cs_beta0 = Rcpp::as<double>(prior_ls["cs_beta0"]);
  prior.a_beta1 = Rcpp::as<double>(prior_ls["a_beta1"]);
  prior.b_beta1 = Rcpp::as<double>(prior_ls["b_beta1"]);
  prior.cs_beta1 = Rcpp::as<double>(prior_ls["cs_beta1"]);
  prior.psi_0 = Rcpp::as<double>(prior_ls["psi_0"]);
  prior.psi_1 = Rcpp::as<double>(prior_ls["psi_1"]);
  prior.tau2_0 = Rcpp::as<double>(prior_ls["tau2_0"]);
  prior.tau2_1 = Rcpp::as<double>(prior_ls["tau2_1"]);
  prior.a_sig = Rcpp::as<double>(prior_ls["a_sig"]);
  prior.a_s = Rcpp::as<double>(prior_ls["a_s"]);
  prior.b_s = Rcpp::as<double>(prior_ls["b_s"]);
  prior.a_eta0 = Rcpp::as<double>(prior_ls["a_eta0"]);
  prior.a_eta1 = Rcpp::as<double>(prior_ls["a_eta1"]);
  prior.a_alpha = Rcpp::as<double>(prior_ls["a_alpha"]);
  prior.b_alpha = Rcpp::as<double>(prior_ls["b_alpha"]);
  prior.cs_h = Rcpp::as<double>(prior_ls["cs_h"]);
  prior.G = Rcpp::as<arma::mat>(prior_ls["G"]);
  prior.d_W = Rcpp::as<double>(prior_ls["d_W"]);
  prior.K = Rcpp::as<int>(prior_ls["K"]);

  return prior;
}

#endif
