void update_W(State &state, const Data&y, const Prior &prior) {
  const int I = get_I(y);
  int N_i;

  arma::rowvec d_new(state.K);

  for (int i=0; i<I; i++) {
    d_new.fill(prior.d_w / state.K);
    N_i = get_Ni(y, i);

    for (int n=0; n<N_i; n++) {
      d_new[ state.lam[i][n] ] += 1;
    }

    state.W.row(i) = rdir(d_new);
  }

}
