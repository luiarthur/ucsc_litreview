// Updating sig^2_i. See Section 5.5 of manual.

double log_fc_log_sig2(double log_sig2_i, State &state, const Data &y,
                       const Prior &prior, const int i) {
  const double lp = lp_log_invgamma(log_sig2_i, prior.a_sig, prior.b_sig);
  double ll = 0;
  const double sig_i = sqrt(exp(log_sig2_i));

  const int J = get_J(y);
  double lin;
  double mus_jlin;
  int N_i;


  for (int j=0; j < J; j++) {
    N_i = get_Ni(y, i);
    for (int n=0; n < N_i; n++) {
      if (state.e[i](n,j)) {
        lin = state.lam[i][n];
        mus_jlin = state.mus(j, lin);
        ll += log_dtnorm(y[i](n,j), mus_jlin, sig_i, 0, 0);
      }
    }
  }

  return ll + lp;
};

void update_sig2(State &state, const Data &y, const Prior &prior) {

  const int I = get_I(y);
  for (int i=0; i < I; i++) {

    auto log_fc = [&](double log_sig2_j) {
      return log_fc_log_sig2(log_sig2_j, state, y, prior, i);
    };

    state.sig2(i) = exp(metropolis::uni(log(state.sig2(i)), 
                                        log_fc, prior.cs_sig2));
  }

};
