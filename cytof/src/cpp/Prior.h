struct Prior {
  // mus
  double mus_thresh; // log(2)
  arma::vec cs_mu;

  // psi
  double m_psi; double s2_psi; arma::vec cs_psi;
  
  //tau2
  double a_tau; double b_tau; arma::vec cs_tau2;

  // c
  double s2_c; double cs_c;

  // d
  double m_d; double s2_d; double cs_d;

  // sig2
  double a_sig; double b_sig; arma::vec cs_sig2;

  // alpha
  double alpha;

  // v
  double cs_v;

  // H
  arma::mat G;
  arma::mat R;
  arma::vec S2;
  double cs_h;

  // W
  double a_w;
  
  // K
  int K_min;  // 1?
  int K_max;  // 15?
  int a_K; // constraint: 2 * a_K <= K_max - K_min + 1
};

