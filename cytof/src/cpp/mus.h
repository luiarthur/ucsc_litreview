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
  const int I = y.size();

  double out = -INFINITY;
  if (mus_jk > prior.mus_cutoff && state.Z(j,k) == 1) {
    out = log_dtnorm(mus_jk, state.psi(j), tau_j, prior.mus_cutoff, 0);
  } else if (mus_jk < prior.mus_cutoff && state.Z(j,k) == 0) {
    out = log_dtnorm(mus_jk, state.psi(j), tau_j, prior.mus_cutoff, 1);
  }

  for (int i=0; i<I; i++) {
    const int N_i = y[i].n_cols;

    for (int n=0; n<N_i; n++) {

      if (state.e[i][n][j] == 0 && state.lam[i][n] == k) {
        out += log_dtnorm(y[i](n,j), mus_jk, tau_j, 0, 1);
      }

    }

  }

  return out;
};


void update_mus(State &state, const Data &y, const Prior &prior) {

  const int J = y[0].n_rows;
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


