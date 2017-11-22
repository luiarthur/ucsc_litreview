void compute_mus_S(const State &state, const Data &y, 
                   double &S_sum, int &S_size, int zz, int i, int j) {

  const int Ni = get_Ni(y, i);
  S_sum = 0;
  S_size = 0;

  for (int n=0; n<Ni; n++) {
    if (z(state,i, n, j) == zz) {
      S_sum += y_final(state, y, i, n, j);
      S_size++;
    }
  }
}

void update_mus_ij(State &state, const Data &y, int zz, int i, int j) {
  double S_sum;
  int S_size;

  compute_mus_S(state, y, S_sum, S_size, zz, i, j);

  const double g = (zz == 0) ? state.gams_0(i,j) : 0;

  const double var_denom = (g+1) * state.sig2(i,j) + state.tau2[zz] * S_size;
  const double var_num = (g+1) * state.sig2(i,j) * state.tau2[zz];
  const double mean_num = (zz+1) * state.sig2(i,j) * state.psi[zz] +
                          state.tau2[zz] * S_sum;

  const double new_mean = mean_num / var_denom;
  const double new_sd = sqrt(var_num / var_denom);
  const double lo = (zz == 0) ? -INFINITY : 0;
  const double hi = (zz == 0) ? 0 : INFINITY;

  const double new_mus_ij = rtnorm(new_mean, new_sd, lo, hi);

  state.mus(i,j,zz) = new_mus_ij;
}

void update_mus(State &state, const Data &y) {
  const int I = get_I(y);
  const int J = get_J(y);

  for (int zz=0; zz<2; zz++) {
    for (int i=0; i<I; i++) {
      for (int j=0; j<J; j++) {
        update_mus_ij(state, y, zz, i, j);
      }
    }
  }
}
