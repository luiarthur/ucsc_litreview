// Updating e_{inj}. See Section 5.9 of manual.

void update_einj(State &state, const Data &y, const Prior &prior,
                  const int i, const int n, const int j) {

  double p[2];
  double x = log_dtnorm(y[i](n,j), state.mus(j,state.lam[i][n]), 
                        state.sig2[i], 0, 1);

  p[0] = (1 - state.pi(i,j)) * exp(x);
  p[1] = state.pi(i,j) * delta_0(y[i](n,j));

  state.e[i](n,j) = wsample_index(p, 2);
}

void update_e(State &state, const Data &y, const Prior &prior) {
  const int I = get_I(y);
  const int J = get_J(y);
  int N_i;

  for (int i=0; i<I; i++) {
    N_i = get_Ni(y,i);
    for (int j=0; j<J; j++) {
      for (int n=0; n<N_i; n++) {
        update_einj(state, y, prior, i, n, j);
      }
    }
  }
}

type_e sample_e_prior(const arma::Mat<int> &Z, const type_lam &lam, 
                      const arma::mat &pi, const Data &y){
  const int I = get_I(y);
  const int J = get_J(y);
  type_e e(I);

  for (int i=0; i<I; i++) {
    const int N_i = get_Ni(y, i);
    e[i].reshape(N_i, J);
    for (int n=0; n<N_i; n++) {
      const int lin = lam[i][n];
      for (int j=0; j<J; j++) {
        if (Z(j, lin) == 0) {
          e[i](n,j) = R::rbinom(1, pi(i,j));
        } else { // Z(j,lin) == 1
          e[i](n,j) = 1;
        }
      }
    }
  }

  return e;
}

type_e get_e_TE(const type_e &e, const Data &y_TE) {
  const int I = get_I(y_TE);
  const int J = get_J(y_TE);
  type_e e_TE(I);

  for (int i=0; i<I; i++) {
    const int Ni_TE = get_Ni(y_TE, i);
    // first row, first col, last row, last col
    e_TE[i] = e[i].submat(0, 0, Ni_TE-1, J-1);
  }

  return e_TE;
}
