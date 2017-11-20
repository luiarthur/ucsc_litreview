void update_tau2_z(State &state, const Data &y, const Prior &prior, int zz) {
  auto log_fc = [&](double log_tau2_z) {
    const double a = (zz == 0) ? prior.a_tau0 : prior.a_tau1;
    const double b = (zz == 0) ? prior.b_tau0 : prior.b_tau1;
    const double lp = lp_log_invgamma(log_tau2_z, a, b);
    const double tau2_z = exp(log_tau2_z);

    const int I = get_I(y);
    const int J = get_J(y);
    const double lo = (zz==0) ? -INFINITY : 0;
    const double hi = (zz==0) ? 0 : INFINITY;

    double ll = 0;

    for (int i=0; i<I; i++) {
      for (int j=0; j<J; j++) {
        ll += dtnorm_log(state.mus(i,j,zz), state.psi[zz], sqrt(tau2_z), lo, hi);
      }
    }

    return lp + ll;
  };
  
  const double log_tau2_z = log(state.tau2[zz]);
  const double cs_tauz = (zz == 0) ? prior.cs_tau0 : prior.cs_tau1;
  state.tau2[zz] = exp(metropolis::uni(log_tau2_z, log_fc, cs_tauz));
}

void update_tau2(State &state, const Data &y, const Prior &prior) {
  update_tau2_z(state, y, prior, 0);
  update_tau2_z(state, y, prior, 1);
}
