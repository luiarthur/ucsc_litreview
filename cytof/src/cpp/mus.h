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
  double tau_j = sqrt(state.tau2(j));
  const int I = get_I(y);
  int N_i;

  double out = -INFINITY;
  const double thresh = prior.mus_thresh;
  if (mus_jk > thresh && state.Z(j,k) == 1) {
    out = log_dtnorm(mus_jk, state.psi(j), tau_j, thresh, 0);
  } else if (mus_jk < thresh && state.Z(j,k) == 0) {
    out = log_dtnorm(mus_jk, state.psi(j), tau_j, thresh, 1);
  }

  for (int i=0; i<I; i++) {
    N_i = get_Ni(y,i);

    for (int n=0; n<N_i; n++) {

      if (state.e[i](n,j) == 0 && state.lam[i][n] == k) {
        out += log_dtnorm(y[i](n,j), mus_jk, tau_j, 0, 1);
      }

    }

  }

  return out;
};


void update_mus(State &state, const Data &y, const Prior &prior) {

  const int J = get_J(y);
  const int K = state.K;

  for (int j = 0; j < J; j++) {
    for (int k = 0; k < K; k++) {

      auto log_fc = [&](double mus_jk) {
        return log_fc_mus(mus_jk, state, y, prior, j, k);
      };

      state.mus(j,k) = metropolis::uni(state.mus(j,k),
                                       log_fc, prior.cs_mu);
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
