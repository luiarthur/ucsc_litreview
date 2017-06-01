// Updating theta given K. See section 5.13.2 of manual.

// there should be twelve updates
void update_theta(State &state, const Data &y, const Prior &prior) {
  update_mus(state, y, prior);
  update_psi(state, y, prior);
  update_tau2(state, y, prior);

  update_pi(state, y, prior);
  update_sig2(state, y, prior);
  update_v_mus(state, y, prior);

  update_H_mus(state, y, prior);
  update_e(state, y, prior);
  update_lam(state, y, prior);

  update_W(state, y, prior);
  update_c(state, y, prior);
  update_d(state, y, prior);
}

// FIXME: Is this ok?
void adjust_lam_e_dim(State &state, const Data &y) {
  state.lam = sample_lam_prior(state.W, y); // must update lambda before e
  state.e = sample_e_prior(state.Z, state.lam, state.pi, y);
}
