// Updating pi_i. See Section 5.4 of manual.

void update_pi(State &state, const Data &y, const Prior &prior) {

  const int I = get_I(y);
  const int J = get_J(y);
  double a_new, b_new;
  double c_j;
  double d = state.d;
  int N_i;

  for (int j=0; j < J; j++) {
    c_j = state.c(j);

    for (int i=0; i < I; i++) {

      a_new = c_j * d;
      b_new = (1 - c_j) * d;
      N_i = y[i].n_cols;

      for (int n=0; n < N_i; n++) {
        a_new += state.e[i][n][j] * (1-state.Z(j, state.lam[i][n]));
        b_new += (1-state.e[i][n][j]) * (1-state.Z(j, state.lam[i][n]));
      }

      state.pi(i, j) = R::rbeta(a_new, b_new);
    }
  }

};
