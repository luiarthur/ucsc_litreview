// Updating lam_{in}. See Section 5.8 of manual.

double update_lin(State &state, const Data &y, const Prior &prior,
                  const int i, const int n) {

  const int J = get_J(y);
  const int K = state.K;
  double out = 0;
  double x;
  int z_jk;
  double pi_ij;

  // use metropolis with aux variable to speed up?

  double log_p[K];
  double p[K];

  for (int k=0; k<K; k++) {
    log_p[k] = log(state.W(i, k));
    x = 0;
    for (int j=0; j<J; j++) {
      pi_ij = state.pi(i,j);
      x += log_dtnorm(y[i](n, j), state.mus(j,k), state.sig2[i], 0, 1); 
      x += -.5 * log(state.sig2[i]); // normalizing constant
      x = exp(x);
      z_jk = state.Z(j,k);
      if (z_jk == 0) {
        log_p[k] += log(pi_ij * delta_0(y[i](n,j)) + (1- pi_ij) * x);
      } else {
        log_p[k] += log(x);
      }
    }
  }

  const double log_p_max = *std::max_element(log_p, log_p+K);

  for (int k=0; k<K; k++) {
    p[k] = exp(log_p[k] - log_p_max);
  }
  
  return wsample_index(p, K);
}

double update_lam(State &state, const Data &y, const Prior &prior) {

  const int I = get_I(y);
  int N_i;
  for (int i=0; i<I; i++) {
    N_i = get_Ni(y,i);
    for (int n=0; n<N_i; n++) {
      state.lam[i][n] = update_lin(state, y, prior, i, n);
    }
  }
}
