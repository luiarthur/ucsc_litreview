/* Updating mu^\star_{jk}. See Section 5.1 of manual.
 *
 * The signature for R::pnorm is x,m,s,
 *
 *    double pnorm(double x, double mu, double sigma, int lt, int lg) 
 *
 * where lt=1 => less than
 *       lg=1 => log CDF
 */

// TODO: check this
double rmus(double psi, double tau, int z, double thresh) {
  double draw;

  if (z == 1) {
    draw = rtnorm(psi, tau, thresh, INFINITY);
  } else {
    draw = rtnorm(psi, tau, -INFINITY, thresh);
  }

  return draw;
}

double lp_mus(double mus_jk, State &state, const Data &y, const Prior &prior,
              const int j, const int k) {
  const double tau_j = sqrt(state.tau2(j));
  const double psi_j = state.psi(j);
  const double z_jk = state.Z(j,k);

  double lp;
  const double thresh = prior.mus_thresh;
  if (mus_jk >= thresh && z_jk == 1) {
    lp = log_dtnorm(mus_jk, psi_j, tau_j, thresh, false); //lt=false
  } else if (mus_jk < thresh && z_jk == 0) {
    lp = log_dtnorm(mus_jk, psi_j, tau_j, thresh, true);  //lt=true
  } else {
    //Rcout << "This shouldn't be happening! (mus.h)"<< std::endl;
    lp = -INFINITY;
  }

  return lp;
}


double ll_mus(double mus_jk, State &state, const Data &y, const Prior &prior,
              const int j, const int k) {

  const int I = get_I(y);
  //const double thresh = prior.mus_thresh;
  //int N_i;
  //double sig_i;

  double ll = 0;

//#pragma omp parallel for
  for (int i=0; i<I; i++) {
    for (int n=0; n<get_Ni(y,i); n++) {
      //if (state.e[i](n,j) == 0 && state.lam[i][n] == k) {
      //  ll += log_dtnorm(y[i](n,j), mus_jk, sig_i, 0, false); //lt=false
      //}
      if (state.lam[i][n] == k) {
        ll += marginal_lf(y[i](n,j), mus_jk, sqrt(state.sig2[i]), state.Z(j,k), state.pi(i,j));
      }
    }
  }

  // sequential:
  //for (int i=0; i<I; i++) {
  //  N_i = get_Ni(y,i);
  //  sig_i = sqrt(state.sig2[i]);
  //  for (int n=0; n<N_i; n++) {
  //    //if (state.e[i](n,j) == 0 && state.lam[i][n] == k) {
  //    //  ll += log_dtnorm(y[i](n,j), mus_jk, sig_i, 0, false); //lt=false
  //    //}
  //    if (state.lam[i][n] == k) {
  //      ll += marginal_lf(y[i](n,j), mus_jk, sig_i, state.Z(j,k), state.pi(i,j));
  //    }
  //  }

  //}

  return ll;
}

double log_fc_mus(double mus_jk, State &state, const Data &y, 
                  const Prior &prior, const int j, const int k) {
  const double lp = lp_mus(mus_jk, state, y, prior, j, k);
  const double ll = (lp > -INFINITY) ? ll_mus(mus_jk, state, y, prior, j ,k) : 0;
  return ll + lp;
};


void update_mus(State &state, const Data &y, const Prior &prior) {

  const int J = get_J(y);
  const int K = state.K;
  //const double thresh = prior.mus_thresh;
  //double mus_jk;
  //int z_jk;
  //double cs;
  //double acc_prob;

  for (int j = 0; j < J; j++) {
    for (int k = 0; k < K; k++) {

      auto log_fc = [&](double mus_jk) {
        //return log_fc_mus(mus_jk, state, y, prior, j, k);
        auto out =  log_fc_mus(mus_jk, state, y, prior, j, k);
        //Rcout << out <<std::endl;
        return out;
      };


      state.mus(j,k) = metropolis::uni(state.mus(j,k), log_fc, prior.cs_mu(j,k));

      // new version
      //mus_jk = state.mus(j,k);
      //z_jk = state.Z(j,k);
      //cs = prior.cs_mu[j,k];
      //const bool valid = ( (mus_jk >= thresh) && (z_jk == 1) ) ||
      //                   ( (mus_jk <  thresh) && (z_jk == 0) );

      //double cand;
      //if (valid) {
      //  // sample with random walk
      //  if (z_jk == 1) {
      //    cand = rtnorm(mus_jk, cs, thresh, INFINITY);
      //  } else {
      //    cand = rtnorm(mus_jk, cs, -INFINITY, thresh);
      //  }
      //} else {
      //  // sample from prior
      //  cand = rmus(state.psi(j), state.tau2(j), z_jk, thresh);
      //}

      //const double u = R::runif(0,1);

      //// compute acceptance probability
      //if (valid) {
      //  acc_prob = log_fc_mus(cand,   state, y, prior, j, k) + 
      //             log_dtnorm(mus_jk, cand, cs, thresh, z_jk==0) -
      //             log_fc_mus(mus_jk, state, y, prior, j, k) - 
      //             log_dtnorm(cand, mus_jk, cs, thresh, z_jk==0);
      //} else {
      //  // prior cancels with proposal
      //  acc_prob = ll_mus(cand,   state, y, prior, j ,k) -
      //             ll_mus(mus_jk, state, y, prior, j ,k);
      //}

      //if (acc_prob > log(u)) {
      //  state.mus(j,k) = cand;
      //}
      // end of new version

    }
  }

};

