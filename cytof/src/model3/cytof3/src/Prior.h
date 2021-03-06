#ifndef PRIOR_H
#define PRIOR_H

#include <RcppArmadillo.h>

struct Prior {
  // mu bounds
  double mu_lower;
  double mu_upper;
  // missing mechnism. constants
  // beta_0 ~ N(m_beta0, s2_beta0). metropolis.
  double m_beta0;
  double s2_beta0;
  double cs_beta0;
  // beta_1 ~ N-(m_beta1, s2_beta1). metropolis.
  double m_beta1;
  double s2_beta1;
  double cs_beta1;
  // missing_y
  double cs_y;
  // psi. Gibbs.
  double psi_0; double psi_1;
  // tau. Gibbs.
  double tau2_0; double tau2_1;
  // sig2. Gibbs.
  double a_sig;
  double sig2_max;
  // s. Gibbs.
  double a_s; double b_s;
  // eta. Gibbs.
  double a_eta0;
  double a_eta1;
  // v. metropolis
  double cs_v;
  // alpha. Gibbs.
  double a_alpha;
  double b_alpha;
  // H. metropolis.
  double cs_h;
  // G. constants.
  //arma::mat R;  // J x J-1 // precomputed R_{j,} = G_{j,-j} * G_{-j,-j}^{-1}
  //arma::vec S2; // J       // precomputed S_j^2 = G_{j,j} - R_{j,} * G_{-j,j}
  arma::mat G; // J x J
  // Repulsive Z
  double a_Z;
  double nu_a;
  double nu_b;
  // W. Gibbs
  double d_W;
  // K. constant.
  int K;
};

double get_psi_z(const Prior &prior, int z) {
  return (z == 0 ? prior.psi_0 : prior.psi_1);
}

double get_tau2_z(const Prior &prior, int z) {
  return (z == 0 ? prior.tau2_0 : prior.tau2_1);
}

double get_a_eta_z(const Prior &prior, int z) {
  return (z == 0 ? prior.a_eta0 : prior.a_eta1);
}

#endif
