// Updating c_j. See Section 5.11 of manual.

double log_fc_logit_cj(double logit_c_j, State &state, const Data &y,
                       const Prior &prior, const int j) {

  const int I = get_I(y);
  double a, b;
  const double d = state.d;
  //const double log_d = log(d);

  // Note that this is simply a Normal
  const double lp = R::dnorm(logit_c_j, 0, sqrt(prior.s2_c), 1); // log
  double ll = 0;
  double pi_ij;

  for (int i=0; i<I; i++) {
    pi_ij = state.pi(i,j);
    a = d / (1+exp(-logit_c_j));
    b = d / (1+exp( logit_c_j));

    ll += a*log(pi_ij) + b*log(1-pi_ij) - R::lgammafn(a) - R::lgammafn(b);
  }
  
  return ll + lp;
}

void update_c(State &state, const Data &y, const Prior &prior) {
  const int J = get_J(y);

  for (int j=0; j<J; j++) {

    auto log_fc = [&](double logit_cj) {
      return log_fc_logit_cj(logit_cj, state, y, prior, j);
    };

    state.c(j) = inv_logit(metropolis::uni(logit(state.c(j), 0, 1),
                                           log_fc, prior.cs_c), 0, 1);
  }
}
