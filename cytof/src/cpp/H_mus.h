// Updating H. See Section 5.7 of manula


double log_acc_ratio_Hjk_mus_jk(const State &state, const Data & y, 
                                const Prior &prior, int j, int k,
                                double mj, double S2j,
                                double cand_h_jk, double cand_z_jk,
                                double cand_mus_jk) {
  // log acceptance ratio to return
  double log_r = 0;

  const int I = get_I(y);
  const double h_jk = state.H(j, k);
  const double mus_jk = state.mus(j, k);
  const int z_jk = state.Z(j, k);

  const double s = prior.cs_mu(j,k);
  const double th = prior.mus_thresh;
  const bool curr_lt_th = state.Z(j,k) == 0;
  const bool cand_lt_th = cand_z_jk == 0;

  // difference of log prior 
  log_r = pow(cand_h_jk - mj, 2) - pow(h_jk - mj, 2) / (-2*S2j);

//#pragma omp parallel for
  for (int i=0; i<I; i++) {
    for (int n=0; n<get_Ni(y,i); n++) {
      if (state.lam[i][n] == k) {
        log_r += marginal_lf(y[i](n,j), cand_mus_jk, sqrt(state.sig2(i)),
                             cand_z_jk, state.pi(i,j));
        log_r -= marginal_lf(y[i](n,j), mus_jk, sqrt(state.sig2(i)),
                             z_jk, state.pi(i,j));
        if (cand_z_jk != z_jk) {
          log_r += log_dtnorm(state.mus(j,k), state.psi(j), s, th, curr_lt_th);
          log_r -= log_dtnorm(cand_mus_jk, state.psi(j), s, th, cand_lt_th);
        }
      }
    }
  }
  return log_r;
}

// TODO: Check this
void update_Hjk_mus_jk(State &state, const Data &y, const Prior &prior,
                       int j, int k, double mj, double S2j) {

  const double h_jk = state.H(j, k);
  const double b_k = compute_bk(state, k);
  const double cand_h_jk = R::rnorm(h_jk, prior.cs_h);
  const double cand_z_jk = compute_z(cand_h_jk, prior.G(j,j), b_k);

  double cand_mus_jk = state.mus(j, k);
  if (cand_z_jk != state.Z(j,k)) {
    // OLD PROPOSAL
    //cand_mus_jk = rmus(state.psi(j), sqrt(state.tau2(j)), 
    //                   cand_z_jk, prior.mus_thresh);
    
    // NEW PROPOSAL
    cand_mus_jk = rmus(state.psi(j), prior.cs_mu(j,k), 
                       cand_z_jk, prior.mus_thresh);
  }

  const double u = R::runif(0,1);
  const double log_acc_ratio = 
    log_acc_ratio_Hjk_mus_jk(state, y, prior, j, k, mj, S2j,
                             cand_h_jk, cand_z_jk, cand_mus_jk);

  if (log_acc_ratio > log(u)) {
    state.Z(j, k) = cand_z_jk;
    state.mus(j, k) = cand_mus_jk;
    state.H(j, k) = cand_h_jk;
  }
}   

void update_Hj_mus_j(State &state, const Data &y, const Prior &prior, int j) {
  const int K = state.K;
  const auto h_j = state.H.row(j);

  const auto b = compute_b(state);

  // draw proposed hj
  arma::Row<double> cand_hj(K);
  for (int k=0; k<K; k++) {
    //cand_hj[k] = R::rnorm(h_j[k], prior.cs_h/10);
    cand_hj[k] = R::rnorm(h_j[k], prior.cs_hj);
  }

  // compute proposed zj
  arma::Row<int> cand_zj(K);
  for (int k=0; k< K; k++) {
    cand_zj[k] = compute_z(cand_hj[k], prior.G(j,j), b[k]);
  }

  arma::Row<double> cand_mus_j = state.mus.row(j);
  for (int k=0; k<K; k++) {
    if (cand_zj[k] != state.Z(j,k)) {
      // OLD PROPOSAL
      //cand_mus_j[k] = rmus(state.psi(j), sqrt(state.tau2(j)),
      //                     cand_zj[k], prior.mus_thresh);

      // NEW PROPOSAL
      cand_mus_j[k] = rmus(state.psi(j), prior.cs_mu(j,k),
                           cand_zj[k], prior.mus_thresh);
    }
  }

  const double u = R::runif(0,1);

  // Compute mj vector
  std::vector<double> mj(K);
  const int J = get_J(y);
  const auto j_idx = arma::regspace<arma::vec>(0, J-1);
  const arma::uvec minus_j = arma::find(j_idx != j);
  for (int k=0; k<K; k++) {
    arma::uvec at_k; at_k << k;
    // this should be 1 x 1
    const arma::vec mj_vec = prior.R.row(j) * state.H(minus_j, at_k);
    mj[k] = mj_vec(0);
  }

  double log_acc_ratio = 0;
  for (int k=0; k<K; k++) {
    log_acc_ratio += 
      log_acc_ratio_Hjk_mus_jk(state, y, prior, j, k, mj[k], prior.S2(j),
                               cand_hj[k], cand_zj[k], cand_mus_j[k]);
  }

  if (log_acc_ratio > log(u)) {
    state.Z.row(j) = cand_zj;
    state.mus.row(j) = cand_mus_j;
    state.H.row(j) = cand_hj;
  }
}

void update_H_mus(State &state, const Data &y, const Prior &prior) {
  const int J = get_J(y);
  const int K = state.K;

  for (int j=0; j<J; j++) {
    const auto j_idx = arma::regspace<arma::vec>(0, J-1);
    const arma::uvec minus_j = arma::find(j_idx != j);
    for (int k=0; k<K; k++) {
      arma::uvec at_k; at_k << k;
      const arma::vec mj = prior.R.row(j) * state.H(minus_j, at_k);
      update_Hjk_mus_jk(state, y, prior, j, k, mj(0), prior.S2(j));
    }

    // update eacj row together (THIS IS NEW STUFF...)
    update_Hj_mus_j(state, y, prior, j);
  }
}

