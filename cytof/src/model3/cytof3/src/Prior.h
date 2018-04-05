#ifndef PRIOR_H
#define PRIOR_H

#include <RcppArmadillo.h>

struct Prior {
  // missing mechnism. constants
  double c0
  double c1;
  // beta_0 ~ N(m_beta0, s2_beta0). metropolis.
  double m_beta0;
  double s2_beta0;
  double cs_beta0;
  // beta_1 ~ Gamma(shape=a_beta1, rate=b_beta1). metropolis.
  // Note that `rate = mean / var`, `shape = mean * rate`.
  // i.e. `mean = shape/rate`, `var = shape / rate^2`
  double a_beta1;
  double b_beta1;
  double cs_beta1;
  // psi. Gibbs.
  double psi_0; double psi_1;
  // tau. Gibbs.
  double tau2_0; double tau2_1;
  // sig2. Gibbs.
  double a_sig;
  // s. Gibbs.
  double a_s; double b_s;
  // eta. Gibbs.
  double a_eta0;
  double a_eta1;
  // alpha. Gibbs.
  double a_alpha;
  double b_alpha;
  // H. metropolis.
  double cs_h;
  // G. constants.
  //arma::mat R;  // J x J-1 // precomputed R_{j,} = G_{j,-j} * G_{-j,-j}^{-1}
  //arma::vec S2; // J       // precomputed S_j^2 = G_{j,j} - R_{j,} * G_{-j,j}
  arma::mat G; // J x J
  // W. Gibbs
  double d_W;
  // K. constant.
  int K;
};

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
  prior.K = Rcpp::as<double>(prior_ls["K"]);

  return prior;
}

#endif
