/* Updating mu^\star_{jk}. See Section 5.1 of manual.
 *
 * The signature for R::pnorm is x,m,s,
 *
 *    double pnorm(double x, double mu, double sigma, int lt, int lg) 
 *
 * where lt=1 => less than
 *       lg=1 => log CDF
 */

double log_fc_mus(double mus_jk, State &state, const Data &y, 
                  const Prior &prior, const int j, const int k) {

  double z;
  const double tau_j = sqrt(state.tau2(j));
  const double psi_j = state.psi(j);
  const int I = get_I(y);
  int N_i;

  double lp;
  const double thresh = prior.mus_thresh;
  if (mus_jk > thresh && state.Z(j,k) == 1) {
    lp = log_dtnorm(mus_jk, psi_j, tau_j, thresh, false); //lt=false
  } else if (mus_jk < thresh && state.Z(j,k) == 0) {
    lp = log_dtnorm(mus_jk, psi_j, tau_j, thresh, true);  //lt=true
  } else {
    lp = -INFINITY;
  }

  double ll = 0;
  double sig_i;
  if (lp > -INFINITY) {
    for (int i=0; i<I; i++) {
      N_i = get_Ni(y,i);
      sig_i = sqrt(state.sig2[i]);
      for (int n=0; n<N_i; n++) {
        if (state.e[i](n,j) == 0 && state.lam[i][n] == k) {
          ll += log_dtnorm(y[i](n,j), mus_jk, sig_i, 0, false); //lt=false
        }
      }

    }
  }

  return lp + ll;
};


void update_mus(State &state, const Data &y, const Prior &prior) {

  const int J = get_J(y);
  const int K = state.K;
  const double thresh = prior.mus_thresh;

  for (int j = 0; j < J; j++) {
    for (int k = 0; k < K; k++) {

      auto log_fc = [&](double mus_jk) {
        //return log_fc_mus(mus_jk, state, y, prior, j, k);
        auto out =  log_fc_mus(mus_jk, state, y, prior, j, k);
        //Rcout << out <<std::endl;
        return out;
      };


      state.mus(j,k) = metropolis::uni(state.mus(j,k), log_fc, prior.cs_mu[j,k]);

      // new version
      //auto log_dq = [&](double a, double b) {
      //  return log_dtnorm(a, b, prior.cs_mu[j], thresh, state.Z[j,k]==0);
      //};

      //const double curr = state.mus(j,k);
      //const double cand = state.Z(j,k) == 0 ? 
      //                    rtnorm(curr, prior.cs_mu[j], -INFINITY, thresh) :
      //                    rtnorm(curr, prior.cs_mu[j], thresh, INFINITY);
      //const double log_acc = log_fc(cand) - log_fc(curr) + 
      //                       log_dq(curr,cand) - log_dq(cand,curr);

      //if (log_acc > log(R::runif(0,1))) {
      //  state.mus(j,k) = cand;
      //} // end of new version

    }
  }

};


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
