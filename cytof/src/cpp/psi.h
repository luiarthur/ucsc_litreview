// Updating psi_j. See Section 5.2 of manual.

double log_fc_psi(double psi_j, State &state, const Data &y,
                  const Prior &prior, const int j) {

  double lp = R::dnorm(psi_j, prior.m_psi, sqrt(prior.s2_psi), 1);
  const int K = state.K;
  double mus_jk;
  double tau_j = sqrt(state.tau2(j));
  double thresh = prior.mus_thresh;
  double ll;
  
  for (int k=0; k < K; k++) {
    mus_jk = state.mus(j,k);

    if (state.Z(j,k) == 1) {
      ll = log_dtnorm(mus_jk, psi_j, tau_j, thresh, 0); // lt = false
    } else { // state.Z(j,k) == 0
      ll = log_dtnorm(mus_jk, psi_j, tau_j, thresh, 1); // lt = true
    }

  }

  return ll + lp;
};

void update_psi(State &state, const Data &y, const Prior &prior) {

  const int J = get_J(y);
  for (int j=0; j < J; j++) {

    auto log_fc = [&](double psi_j) {
      return log_fc_psi(psi_j, state, y, prior, j);
    };

    state.psi(j) = metropolis::uni(state.psi(j), log_fc, prior.cs_psi);
  }

};
