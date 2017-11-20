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

void gen_prior_obj(List prior, int J) {
  Prior out = Prior {
    prior.constainsElementNamed("a_beta") ? prior["a_beta"] : 1,
    prior.constainsElementNamed("b_beta") ? prior["b_beta"] : 1,
    prior.constainsElementNamed("cs_beta1j") ? prior["cs_beta1j"] : 1,

    prior.constainsElementNamed("s2_beta0") ? prior["s2_beta0"] : 10,
    prior.constainsElementNamed("cs_beta0") ? prior["cs_beta0"] : 1,
    prior.constainsElementNamed("s2_betaBar") ? prior["cs_betaBar"] : 10,

    prior.constainsElementNamed("a_gam") ? prior["a_gam"] : .1,
    prior.constainsElementNamed("b_gam") ? prior["b_gam"] : .1,
    prior.constainsElementNamed("cs_gam") ? prior["cs_gam"] : 1,

    prior.constainsElementNamed("a_sig") ? prior["a_sig"] : 2,
    prior.constainsElementNamed("b_sig") ? prior["b_sig"] : 1,

    prior.constainsElementNamed("psi0Bar") ? prior["psi0Bar"] : -1,
    prior.constainsElementNamed("s2_psi0") ? prior["s2_psi0"] : 10,
    prior.constainsElementNamed("cs_psi0") ? prior["cs_psi0"] : 1,

    prior.constainsElementNamed("psi1Bar") ? prior["psi1Bar"] : 1,
    prior.constainsElementNamed("s2_psi1") ? prior["s2_psi1"] : 10,
    prior.constainsElementNamed("cs_psi1") ? prior["cs_psi1"] : 1,

    prior.constainsElementNamed("a_tau0") ? prior["a_tau0"] : 2,
    prior.constainsElementNamed("b_tau0") ? prior["b_tau0"] : 1,
    prior.constainsElementNamed("cs_tau0") ? prior["cs_tau0"] : 1,

    prior.constainsElementNamed("a_tau1") ? prior["a_tau1"] : 2,
    prior.constainsElementNamed("b_tau1") ? prior["b_tau1"] : 1,
    prior.constainsElementNamed("cs_tau1") ? prior["cs_tau1"] : 1,

    prior.constainsElementNamed("alpha") ? prior["alpha"] : 1,
    prior.constainsElementNamed("cs_v") ? prior["cs_v"] : 1,

    prior.constainsElementNamed("G") ? prior["G"] : eye(J),
    prior.constainsElementNamed("cs_h") ? prior["cs_h"] : 1,
    arma::mat(J, J-1), //R
    arma::vec(J), // S2

    prior.constainsElementNamed("d_w") ? prior["d_w"] : 1,

    prior.constainsElementNamed("cs_y") ? prior["cs_y"] : 1,

    prior.constainsElementNamed("K_min") ? prior["K_min"] : 1,
    prior.constainsElementNamed("K_max") ? prior["K_max"] : 15,
    prior.constainsElementNamed("a_K") ? prior["a_K"] : 2,
  }; 

  precompute_H_stats(out);

  return out;
}
