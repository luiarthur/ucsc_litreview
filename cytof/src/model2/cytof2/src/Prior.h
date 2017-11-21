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

void precompute_H_stats(Prior &prior) {
  // precompute matrix inverses for update_H

  const int J = prior.G.n_cols;

  for (int j=0; j<J; j++) {
    const auto j_idx = arma::regspace<arma::vec>(0, J-1);
    const arma::uvec minus_j = arma::find(j_idx != j);
    const arma::mat G_minus_j_inv = prior.G(minus_j, minus_j).i();
    const double G_jj = prior.G(j,j);
    arma::uvec at_j; at_j << j;
    const arma::rowvec G_j_minus_j = prior.G(at_j, minus_j);

    prior.R.row(j) = G_j_minus_j * G_minus_j_inv;
    const arma::vec S2j = G_jj - prior.R.row(j) * G_j_minus_j.t();

    prior.S2(j) = S2j(0);
  }
}

template<typename T>
T getOrInit(const List &prior, const char* param, T init) {
  return prior.containsElementNamed(param) ? as<T>(prior[param]) : init;
}

Prior gen_prior_obj(Nullable<List> prior_input, int J) {
  const List prior = prior_input.isNull() ? List::create() : as<List>(prior_input);
  arma::mat default_G = arma::eye<arma::mat>(J,J);

  Prior out;

  out.a_beta = getOrInit(prior,"a_beta", 1);
  out.b_beta = getOrInit(prior,"b_beta", 1);
  out.cs_beta1j = getOrInit(prior,"b_beta1j", 1);
  out.s2_beta0 = getOrInit(prior,"s2_beta0", 10);
  out.cs_beta0 = getOrInit(prior,"cs_beta0", 1);
  out.s2_betaBar = getOrInit(prior,"s2_betaBar", 10);

  out.a_gam = getOrInit(prior,"a_gam", .1);
  out.b_gam = getOrInit(prior,"b_gam", .1);
  out.cs_gam = getOrInit(prior,"cs_gam", 1);
  out.a_sig = getOrInit(prior,"a_sig", 2);
  out.b_sig = getOrInit(prior,"b_sig", 2);

  out.psi0Bar = getOrInit(prior,"psi0Bar", -1);
  out.s2_psi0 = getOrInit(prior,"s2_psi0", 10);
  out.cs_psi0 = getOrInit(prior,"cs_psi0", 1);

  out.psi1Bar = getOrInit(prior,"psi1Bar", 1);
  out.s2_psi1 = getOrInit(prior,"s2_psi1", 10);
  out.cs_psi1 = getOrInit(prior,"cs_psi1", 1);

  out.a_tau0 = getOrInit(prior,"a_tau0", 2);
  out.b_tau0 = getOrInit(prior,"b_tau0", 1);
  out.cs_tau0 = getOrInit(prior,"cs_tau0", 1);

  out.a_tau1 = getOrInit(prior,"a_tau1", 2);
  out.b_tau1 = getOrInit(prior,"b_tau1", 1);
  out.cs_tau1 = getOrInit(prior,"cs_tau1", 1);

  out.alpha = getOrInit(prior,"alpha", 1);
  out.cs_v = getOrInit(prior,"cs_v", 1);

  out.G = getOrInit(prior,"G", default_G);
  out.cs_h = getOrInit(prior,"cs_h", 1);
  out.R = arma::mat(J, J-1);
  out.S2 = arma::vec(J);

  out.d_w = getOrInit(prior,"d_w", 1);

  out.cs_y = getOrInit(prior,"cs_y", 1);

  out.K_min = getOrInit(prior,"K_min", 1);
  out.K_max = getOrInit(prior,"K_max", 15);
  out.a_K = getOrInit(prior,"a_K", 2);

  precompute_H_stats(out);

  return out;
}
