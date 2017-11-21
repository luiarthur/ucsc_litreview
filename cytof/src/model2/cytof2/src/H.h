void update_Hjk(State &state, const Data &y, const Prior &prior, int j, int k, double mj, double S2j) {
  auto log_fc = [&](double h_jk) {
    const double lp = R::dnorm(h_jk, mj, sqrt(S2j), 1); // 1 -> log density
    double ll = 0;

    const int I = get_I(y);
    const auto N = get_N(y);

    const double G_jj = prior.G[j,j];
    const auto b = compute_b(state);
    int z_jlin;

    for (int i=0; i<I; i++) {
      for (int n=0; n<N[i]; n++) {
        if (state.lam[i][n] == k) {
          z_jlin = compute_zjk(h_jk, G_jj, b[k]);
          ll += ll_fz(state, y, i, n, j, z_jlin);
        }
      }
    }

    return lp + ll;
  };

  const double h_jk = state.H[j,k];
  state.H[j,k] = metropolis::uni(h_jk, log_fc, prior.cs_h);
}

void update_H(State &state, const Data &y, const Prior &prior) {
  const int J = get_J(y);
  const int K = state.K;

  for (int j=0; j<J; j++) {
    const auto j_idx = arma::regspace<arma::vec>(0, J-1);
    const arma::uvec minus_j = arma::find(j_idx != j);
    for (int k=0; k<K; k++) {
      arma::uvec at_k; at_k << k;
      const arma::vec mj = prior.R.row(j) * state.H(minus_j, at_k);
      update_Hjk(state, y, prior, j, k, mj(0), prior.S2(j));
    }
  }
}


