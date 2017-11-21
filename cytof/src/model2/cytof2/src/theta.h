void update_theta(State &state, const Data &y, const Prior &prior, const Fixed &fixed_param) {
  if (!fixed_param.beta_all) update_beta(state, y, prior);
  if (!fixed_param.gams_0) update_gams0(state, y, prior);
  if (!fixed_param.mus) update_mus(state, y);
  if (!fixed_param.sig2) update_sig2(state, y, prior);
  if (!fixed_param.tau2) update_tau2(state, y, prior);
  if (!fixed_param.psi) update_psi(state, y, prior);

  if (!fixed_param.Z) {
    update_v(state, y, prior);
    update_H(state, y, prior);
    update_Z(state, y, prior);
  }

  if (!fixed_param.lam) update_lam(state, y, prior);
  if (!fixed_param.W) update_W(state, y, prior);

  if (!fixed_param.missing_y) {
    update_missing_y(state, y, prior);
  }
}
