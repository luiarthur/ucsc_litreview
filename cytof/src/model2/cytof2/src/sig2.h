void update_sig2_ij(State &state, const Data& y, const Prior &prior, int i, int j) {
  const int Ni = get_Ni(y, i);
  const double new_a = prior.a_sig + Ni;

  double x = 0;
  for (int n=0; n<Ni; n++) {
    x += pow(y_final(state,y,i,n,j) - mu(state,i,n,j), 2) / (gam(state,i,n,j) + 1);
  }

  const double new_b = prior.b_sig + x / 2;

  state.gams_0(i,j) = rinvgamma(new_a, new_b);
}

void update_sig2(State &state, const Data& y, const Prior &prior) {
  const int I = get_I(y);
  const int J = get_J(y);

  for (int i=0; i<I; i++) {
    for (int j=0; j<J; j++) {
      update_sig2_ij(state, y, prior, i, j);
    }
  }
}
