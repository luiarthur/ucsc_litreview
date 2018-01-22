void update_K_theta(State &state,
                    const Data &y, const Data_idx &data_idx,
                    const Fixed &fixed_param,
                    const Prior &prior, std::vector<State> &thetas,
                    int thin_K=5) {

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


  // current K
  const int K_curr = state.K;
  // proposed K
  const int K_cand = sample_k(K_curr);

  const int I = get_I(y);
  const int J = get_J(y);

  // current theta
  // Should current state be full theta? or theta_TR_curr?
  State curr_theta = state;
  curr_theta.lam = get_lam_TE(state.lam, data_idx);
  curr_theta.missing_y = get_missing_y_TE(state.missing_y, data_idx);
  const auto y_TR = get_missing_y_TR(state.missing_y, data_idx);

  /* propose a new theta_K */
  thetas[K_cand - K_min].missing_y = y_TR;

  for (int t=0; t<thin_K; t++) {
    update_theta_no_K(thetas[K_cand - K_min], y_TR, prior, fixed_param, false);
  }

  // Proposed theta
  State proposed_theta = thetas[K_cand - K_min];
  proposed_theta.missing_y = curr_theta.missing_y;

  // Compute acceptance probability
  double log_acc_prob = lq_k_from(K_cand) - lq_k_from(K_curr);
  const double l1 = loglike_marginal(proposed_theta, curr_theta.missing_y, prior);
  const double l2 = loglike_marginal(curr_theta, curr_theta.missing_y, prior);
  log_acc_prob += l1 - l2;

  const double u = R::runif(0, 1);

  Rcout << "l1: " << l1 << ", l2: " << l2 << ", ratio: " << log_acc_prob << ", curr_K: "<< K_curr << ", cand_K: " << K_cand << ", K_new: " << (log_acc_prob > log(u) ? K_cand : K_curr) << std::endl;

  //if (log_acc_prob > log(u)) {
  if (log_acc_prob > log(u)) {
    // Update missing_y and lam because the dimensions need to be imputed
    proposed_theta.missing_y = state.missing_y;
    proposed_theta.lam = state.lam;

    state = proposed_theta;
    for (int t=0; t<thin_K; t++) {
      update_lam(state, y, prior);
      update_missing_y(state, y, prior);
    }
  }

  //Rcout << "HERE9" << std::endl;
}
