void update_beta1j(State &state, const Data &y, const Prior &prior, int j) {
  auto log_fc = [&](double log_b1j) {
    const double lp = lp_log_gamma(log_b1j, prior.a_beta, prior.b_beta);
    const double b1j = exp(log_b1j);

    const int I = get_I(y);
    const auto N = get_N(y);
    double ll = 0;

    for (int i=0; i<I; i++) {
      for (int n=0; n<N[i]; n++) {
        ll += ll_p_given_beta(state, y, state.beta_0(i,j), b1j, i, n ,j);
      }
    }

    return lp + ll;
  };

  const double log_b1j= log(state.beta_1[j]);
  state.beta_1[j] = exp(metropolis::uni(log_b1j, log_fc, prior.cs_beta1j));
}

void update_beta0ij(State &state, const Data &y, const Prior &prior, int i, int j) {
  auto log_fc = [&](double b0ij) {
    const int lg = 1; // log density
    const double lp = R::dnorm(b0ij, state.betaBar_0[j], sqrt(prior.s2_beta0), lg);

    const int Ni = get_Ni(y, i);
    const double b1j = state.beta_1[j];
    double ll = 0;

    for (int n=0; n<Ni; n++) {
      ll += ll_p_given_beta(state, y, b0ij, b1j, i, n ,j);
    }

    return lp + ll;
  };

  const double b0ij = state.beta_0(i,j);
  state.beta_0(i,j) = metropolis::uni(b0ij, log_fc, prior.cs_beta0);
  //Rcout << "Updated beta0" << i << j << ": " << state.beta_0(i,j) << std::endl;
}

void update_betaBar0j(State &state, const Data &y, const Prior &prior, int j) {
  const int I = get_I(y);

  double sum_b0ij = 0;
  for (int i=0; i<I; i++) {
    sum_b0ij += state.beta_0(i,j);
  }

  const double var_denom = prior.s2_betaBar * I + prior.s2_beta0;
  const double new_mean = prior.s2_beta0 * sum_b0ij / var_denom;
  const double new_var = prior.s2_betaBar * prior.s2_beta0 / var_denom;

  state.betaBar_0[j] = R::rnorm(new_mean, sqrt(new_var));
}

void update_beta(State &state, const Data &y, const Prior &prior) {
  const int I = get_I(y);
  const int J = get_J(y);

  for (int j=0; j<J; j++) {
    update_betaBar0j(state, y, prior, j);
    update_beta1j(state, y, prior, j);
    for (int i=0; i<I; i++) {
      update_beta0ij(state, y, prior, i, j);
    }
  }
}

