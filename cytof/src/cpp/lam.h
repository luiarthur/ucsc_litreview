// Updating lam_{in}. See Section 5.8 of manual.

double update_lin(State &state, const Data &y, const Prior &prior,
                  const int i, const int n) {

  const int J = get_J(y);
  const int K = state.K;
  double x;
  int z_jk;
  double pi_ij;

  // use metropolis with aux variable to speed up?
  double log_p[K];

  for (int k=0; k<K; k++) {
    log_p[k] = log(state.W(i, k));
    for (int j=0; j<J; j++) {
      pi_ij = state.pi(i,j);
      z_jk = state.Z(j,k);
      log_p[k] += marginal_lf(y[i](n,j), state.mus(j,k),
                              sqrt(state.sig2[i]), z_jk, pi_ij);
    }
  }

  return wsample_index_log_prob(log_p, K);
}

void update_lam(State &state, const Data &y, const Prior &prior) {

  const int I = get_I(y);
  int N_i;
  for (int i=0; i<I; i++) {
    N_i = get_Ni(y,i);
    for (int n=0; n<N_i; n++) {
      state.lam[i][n] = update_lin(state, y, prior, i, n);
    }
  }
}

type_lam sample_lam_prior(const arma::mat &W, const Data &y) {
  const int I = get_I(y);
  const int K = W.n_cols;
  type_lam lam(I);

  for (int i=0; i<I; i++) {
    const int N_i = get_Ni(y, i);
    lam[i].resize(N_i);
    for (int n=0; n<N_i; n++) {
      lam[i][n] = wsample_index_vec(W.row(i).t()); // don't add 1
    }
  }
  
  return lam;
}

type_lam get_lam_TE(const type_lam &lam, const Data &y_TE) {
  const int I = get_I(y_TE);
  type_lam lam_TE(I);

  for (int i=0; i<I; i++) {
    const int Ni_TE = get_Ni(y_TE, i);
    lam_TE[i].resize(Ni_TE);
    for (int n=0; n<Ni_TE; n++) {
      lam_TE[i][n] = lam[i][n];
    }
  }

  return lam_TE;
}
