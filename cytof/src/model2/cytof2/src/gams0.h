void update_gams0ij(State &state, const Data &y, const Prior &prior, int i, int j) {
  auto log_fc = [&](double log_gams0ij) {
    const double lp = lp_log_invgamma(log_gams0ij, prior.a_gam, prior.b_gam);
    const double gams_0ij = exp(log_gams0ij);

    double ll = 0;
    const int Ni = get_Ni(y, i);
    const int lg = 1; // log the normal density

    for (int n=0; n<Ni; n++) {
      if (z(state, i, n, j) == 0) {
        ll += R::dnorm(y_final(state, y, i, n, j), 
                       state.mus(i,j,0),
                       sqrt((1 + gams_0ij) * state.sig2(i,j)), lg);
      }
    }

    return ll + lp;
  };

  const double log_gams0ij = log(state.gams_0(i,j));
  state.gams_0(i,j) = exp(metropolis::uni(log_gams0ij, log_fc, prior.cs_gam));
}

void update_gams0(State &state, const Data &y, const Prior &prior) {
  const int I = get_I(y);
  const int J = get_J(y);

  for (int i=0; i<I; i++) {
    for (int j=0; j<J; j++) {
      update_gams0ij(state, y, prior, i, j);
    }
  }
}
