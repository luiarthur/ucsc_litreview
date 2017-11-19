double y_final(const Data &y, const State &state, int i, int n, int j) {
  return missing(y,i,n,j) ? state.missing_y[i][n,j] : y[i][n,j];
}

double p(const Data &y, const State &state, int i, int n, int j) {
  double y_inj = y_final(y, state, i, n, j);
  const double xinj = state.beta_0[i,j] - state.beta_1[j] * y_inj;
  return inv_logit(xinj, 0, 1);
}

double ll_p(const Data &y, const State &state, int i, int n, int j) {
  double p_inj = p(y, state, i, n, j);
  return missing(y, i, n, j) ? log(p_inj) : log(1-p_inj);
}

double ll_f(const Data &y, const State &state, int i, int n, int j) {
  //return R::dnorm;
  return 0;
}

double loglike(const Data &y, const State &state) {
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
        y_inj = y_final(y, state, i, n, j);
        //R::dnorm(y[i][n,j], state.mus1)
      }
    }
  }

  return ll;
}

