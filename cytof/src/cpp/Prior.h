struct Prior {
  // mus
  double mus_cutoff; // log(2)
  double cs_mu;

  // psi
  double m_psi; double s2_psi; double cs_psi;
  
  //tau2
  double a_tau; double b_tau;

  // c
  double s2_c;

  // d
  double m_d; double s2_d;

  // sig2
  double a_sig; double b_sig;

  // alpha
  double alpha;

  // H
  arma::vec m_h;
  arma::mat S_h;

  // W
  arma::vec a_w;
};

