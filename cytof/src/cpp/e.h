// Updating e_{inj}. See Section 5.9 of manual.

double update_einj(State &state, const Data &y, const Prior &prior,
                  const int i, const int n, const int j) {

  double p[2];
  double x = log_dtnorm(y[i](n,j), state.mus(j,state.lam[i][n]), 
                        state.sig2[i], 0, 1);

  p[0] = (1 - state.pi(i,j)) * exp(x);
  p[1] = state.pi(i,j) * delta_0(y[i](n,j));

  return wsample_index(p, 2);
}

void update_e(State &state, const Data &y, const Prior &prior) {
  const int I = get_I(y);
  const int J = get_J(y);
  int N_i;

  for (int i=0; i<I; i++) {
    N_i = get_Ni(y,i);
    for (int j=0; j<J; j++) {
      for (int n=0; n<N_i; n++) {
        state.e[i][n][j] = update_einj(state, y, prior, i, n, j);
      }
    }
  }
}



