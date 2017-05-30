struct Prior {
  // mus
  double mus_thresh; // log(2)
  double cs_mu;

  // psi
  double m_psi; double s2_psi; double cs_psi;
  
  //tau2
  double a_tau; double b_tau; double cs_tau2;

  // c
  double s2_c; double cs_c;

  // d
  double m_d; double s2_d; double cs_d;

  // sig2
  double a_sig; double b_sig; double cs_sig2;

  // alpha
  double alpha;

  // v
  double cs_v;

  // H
  arma::mat G;
  double cs_h;

  // W
  arma::rowvec a_w;
  
  // K
  int K_min;  // 1?
  int K_max;  // 15?
  int a_K; // constraint: 2 * a_K <= K_max - K_min
};

