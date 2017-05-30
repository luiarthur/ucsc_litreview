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

void adjust_lam_e_dim(State &state, const Data &y, const Prior &prior) {
  const int I = get_I(y);
  const int J = get_J(y);
  int N_i;

  // new lambda 
  type_lam new_lam(I);
  type_e new_e(I);
  for (int i=0; i<I; i++) {
    N_i = get_Ni(y,i);

    std::vector<int> new_lam_i(N_i);
    new_lam[i] = new_lam_i;

    arma::Mat<int> new_e_i(N_i, J);
    new_e[i] =  new_e_i;
  }

  state.lam = new_lam;
  state.e = new_e;
  update_lam(state, y, prior); // update lambda first because
  update_e(state, y, prior);   // e depends on lambda
}
