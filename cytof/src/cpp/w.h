// Updating W. See Section 5.10 of manual.

void update_W(State &state, const Data&y, const Prior &prior) {
  const int I = get_I(y);
  const int K = state.K;
  int N_i;

  arma::rowvec a_new(K);
  
  for (int i=0; i<I; i++) {

    a_new = prior.a_w;
    N_i = get_Ni(y, i);

    for (int n=0; n<N_i; n++) {
      a_new[ state.lam[i][n] ] += 1;
    }

    state.W.row(i) = rdir(a_new);
  }
}
