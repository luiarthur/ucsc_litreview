double y_final(const State &state, const Data &y, int i, int n, int j) {
  return missing(y,i,n,j) ? state.missing_y[i](n,j) : y[i](n,j);
}

double p(const State &state, const Data &y, int i, int n, int j) {
  double y_inj = y_final(state, y, i, n, j);
  const double xinj = state.beta_0(i,j) - state.beta_1[j] * y_inj;
  return inv_logit(xinj);
}

double ll_p(const State &state, const Data &y, int i, int n, int j) {
  double p_inj = p(state, y, i, n, j);
  return missing(y, i, n, j) ? log(p_inj) : log(1-p_inj);
}

double ll_p_given_beta(const State &state, const Data &y, 
                       double b0ij, double b1j, int i, int n, int j) {
  double y_inj = y_final(state, y, i, n, j);
  const double x_inj = b0ij - b1j * y_inj;
  const double p_inj = inv_logit(x_inj);

  return missing(y, i, n, j) ? log(p_inj) : log(1-p_inj);
}

double ll_f(const State &state, const Data &y, int i, int n, int j) {
  const int lg = 1; // log the density
  return R::dnorm(y_final(state, y, i, n, j), mu(state, i, n, j), 
                  sqrt((1 + gam(state, i, n, j)) * state.sig2(i,j)), lg);
}

double ll_marginal(const State &state, const Data &y, int i, int n, int j) {
  const int lg = 1; // log the density

  double E_ij = 0;
  double V_ij = 0;
  double EV_ij = 0;

  const int K = state.K;

  // Compute E_ij;
  for (int k=0; k<K; k++) {
    E_ij += state.W(i,k) * state.mus(i,j,state.Z(j,k));
  }
  // Compute V_ij;
  for (int k=0; k<K; k++) {
    V_ij += state.W(i,k) * pow(state.mus(i,j,state.Z(j,k)) - E_ij, 2);
    EV_ij += state.W(i,k) * (state.Z(j,k) == 0 ? state.gams_0(i,j) : 0);
  }
  V_ij += (1 + EV_ij) * state.sig2(i,j);

  return R::dnorm(y_final(state, y, i, n, j), E_ij, sqrt(V_ij), lg);
}

double ll_fz(const State &state, const Data &y, int i, int n, int j, int zz) {
  const double gam_inj = (zz == 0) ? state.gams_0(i,j) : 0;
  const int lg = 1; // log the density
  return R::dnorm(y_final(state, y, i, n, j), state.mus(i, j, zz),
                  sqrt((1 + gam_inj) * state.sig2(i,j)), lg);
}

double loglike(const State &state, const Data &y) {
  double ll = 0;

  const int I = get_I(y);
  const auto N = get_N(y);
  const int J = get_J(y);
  
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

double loglike_marginal(const State &state, const Data &y) {
  double ll = 0;

  const int I = get_I(y);
  const auto N = get_N(y);
  const int J = get_J(y);
  
  // TODO: Parallelize?
  for (int i=0; i<I; i++) {
    for (int j=0; j<J; j++) {
      for (int n=0; n<N[i]; n++) {
        //ll += ll_p(state, y, i, n, j) + ll_marginal(state, y, i, n, j);
        ll += ll_marginal(state, y, i, n, j);
      }
    }
  }

  return ll;
}

