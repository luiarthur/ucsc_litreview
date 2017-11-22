double compute_bk(const State &state, int k) {
  // k is the index of the array

  double b_k = 1;

  for (int l=0; l<=k; l++) {
    b_k *= state.v(l);
  }

  return b_k;
}

arma::vec compute_b(const State &state) {
  return arma::cumprod(state.v);
}



void update_vk(State &state, const Data &y, const Prior &prior, int k) {
  auto log_fc = [&](double logit_vk) {
    const double lp = lp_logit_beta(logit_vk, prior.alpha, 1);
    double ll = 0;

    const int I = get_I(y);
    const int J = get_J(y);
    const auto N = get_N(y);

    double h_jl;
    double G_jj;
    int z_jlin;
    int lin;

    arma::vec v_tmp(state.K);
    for (int l=0; l<state.K; l++) {
      v_tmp[l] = (l == k) ? inv_logit(logit_vk) : state.v[l];
    }
    const arma::vec b = arma::cumprod(v_tmp);

    for (int i=0; i<I; i++) {
      for (int j=0; j<J; j++) {
        G_jj = prior.G(j,j);
        for (int n=0; n<N[i]; n++) {
          lin = state.lam[i][n];
          if (lin >= k) {
            h_jl = state.H(j,lin);
            z_jlin = compute_zjk(h_jl, G_jj, b[lin]);
            ll += ll_fz(state, y, i, n, j, z_jlin);
          }
        }
      }
    }

    return lp + ll;
  };

  const double logit_vk = logit(state.v(k));
  state.v[k] = inv_logit(metropolis::uni(logit_vk, log_fc, prior.cs_v));
}

void update_v(State &state, const Data &y, const Prior &prior) {
  const int K = state.K;
  const int J = get_J(y);
  double bk;
  
  for (int k=0; k<K; k++) {
    update_vk(state, y, prior, k);
    bk = compute_bk(state, k);
    for (int j=0; j<J; j++) {
      state.Z(j,k) = compute_zjk(state.H(j,k), prior.G(j,j), bk);
    }
  }
}
