// Updating c_j. See Section 5.11 of manual.

double log_fc_logit_cj(double logit_c_j, State &state, const Data &y,
                       const Prior &prior, const int j) {

  const int I = get_I(y);
  double a, b;
  const double log_d = log(state.d);

  // Note that this is simply a Normal
  const double lp = R::dnorm(logit_c_j, 0, prior.s2_c, 1);
  double ll = 0;
  double pi_ij;

  for (int i=0; i<I; i++) {
    pi_ij = state.pi(i,j);
    a = exp(log_d) / (1+exp(-logit_c_j));
    b = exp(log_d) / (1+exp( logit_c_j));

    ll += a*log(pi_ij) + b*log(1-pi_ij) - R::lgammafn(a) - R::lgammafn(b);
  }
  
  return ll + lp;
}

void update_c(State &state, const Data &y, const Prior &prior) {
  const int J = get_J(y);

  for (int j=0; j<J; j++) {

    auto log_fc = [&](double log_cj) {
      return log_fc_logit_cj(log_cj, state, y, prior, j);
    };

    state.c(j) = inv_logit(metropolis::uni(logit(state.c(j), 0, 1),
                                            log_fc, prior.cs_c), 0, 1);
  }
}
