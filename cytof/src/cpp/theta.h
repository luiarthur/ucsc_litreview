// Updating theta given K. See section 5.13.2 of manual.

// there should be twelve updates
void update_theta(State &state, const Data &y, const Prior &prior, const Fixed &fixed_params) {
  //Rcout << "mus ";
  if (!fixed_params.mus)    update_mus(state, y, prior);
  //Rcout << "psi ";
  if (!fixed_params.psi)    update_psi(state, y, prior);
  //Rcout << "tau2 ";
  if (!fixed_params.tau2)   update_tau2(state, y, prior);

  //Rcout << "pi ";
  if (!fixed_params.pi)     update_pi(state, y, prior);
  //Rcout << "sig2 ";
  if (!fixed_params.sig2)   update_sig2(state, y, prior);
  //Rcout << "v ";
  if (!fixed_params.Z)      update_v_mus(state, y, prior);

  //Rcout << "H ";
  if (!fixed_params.Z)      update_H_mus(state, y, prior);

  //Rcout << "e ";
  //if (!fixed_params.pi || 
  //    !fixed_params.mus)    update_e(state, y, prior);
  update_e(state, y, prior);

  //Rcout << "lam ";
  if (!fixed_params.lam)    update_lam(state, y, prior);

  //Rcout << "W ";
  if (!fixed_params.W)      update_W(state, y, prior);
  //Rcout << "c ";
  if (!fixed_params.pi)     update_c(state, y, prior);
  //Rcout << "d ";
  if (!fixed_params.pi)     update_d(state, y, prior);
}

// FIXME: Is this ok?
void adjust_lam_e_dim(State &state, const Data &y) {
  state.lam = sample_lam_prior(state.W, y); // must update lambda before e
  state.e = sample_e_prior(state.Z, state.lam, state.pi, y);
}
