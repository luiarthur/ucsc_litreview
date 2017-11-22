double y_final(const State &state, const Data &y, int i, int n, int j) {
  return missing(y,i,n,j) ? state.missing_y[i](n,j) : y[i](n,j);
}

double p(const State &state, const Data &y, int i, int n, int j) {
  double y_inj = y_final(state, y, i, n, j);
  const double xinj = state.beta_0(i,j) - state.beta_1[j] * y_inj;
  return inv_logit(xinj, 0, 1);
}

double ll_p(const State &state, const Data &y, int i, int n, int j) {
  double p_inj = p(state, y, i, n, j);
  return missing(y, i, n, j) ? log(p_inj) : log(1-p_inj);
}

double ll_p_given_beta(const State &state, const Data &y, 
                       double b0ij, double b1j, int i, int n, int j) {
  double y_inj = y_final(state, y, i, n, j);
  const double x_inj = b0ij - b1j * y_inj;
  const double p_inj = inv_logit(x_inj, 0, 1);

  return missing(y, i, n, j) ? log(p_inj) : log(1-p_inj);
}

double ll_f(const State &state, const Data &y, int i, int n, int j) {
  const int lg = 1; // log the density
  return R::dnorm(y_final(state, y, i, n, j), mu(state, i, n, j), 
                  sqrt((1 + gam(state, i, n, j)) * state.sig2(i,j)), lg);
}

double ll_fz(const State &state, const Data &y, int i, int n, int j, int zz) {
  const double gam_inj = (zz == 0) ? gam(state, i, n, j) : 0;
  const int lg = 1; // log the density
  return R::dnorm(y_final(state, y, i, n, j), state.mus(i, j, zz),
                  sqrt((1 + gam_inj) * state.sig2(i,j)), lg);
}

double loglike(const State &state, const Data &y) {
  double ll = 0;

  const int I = get_I(y);
  const auto N = get_N(y);
  const int J = get_J(y);
  
  double lg_inj, lf_inj;
  double y_inj;
  double mus_inj, sig2_ij, gams_inj;
  int z_inj;

  // TODO: Parallelize?
  for (int i=0; i<I; i++) {
    for (int j=0; j<J; j++) {
      for (int n=0; n<N[i]; n++) {
        ll += ll_p(state, y, i, n, j) + ll_f(state, y, i, n, j);
      }
    }
  }

  return ll;
}

