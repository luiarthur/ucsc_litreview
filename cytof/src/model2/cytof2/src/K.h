void update_K_theta(State &state, 
                    const Data &y_TE, const Data &y_TR, const Data &y,
                    const Fixed &fixed_param,
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


  // current K
  const int K_curr = state.K;
  // proposed K
  const int K_cand = sample_k(K_curr);

  const int I = get_I(y);
  const int J = get_J(y);

  // current theta
  const auto curr_lam = state.lam;
  state.lam = get_lam_TE(curr_lam, y_TE);
  // swap back later


  /* propose a new theta_K */
  //Rcout << K_cand;
  update_theta(thetas[K_cand - K_min], y_TR, prior, fixed_param, false);
  auto *proposed_theta = &thetas[K_cand - K_min];

  // proposed lambda
  const auto proposed_lam_TR = proposed_theta->lam;
  const auto proposed_lam_ALL = sample_lam_prior(proposed_theta->W, y);
  const auto proposed_lam_TE = get_lam_TE(proposed_lam_ALL, y_TE);

  // Compute acceptance probability
  proposed_theta->lam = proposed_lam_TE;

  double log_acc_prob = lq_k_from(K_cand) - lq_k_from(K_curr);
  log_acc_prob += loglike(*proposed_theta, y_TE);
  log_acc_prob -= loglike(state, y_TE);

  //Rcout << "lq_k_from(K_cand)" << lq_k_from(K_cand) << std::endl;
  //Rcout << "lq_k_from(K_curr)" << lq_k_from(K_curr) << std::endl;
  //Rcout << "m(cand)" << marginal_lf_all(*proposed_theta, y_TE, prior) << std::endl;
  //Rcout << "m(curr)" << marginal_lf_all(state, y_TE, prior) << std::endl;

  const double u = R::runif(0, 1);

  //Rcout << "log_acc_prob" << log_acc_prob << std::endl;
  if (log_acc_prob > log(u)) {
    // swap back the states
    proposed_theta->lam = proposed_lam_ALL;
    state = *proposed_theta;
  } else {
    state.lam = curr_lam;
  }
}
