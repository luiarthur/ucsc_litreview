// Updating H. See Section 5.7 of manula


// TODO: Check this
void update_Hjk_mus_jk(State &state, const Data &y, const Prior &prior,
                       int j, int k) {

  const int I = get_I(y);
  const int J = get_J(y);
  int N_i;
  int lin;
  double b_k = 1;
  const double h_jk = state.H(j, k);

  const auto j_idx = arma::regspace<arma::vec>(0, J-1);
  const arma::uvec minus_j = arma::find(j_idx != j);
  const arma::mat G_minus_j_inv = prior.G(minus_j, minus_j).i();
  const double G_jj = prior.G(j,j);
  arma::uvec at_j; at_j << j;
  arma::uvec at_k; at_k << k;
  const arma::vec G_j_minus_j = prior.G(at_j, minus_j);
  const arma::vec R = G_j_minus_j * G_minus_j_inv;

  const arma::vec mj = R * state.H(minus_j, at_k);
  const arma::vec S2j = G_jj - R * G_j_minus_j.t();

  auto log_fc = [&](double h_jk, double mus_jk, int z_jk) {
    const double lp = R::dnorm(h_jk, mj(0), sqrt(S2j(0)), 1);
    double ll = 0;

    for (int j=0; j<J; j++) {
      for (int i=0; i<I; i++) {
        N_i = get_Ni(y, i);
        for (int n=0; n<N_i; n++) {
          ll += marginal_lf(y[i](n,j), mus_jk, sqrt(state.sig2(i)),
                            z_jk, state.pi(i,j));
        }
      }
    }

    return ll + lp;
  };

  for (int l=0; l<k; l++) { b_k *= state.v(k); }
  const double cand_h_jk = R::rnorm(h_jk, prior.cs_h);
  const double cand_z_jk = compute_z(cand_h_jk, G_jj, b_k);

  double cand_mus_jk = state.mus(j, k);
  if (cand_z_jk != state.Z(j,k)) {
    cand_mus_jk = rtnorm(state.psi(j), sqrt(state.tau2(j)), 
                         cand_z_jk, prior.mus_thresh);
  }

  const double u = R::runif(0,1);
  if (log_fc(cand_h_jk, cand_mus_jk, cand_z_jk) - 
      log_fc(state.H(j, k), state.mus(j,k), state.Z(j,k)) > log(u)) {
    state.Z(j, k) = cand_z_jk;
    state.mus(j, k) = cand_mus_jk;
    state.H(j, k) = cand_h_jk;
  }


}   

void update_H_mus(State &state, const Data &y, const Prior &prior) {
  const int J = get_J(y);
  const int K = state.K;

  for (int j=0; j<J; j++) {
    for (int k=0; k<K; k++) {
      update_Hjk_mus_jk(state, y, prior, j, k);
    }
  }

}

