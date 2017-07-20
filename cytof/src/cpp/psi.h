// Updating psi_j. See Section 5.2 of manual.

// Multivariate Update Implementation for psi
void update_psi(State &state, const Data &y, const Prior &prior) {
  const int J = get_J(y);
  const int K = state.K;
  double mus_jk;
  double thresh = prior.mus_thresh;

  auto log_fc = [&](arma::vec psi) {
    double ll = 0;

    for (int j=0; j<J; j++) {
      double tau_j = sqrt(state.tau2(j));
      double psi_j = psi(j);

      for (int k=0; k < K; k++) {
        mus_jk = state.mus(j,k);

        if (state.Z(j,k) == 1 && mus_jk >= thresh) {
          ll += log_dtnorm(mus_jk, psi_j, tau_j, thresh, false); // lt = false
        } else if (state.Z(j,k) == 0 && mus_jk < thresh) {
          ll += log_dtnorm(mus_jk, psi_j, tau_j, thresh, true); // lt = true
        } else {
          ll = -INFINITY;
          Rcout << "This should not happen (psi.h)" << std::endl;
          break;
        }

      }
    }

    double lp = 0;
    for (int j=0; j<J; j++) {
      lp += R::dnorm(psi(j), prior.m_psi, sqrt(prior.s2_psi), 1);
    }

    return ll + lp;
  };


  state.psi = metropolis::mv(state.psi, log_fc, prior.cs_psi(0)*arma::eye<arma::mat>(J,J));
};

// Univariate Update Implementation: Poor Mixing.
//
//double log_fc_psi(double psi_j, State &state, const Data &y,
//                  const Prior &prior, const int j) {
//
//  double lp = R::dnorm(psi_j, prior.m_psi, sqrt(prior.s2_psi), 1);
//  const int K = state.K;
//  double mus_jk;
//  double tau_j = sqrt(state.tau2(j));
//  double thresh = prior.mus_thresh;
//
//  double ll = 0;
//  for (int k=0; k < K; k++) {
//    mus_jk = state.mus(j,k);
//
//    if (state.Z(j,k) == 1 && mus_jk >= thresh) {
//      ll += log_dtnorm(mus_jk, psi_j, tau_j, thresh, false); // lt = false
//    } else if (state.Z(j,k) == 0 && mus_jk < thresh) {
//      ll += log_dtnorm(mus_jk, psi_j, tau_j, thresh, true); // lt = true
//    } else {
//      ll = -INFINITY;
//      Rcout << "This should not happen (psi.h)" << std::endl;
//      break;
//    }
//
//  }
//
//  return ll + lp;
//};
//
//void update_psi(State &state, const Data &y, const Prior &prior) {
//
//  const int J = get_J(y);
//  for (int j=0; j < J; j++) {
//
//    auto log_fc = [&](double psi_j) {
//      return log_fc_psi(psi_j, state, y, prior, j);
//    };
//
//    state.psi(j) = metropolis::uni(state.psi(j), log_fc, prior.cs_psi[j]);
//  }
//
//};

