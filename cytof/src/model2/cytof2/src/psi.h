void update_psi_z(State &state, const Data &y, const Prior &prior, int zz) {
  const int sign = (zz == 0) ? -1 : 1;

  auto log_fc = [&](double log_abs_psi) {
    const double m = (zz == 0) ? prior.psi0Bar : prior.psi1Bar;
    const double s = sqrt((zz == 0) ? prior.s2_psi0 : prior.s2_psi1);
    double lp = lp_log_abs_tn_posneg(log_abs_psi, m, s, zz);

    const int I = get_I(y);
    const int J = get_J(y);

    const double lo = (zz == 0) ? -INFINITY : 0;
    const double hi = (zz == 0) ? 0 : INFINITY;
    double psi_z = exp(log_abs_psi) * sign;
    double tau_z = sqrt(state.tau2[zz]);

    double ll = 0;

    for (int i=0; i<I; i++) {
      for (int j=0; j<J; j++) {
        ll += dtnorm_log(state.mus[i,j], psi_z, tau_z, lo, hi);
      }
    }

    return lp + ll;
  };

  const double log_abs_psi = log(abs(state.psi[zz]));
  const double cs = (zz == 0) ? prior.cs_psi0 : prior.cs_psi1;
  state.psi[zz] = sign*exp(metropolis::uni(log_abs_psi, log_fc, cs));
}

void update_psi(State &state, const Data &y, const Prior &prior) {
  update_psi_z(state, y, prior, 0);
  update_psi_z(state, y, prior, 1);
}
