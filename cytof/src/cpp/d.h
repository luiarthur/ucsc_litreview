// Updating d. See Section 5.11 of manual.

double log_fc_log_d(double log_d, State &state, const Data &y,
                    const Prior &prior) {

  const int I = get_I(y);
  const int J = get_J(y);
  const double d = exp(log_d);
  double a, b;

  const double lp = R::dnorm(log_d, prior.m_d, sqrt(prior.s2_d), 1);
  double logit_c_j;
  double ll = R::lgammafn(d);
  double pi_ij;

  for (int i=0; i<I; i++) {
    for (int j=0; j<J; j++) {
      pi_ij = state.pi(i,j);
      logit_c_j = logit(state.c(j), 0, 1);

      a = d / (1+exp(-logit_c_j));
      b = d / (1+exp( logit_c_j));

      ll += (a-1)*log(pi_ij) + (b-1)*log(1-pi_ij) - 
            (R::lgammafn(a) + R::lgammafn(b));
    }
  }
  
  return ll + lp;
}

void update_d(State &state, const Data &y, const Prior &prior) {

  auto log_fc = [&](double log_d) {
    return log_fc_log_d(log_d, state, y, prior);
  };

  state.d = exp(metropolis::uni(log(state.d), log_fc, prior.cs_d));
}
