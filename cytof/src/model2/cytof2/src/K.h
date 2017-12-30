//void update_K_theta(State &state, 
//                    const Data &y, const Data_idx &data_idx,
//                    const Fixed &fixed_param,
//                    const Prior &prior, std::vector<State> &thetas) {
//
//  // Propose K, theta
//  const int K_min = prior.K_min;
//  const int K_max = prior.K_max;
//  const int a = prior.a_K;
//  
//  auto sample_k = [K_max, K_min, a](int K) {
//    int out;
//
//    if ( (a + K_min <= K) && (K <= K_max - a) ) {
//      out = runif_discrete(K - a, K + a);
//    } else if (K - a < K_min) {
//      out = runif_discrete(K_min, K + a);
//    } else { // K + a > K_max
//      out = runif_discrete(K - a, K_max);
//    }
//
//    return out;
//  };
//
//  // log proposal density (from K)
//  auto lq_k_from = [K_max, K_min, a](int K) {
//    double out;
//
//    if ( (a + K_min <= K) && (K <= K_max - a) ) {
//      out = -log(2 * a + 1);
//    } else if (K - a < K_min) {
//      out = -log(K + a - K_min + 1);
//    } else { // K + a > K_max
//      out = -log(K_max - K + a + 1);
//    }
//
//    return out;
//  };
//
//
//  // current K
//  const int K_curr = state.K;
//  // proposed K
//  const int K_cand = sample_k(K_curr);
//
//  const int I = get_I(y);
//  const int J = get_J(y);
//
//  // current theta
//  const auto curr_lam = state.lam;
//  state.lam = get_lam_TE(curr_lam, data_idx);
//
//  const auto curr_missing_y = state.missing_y;
//  state.missing_y = get_missing_y_TE(state.missing_y, data_idx);
//  // swap back later
//
//
//  /* propose a new theta_K */
//  //Rcout << "K_cand: " << K_cand << std::endl;
//  //Rcout << "K_curr: " << K_curr << std::endl;
//  update_theta(thetas[K_cand - K_min], data_idx.y_TR, prior, fixed_param, false);
//  //Rcout << "HERE1" << std::endl;
//  State *proposed_theta = &thetas[K_cand - K_min];
//
//  //Rcout << "HERE2" << std::endl;
//  // proposed lambda
//  const auto proposed_lam_TR = proposed_theta->lam;
//  const auto proposed_lam_ALL = sample_lam_prior(proposed_theta->W, y);
//  const auto proposed_lam_TE = get_lam_TE(proposed_lam_ALL, data_idx);
//  proposed_theta->lam = proposed_lam_ALL;
//  //Rcout << "HERE3" << std::endl;
//  // proposed missing_y
//  const auto proposed_missing_y_TR = proposed_theta->missing_y;
//  //Rcout << "HERE4a" << std::endl;
//  const auto proposed_missing_y_ALL = sample_missing_y_prior(*proposed_theta, y);
//  //Rcout << "HERE4b" << std::endl;
//  const auto proposed_missing_y_TE = get_missing_y_TE(proposed_missing_y_ALL, data_idx);
//
//  // Proposed theta
//  proposed_theta->lam = proposed_lam_TE;
//  proposed_theta->missing_y = proposed_missing_y_TE;
//
//  // Compute acceptance probability
//  double log_acc_prob = lq_k_from(K_cand) - lq_k_from(K_curr);
//  //Rcout << "HERE6" << std::endl;
//  log_acc_prob += loglike(*proposed_theta, data_idx.y_TE);
//  //Rcout << "HERE7" << std::endl;
//  log_acc_prob -= loglike(state, data_idx.y_TE);
//  //Rcout << "HERE8" << std::endl;
//
//  //Rcout << "lq_k_from(K_cand)" << lq_k_from(K_cand) << std::endl;
//  //Rcout << "lq_k_from(K_curr)" << lq_k_from(K_curr) << std::endl;
//  //Rcout << "m(cand)" << marginal_lf_all(*proposed_theta, y_TE, prior) << std::endl;
//  //Rcout << "m(curr)" << marginal_lf_all(state, y_TE, prior) << std::endl;
//
//  const double u = R::runif(0, 1);
//
//  //Rcout << "log_acc_prob" << log_acc_prob << std::endl;
//  if (log_acc_prob > log(u)) {
//    // swap back the states
//    proposed_theta->lam = proposed_lam_ALL;
//    proposed_theta->missing_y = proposed_missing_y_ALL;
//    state = *proposed_theta;
//  } else {
//    state.lam = curr_lam;
//    state.missing_y = curr_missing_y;
//  }
//  proposed_theta->lam = proposed_lam_TR;
//  proposed_theta->missing_y = proposed_missing_y_TR;
//
//  //Rcout << "HERE9" << std::endl;
//}

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
  const auto curr_lam = state.lam;
  state.lam = get_lam_TE(curr_lam, data_idx);

  const auto curr_missing_y = state.missing_y;
  state.missing_y = get_missing_y_TE(state.missing_y, data_idx);
  // swap back later


  /* propose a new theta_K */
  update_theta(thetas[K_cand - K_min], data_idx.y_TR, prior, fixed_param, false);

  // Sample new theta_ALL, theta_TE
  State *proposed_theta_TR = &thetas[K_cand - K_min];
  State proposed_theta_ALL = thetas[K_cand - K_min];
  State proposed_theta_TE = thetas[K_cand - K_min];

  // Update proposed_theta_ALL
  proposed_theta_ALL.lam = sample_lam_prior(proposed_theta_TR->W, y);
  proposed_theta_ALL.missing_y = sample_missing_y_prior(proposed_theta_ALL, y);

  for (int t=0; t<thin_K; t++) {
    update_missing_y(proposed_theta_ALL, y, prior);
    update_lam(proposed_theta_ALL, y, prior);
  }

  // Update proposed_theta_TE
  proposed_theta_TE.lam = get_lam_TE(proposed_theta_ALL.lam, data_idx);
  proposed_theta_TE.missing_y = get_missing_y_TE(proposed_theta_ALL.missing_y, data_idx);

  // Compute acceptance probability
  double log_acc_prob = lq_k_from(K_cand) - lq_k_from(K_curr);
  log_acc_prob += loglike(proposed_theta_TE, data_idx.y_TE);
  log_acc_prob -= loglike(state, data_idx.y_TE);

  const double u = R::runif(0, 1);

  //Rcout << "log_acc_prob: " << log_acc_prob << std::endl;
  //Rcout << "log_u:        " << log(u) << std::endl;
  if (log_acc_prob > log(u)) {
    // swap back the states
    state = proposed_theta_ALL;
  } else {
    state.lam = curr_lam;
    state.missing_y = curr_missing_y;
  }

  //Rcout << "HERE9" << std::endl;
}
