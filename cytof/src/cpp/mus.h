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

  double out = 0;
  double z;
  const int I = y.size();

  for (int i=0; i<I; i++) {
    const int N_i = y[i].n_rows;

    for (int n=0; n<N_i; n++) {

      if (state.e[i][n][j] == 0 && state.lam[i][n] == k) {
        z = (y[i](n, j) - mus_jk) / sqrt(state.sig2[i]);
        out += -pow(z, 2) / 2 - R::pnorm(z, 0, 1, 1, 1);
      }

    }

  }

  return out;
};


void update_mus(State &state, const Data &y, const Prior &prior, 
                const int j, const int k) {

  auto log_fc = [&](double mus_jk) {
    return log_fc_mus(mus_jk, state, y, prior, j, k);
  };

  state.mus(j,k) = metropolis::uni(state.mus(j,k), log_fc, prior.cs_mu);
};



