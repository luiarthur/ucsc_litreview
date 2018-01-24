void update_psi_z(State &state, const Data &y, const Prior &prior, int zz) {
  const double sgn = (zz == 0) ? -1 : 1;

  auto log_fc = [&](double psi_z) {
    const double m = (zz == 0) ? prior.psi0Bar : prior.psi1Bar;
    const double s = sqrt((zz == 0) ? prior.s2_psi0 : prior.s2_psi1);

    const int I = get_I(y);
    const int J = get_J(y);

    const double lo = (zz == 0) ? -INFINITY : 0;
    const double hi = (zz == 0) ? 0 : INFINITY;
    const double tau_z = sqrt(state.tau2[zz]);
    const double lp = dtnorm_log(psi_z, m, s, lo, hi);

    double ll = 0;

    for (int i=0; i<I; i++) {
      for (int j=0; j<J; j++) {
        ll += dtnorm_log(state.mus(i,j,zz), psi_z, tau_z, lo, hi);
      }
    }

    //Rcout << "psi: ll + lp = " << ll + lp << std::endl;
    return lp + ll;
  };

  const double psi_z = state.psi(zz);
  const double cs = (zz == 0) ? prior.cs_psi0 : prior.cs_psi1;
  state.psi(zz) = metropolis::uni(psi_z, log_fc, cs);
}

void update_psi(State &state, const Data &y, const Prior &prior, const int T=5) {
  for (int t=0; t<T; t++) {
    update_psi_z(state, y, prior, 0);
    update_psi_z(state, y, prior, 1);
  }
}
