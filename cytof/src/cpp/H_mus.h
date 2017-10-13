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

  log_r = pow(cand_h_jk - mj, 2) - pow(h_jk - mj, 2) / (-2*S2j);

//#pragma omp parallel for
  for (int i=0; i<I; i++) {
    for (int n=0; n<get_Ni(y,i); n++) {
      if (state.lam[i][n] == k) {
        if (cand_z_jk != z_jk) {
          log_r += marginal_lf(y[i](n,j), cand_mus_jk, sqrt(state.sig2(i)),
                               cand_z_jk, state.pi(i,j));
          log_r -= marginal_lf(y[i](n,j), mus_jk, sqrt(state.sig2(i)),
                               z_jk, state.pi(i,j));
        }
      }
    }
  }
  return log_r;
}

// TODO: Check this
void update_Hjk_mus_jk(State &state, const Data &y, const Prior &prior,
                       int j, int k, double mj, double S2j) {

  //const int I = get_I(y);
  ////const int J = get_J(y);
  ////int N_i;


  //auto log_fc = [&](double h_jk, double mus_jk, int z_jk) {
  //  const double lp = R::dnorm(h_jk, mj, sqrt(S2j), 1);
  //  double ll = 0;


////#pragma omp parallel for
  //  for (int i=0; i<I; i++) {
  //    //N_i = get_Ni(y, i);
  //    for (int n=0; n<get_Ni(y,i); n++) {
  //      if (state.lam[i][n] == k) {
  //        ll += marginal_lf(y[i](n,j), mus_jk, sqrt(state.sig2(i)),
  //                          z_jk, state.pi(i,j));
  //      }
  //    }
  //  }

  //  return ll + lp;
  //};


  const double h_jk = state.H(j, k);
  double b_k = 1;
  for (int l=0; l<=k; l++) { b_k *= state.v(l); }
  const double cand_h_jk = R::rnorm(h_jk, prior.cs_h);
  const double cand_z_jk = compute_z(cand_h_jk, prior.G(j,j), b_k);

  double cand_mus_jk = state.mus(j, k);
  if (cand_z_jk != state.Z(j,k)) {
    cand_mus_jk = rmus(state.psi(j), sqrt(state.tau2(j)), 
                       cand_z_jk, prior.mus_thresh);
  }

  const double u = R::runif(0,1);
  //if (log_fc(cand_h_jk, cand_mus_jk, cand_z_jk) -
  //    log_fc(state.H(j, k), state.mus(j,k), state.Z(j,k)) > log(u)) {

  const double log_acc_ratio = 
    log_acc_ratio_Hjk_mus_jk(state, y, prior, j, k, mj, S2j,
                             cand_h_jk, cand_z_jk, cand_mus_jk);

  if (log_acc_ratio > log(u)) {
    state.Z(j, k) = cand_z_jk;
    state.mus(j, k) = cand_mus_jk;
    state.H(j, k) = cand_h_jk;
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
  }
}

