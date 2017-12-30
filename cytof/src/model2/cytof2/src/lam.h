void update_lin(State &state, const Data &y, const Prior &prior,
                const int i, const int n) {

  const int J = get_J(y);
  const int K = state.K;

  // use metropolis with aux variable to speed up?
  double log_p[K];

  for (int k=0; k<K; k++) {
    log_p[k] = log(state.W(i, k));
    for (int j=0; j<J; j++) {
      log_p[k] += ll_fz(state, y, i, n, j, state.Z(j,k));
    }
  }

  state.lam[i][n] = wsample_index_log_prob(log_p, K);
}

void update_lam(State &state, const Data &y, const Prior &prior) {
  const int I = get_I(y);
  const auto N = get_N(y);

  // TODO: Parallelize?
  for (int i=0; i<I; i++) {
    for (int n=0; n<N[i]; n++) {
      update_lin(state, y, prior, i, n);
    }
  }
}

// TODO: CHECK IF THESE FUNCTIONS MAKE SENSE (FOR RANDOM K)
type_lam sample_lam_prior(const arma::mat &W, const Data &y) {
  const int I = get_I(y);
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

type_lam get_lam_TE(const type_lam &lam, const Data_idx data_idx) {
  const int I = get_I(y_TE);
  type_lam lam_TE(I);

  for (int i=0; i<I; i++) {
    const int Ni_TE = get_Ni(y_TE, i);
    lam_TE[i] = lam[i].subvec(data_idx.idx_TE[i]);
  }

  return lam_TE;
}
