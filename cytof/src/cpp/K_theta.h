// Updating K & theta. See Section 5.13.1 of manual

double marginal_lf_all(const State &state, const Data &y,
                       const Prior &prior) {
  double out = 0;
  const int I = get_I(y);
  const int J = get_J(y);
  int N_i;
  int lin;
  double sig_i;
  double mus_jlin;
  int z_jlin;
  double pi_ij;

  for (int i=0; i<I; i++) {
    N_i = get_Ni(y, i);
    sig_i = sqrt(state.sig2[i]);
    for (int j=0; j<J; j++) {
      pi_ij = state.pi(i,j);
      for (int n=0; n<N_i; n++) {
        lin = state.lam[i][n];
        mus_jlin = state.mus(j,lin);
        z_jlin = state.Z(j,lin); 
        out += marginal_lf(y[i](n,j), mus_jlin, sig_i, z_jlin, pi_ij);
      }
    }
  }

  return out;
}

void update_K_theta(State &state, 
                    const Data &y_TR, const Data &y_TE, const Data &y,
                    const Prior &prior, std::vector<State> &thetas) {

  // Propose K, theta
  const int K_min = prior.K_min;
  const int K_max = prior.K_max;
  const int a = prior.a_K;
  
  auto sample_k = [K_max, K_min, a](int K) {
    int out;

    if ( (a + K_min <= K) && (K <= K_max - a) ) {
      out = runif_discrete(K - a, K + a);
    } else if (K - a < K_min) {
      out = runif_discrete(K_min, K + a);
    } else { // K + a > K_max
      out = runif_discrete(K - a, K_max);
    }

    return out;
  };

  // log proposal density (from K)
  auto lq_k_from = [K_max, K_min, a](int K) {
    double out;

    if ( (a + K_min <= K) && (K <= K_max - a) ) {
      out = -log(2 * a + 1);
    } else if (K - a < K_min) {
      out = -log(K + a - K_min + 1);
    } else { // K + a > K_max
      out = -log(K_max - K + a + 1);
    }

    return out;
  };

  const int K_curr = state.K;
  const int K_cand = sample_k(K_curr);

  // TODO: Check all this to the end
  double log_acc_prob = lq_k_from(K_cand) - lq_k_from(K_curr);

  adjust_lam_e_dim(thetas[K_curr-K_min], y_TE, prior);
  log_acc_prob -= marginal_lf_all(thetas[K_curr-K_min], y_TE, prior);
  adjust_lam_e_dim(thetas[K_curr-K_min], y_TR, prior);

  // propose a new theta_K
  update_theta(thetas[K_cand - K_min], y_TR, prior);
  adjust_lam_e_dim(thetas[K_cand-K_min], y_TE, prior);
  log_acc_prob += marginal_lf_all(thetas[K_cand-K_min], y_TE, prior);
  adjust_lam_e_dim(thetas[K_cand-K_min], y_TR, prior);

  const double u = R::runif(0, 1);

  if (log_acc_prob > log(u)) {
    state = thetas[K_cand - K_min];
    // update lambda and e because the dimensions depends on dimensions
    // of the full data
    adjust_lam_e_dim(state, y, prior);
  }
}
