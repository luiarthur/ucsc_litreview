// Updating tau^2_j. See Section 5.3 of manual.

// Multivariate Update Implementation for tau2
void update_tau2(State &state, const Data &y, const Prior &prior) {
  const int J = get_J(y);
  const int K = state.K;
  const double thresh = prior.mus_thresh; // log(2)
  double mus_jk;

  auto log_fc = [&](arma::vec log_tau2) {
    double lp = 0;
    for (int j=0; j<J; j++) {
      lp += lp_log_invgamma(log_tau2(j), prior.a_tau, prior.b_tau);
    }

    double ll = 0;
    for (int j=0; j<J; j++) {
      double tau_j = sqrt(exp(log_tau2(j)));
      double psi_j = state.psi(j);

      for (int k=0; k < K; k++) {
        mus_jk = state.mus(j,k);

        if (state.Z(j,k) == 1 && mus_jk >= thresh) {
          ll += log_dtnorm(mus_jk, psi_j, tau_j, thresh, false); // lt = false
        } else if (state.Z(j,k) == 0 && mus_jk < thresh) {
          ll += log_dtnorm(mus_jk, psi_j, tau_j, thresh, true); // lt = true
        } else {
          ll = -INFINITY;
          Rcout << "This should not happen (tau.h)" << std::endl;
          break;
        }

      }
    }

    return ll + lp;
  };

  state.tau2 = exp(metropolis::mv(log(state.tau2), 
                                  log_fc,  prior.cs_tau2(0)*arma::eye<arma::mat>(J,J) ));
}

//Univariate Update of tau2. Poor Mixing.
//
//double log_fc_log_tau2(double log_tau2_j, State &state, const Data &y,
//                       const Prior &prior, const int j) {
//  const int K = state.K;
//  const double thresh = prior.mus_thresh; // log(2)
//  double mus_jk;
//  const double psi_j = state.psi(j);
//  const double tau_j = sqrt(exp(log_tau2_j));
//  const double lp = lp_log_invgamma(log_tau2_j, prior.a_tau, prior.b_tau);
//
//  double ll=0;
//  for (int k=0; k < K; k++) {
//    mus_jk = state.mus(j,k);
//    //ll += log_dtnorm(mus_jk, psi_j, tau_j, thresh, 1-state.Z(j,k)); // lt = false
//    if (state.Z(j,k) == 1 && mus_jk >= thresh) {
//      ll += log_dtnorm(mus_jk, psi_j, tau_j, thresh, false); // lt = false
//    } else if (state.Z(j,k) == 0 && mus_jk < thresh) {
//      ll += log_dtnorm(mus_jk, psi_j, tau_j, thresh, true); // lt = true
//    } else {
//      ll = -INFINITY;
//      Rcout << "This should not happen (tau.h)" << std::endl;
//      break;
//    }
//
//  }
//
//  return ll + lp;
//};
//
//void update_tau2(State &state, const Data &y, const Prior &prior) {
//
//  const int J = get_J(y);
//  for (int j=0; j < J; j++) {
//
//    auto log_fc = [&](double log_tau2_j) {
//      return log_fc_log_tau2(log_tau2_j, state, y, prior, j);
//    };
//
//    state.tau2(j) = exp(metropolis::uni(log(state.tau2(j)), 
//                                        log_fc, prior.cs_tau2[j]));
//  }
//
//};

