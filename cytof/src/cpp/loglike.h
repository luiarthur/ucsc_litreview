double loglike(const Data &y, const State &state) {
  const int I = get_I(y);
  const int J = get_J(y);

  double ll = 0;

  int Ni;
  int lin;

  double y_inj;
  double mus_jlin;
  double sig_i;
  int z_jlin;
  double pi_ij;

  for (int i=0; i<I; i++) {
    Ni = get_Ni(y, i);
    sig_i = sqrt(state.sig2(i));
    for (int j=0; j<J; j++) {
      for (int n=0; n<Ni; n++) {
        lin = state.lam[i][n];
        y_inj = y[i](n,j);
        mus_jlin = state.mus(j,lin);
        z_jlin = state.Z(j, lin);
        pi_ij = state.pi(i,j);
        ll += marginal_lf(y_inj, mus_jlin, sig_i, z_jlin, pi_ij);
      }
    }
  }

  return ll;
}

