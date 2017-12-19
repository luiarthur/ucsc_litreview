double ll_p_given_yinj(const State &state, double yinj, int i, int n, int j) {
  const double xinj = state.beta_0(i,j) - state.beta_1[j] * yinj;
  return log(inv_logit(xinj)); // It should be missing!
}

double ll_f_given_yinj(const State &state, double yinj, int i, int n, int j) {
  const int lg = 1; // log the density
  return R::dnorm(yinj, mu(state, i, n, j), 
                  sqrt((1 + gam(state, i, n, j)) * state.sig2(i,j)), lg);
}

void update_missing_yinj(State &state, const Data &y, const Prior &prior,
                         int i, int n, int j) {

  auto log_fc = [&](double y_inj) {
    return ll_p_given_yinj(state, y_inj, i, n, j) +
           ll_f_given_yinj(state, y_inj, i, n, j);
  };

  const double y_inj = state.missing_y[i](n,j);
  state.missing_y[i](n,j) = metropolis::uni(y_inj, log_fc, prior.cs_y);
}

void update_missing_y(State &state, const Data &y, const Prior &prior) {
  const int I = get_I(y);
  const auto N = get_N(y);
  const int J = get_J(y);

  for (int i=0; i<I; i++) {
    for (int j=0; j<J; j++) {
      for (int n=0; n<N[i]; n++) {
        //Rcout << i << "," << n << "," << j << std::endl;
        if (missing(y, i, n, j)) {
          //Rcout << "missing: " << i << "," << n << "," << j << std::endl;
          update_missing_yinj(state, y, prior, i, n, j);
        }
      }
    }
  }
}

arma::vec get_missing_only(const State &state, const arma::Mat<int> &indices) {
  const int M = indices.n_rows;
  arma::vec missing_y_only(M);
  int i,n,j;

  for (int mm=0; mm < M; mm++) {
    i = indices(mm, 0);
    n = indices(mm, 1);
    j = indices(mm, 2);
    missing_y_only[mm] = state.missing_y[i](n,j);
  }

  return missing_y_only;
}
