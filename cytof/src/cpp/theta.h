// Updating theta given K. See section 5.13.2 of manual.

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
