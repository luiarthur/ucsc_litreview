// Updating theta given K. See section 5.13.2 of manual.

// there should be twelve updates
void update_theta(State &state, const Data &y, const Prior &prior) {
  //Rcout << "mus ";
  update_mus(state, y, prior);
  //Rcout << "psi ";
  update_psi(state, y, prior);
  //Rcout << "tau2 ";
  update_tau2(state, y, prior);

  //Rcout << "pi ";
  update_pi(state, y, prior);
  //Rcout << "sig2 ";
  update_sig2(state, y, prior);
  //Rcout << "v ";
  update_v_mus(state, y, prior);

  //Rcout << "H ";
  update_H_mus(state, y, prior);
  //Rcout << "e ";
  update_e(state, y, prior);
  //Rcout << "lam ";
  update_lam(state, y, prior);

  //Rcout << "W ";
  update_W(state, y, prior);
  //Rcout << "c ";
  update_c(state, y, prior);
  //Rcout << "d ";
  update_d(state, y, prior);
}

// FIXME: Is this ok?
void adjust_lam_e_dim(State &state, const Data &y) {
  state.lam = sample_lam_prior(state.W, y); // must update lambda before e
  state.e = sample_e_prior(state.Z, state.lam, state.pi, y);
}
