struct Prior {
  // beta_{1j} ~ Gamma(a_beta, b_beta), where mean = a_beta / b_beta
  double a_beta; double b_beta; double cs_beta1j;
  // beta_{0ij} | betaBar_{0j} ~ N(betaBar_{0j}, s2_beta0)
  double s2_beta0; double cs_beta0;
  // betaBar_{0j} ~ N(0, s2_beta)
  double s2_betaBar;
  
  // gamma_{0ij}
  double a_gam; double b_gam; double cs_gam;
  // sig2_{ij}
  double a_sig; double b_sig;
  // psi
  double psi0Bar; double s2_psi0; double cs_psi0;
  double psi1Bar; double s2_psi1; double cs_psi1;
  // tau2 ~ IG(a, b), where mean = b / (a-1)
  double a_tau0; double b_tau0; double cs_tau0;
  double a_tau1; double b_tau1; double cs_tau1;

  // v_k ~ Beta(alpha, 1)
  double alpha; double cs_v;
  // h_k ~ N(0, G)
  arma::mat G;
  double cs_h;
  arma::mat R;  // J x J-1 // precomputed R_{j,} = G_{j,-j} * G_{-j,-j}^{-1} 
  arma::vec S2; // J       // precomputed S_j^2 = G_{j,j} - R_{j,} * G_{-j,j}
  // W_i ~ Dir_K(d,...,d)
  double d_w;

  // missing y
  double cs_y;

  // K
  int K_min;  // 1?
  int K_max;  // 15?
  int a_K; // constraint: 2 * a_K <= K_max - K_min + 1
};
