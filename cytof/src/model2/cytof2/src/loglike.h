double y_final(const State &state, const Data &y, int i, int n, int j) {
  return missing(y,i,n,j) ? state.missing_y[i](n,j) : y[i](n,j);
}

double r_inj(double b0ij, double b1j, double xj, double c0, double yinj) {
  double out;

  if (yinj < c0) {
    out = b0ij - b1j * pow(yinj - c0, 2);
  } else {
    out = b0ij - b1j * xj * pow(yinj - c0, .5);
  }

  return out;
}

double p(const State &state, const Data &y, const Prior &prior,
         int i, int n, int j) {
  double y_inj = y_final(state, y, i, n, j);
  //const double r_inj = state.beta_0(i,j) - state.beta_1[j] * y_inj;

  // NEW STUFF
  const double c0 = prior.c0;
  const double rinj = r_inj(state.beta_0(i,j), state.beta_1(j), state.x(j), prior.c0, y_inj);
  // END of NEW STUFF

  return inv_logit(rinj);
}

double ll_p(const State &state, const Data &y, const Prior &prior,
            int i, int n, int j) {
  double p_inj = p(state, y, prior, i, n, j);
  return missing(y, i, n, j) ? log(p_inj) : log(1-p_inj);
}

double ll_p_given_beta(const State &state, const Data &y, const Prior &prior,
                       double b0ij, double b1j, double xj, int i, int n, int j) {
  double y_inj = y_final(state, y, i, n, j);
  //const double r_inj = b0ij - b1j * y_inj;

  // NEW STUFF
  const double c0 = prior.c0;
  const double rinj = r_inj(b0ij, b1j, xj, prior.c0, y_inj);
  // END of NEW STUFF

  const double p_inj = inv_logit(rinj);

  return missing(y, i, n, j) ? log(p_inj) : log(1-p_inj);
}

double ll_f(const State &state, const Data &y, int i, int n, int j) {
  const int lg = 1; // log the density
  return R::dnorm(y_final(state, y, i, n, j), mu(state, i, n, j),
                  sqrt((1 + gam(state, i, n, j)) * state.sig2(i,j)), lg);
}

double ll_marginal(const State &state, const Data & y, int i, int n, int j) {
  // loglike as a function of y only, and not m
  // with lambda marginalized out.
  const int lg = 0; // don't log the density

  double fm = 0;
  const int K = state.K;
  double g;

  for (int k=0; k<K; k++) {
    g = state.Z(j,k) == 0 ? state.gams_0(i,j) : 0;
    fm += state.W(i,k) * R::dnorm(y[i](n,j),
                                  state.mus(i,j,state.Z(j,k)),
                                  sqrt(state.sig2(i,j) * (1 + g)), lg);
  }

  return log(fm);
}

double rand_marginal(const State &state, int i, int n, int j) {
  // sample y from marginal distribution (with lambda marginalized out).
  const int K = state.K;
  double log_p[K];

  for (int k=0; k<K; k++) {
    log_p[k] = log(state.W(i,k));
  }

  const int rand_k = wsample_index_log_prob(log_p, K);
  const double g = state.Z(j,rand_k) == 0 ? state.gams_0(i,j) : 0;
  const double r_y = R::rnorm(state.mus(i,j,state.Z(j,rand_k)),
                              sqrt(state.sig2(i,j) * (1 + g)));

  return r_y;
}

double ll_fz(const State &state, const Data &y, int i, int n, int j, int zz) {
  const double gam_inj = (zz == 0) ? state.gams_0(i,j) : 0;
  const int lg = 1; // log the density
  return R::dnorm(y_final(state, y, i, n, j), state.mus(i, j, zz),
                  sqrt((1 + gam_inj) * state.sig2(i,j)), lg);
}

double loglike(const State &state, const Data &y, const Prior &prior) {
  double ll = 0;

  const int I = get_I(y);
  const auto N = get_N(y);
  const int J = get_J(y);

  // TODO: Parallelize?
  for (int i=0; i<I; i++) {
    for (int j=0; j<J; j++) {
      for (int n=0; n<N[i]; n++) {
        ll += ll_p(state, y, prior, i, n, j) + ll_f(state, y, i, n, j);
      }
    }
  }

  return ll;
}

arma::vec missing_y_samps(const State &state, const Data &y, int i, int n, int j, const int T=10) {
  arma::vec out(T);
  for (int t=0; t<T; t++) {
    out[t] = rand_marginal(state, i, n, j);
  }
  return out;
}

double lf_m_given_y_theta(const State &state, const Data &y, const Prior &prior, int i, int n, int j, const int T=10) {
  const auto y_imp = missing_y_samps(state, y, i, n, j, T);
  arma::vec pinj(T);

  const double c0 = prior.c0;
  double rinj;
 
  for (int t=0; t<T; t++) {
    rinj =  r_inj(state.beta_0(i,j), state.beta_1(j), state.x(j), prior.c0, y_imp[t]);
    pinj[t] = inv_logit(rinj);
  }

  return log(mean(pinj)); // should be missing
}

double loglike_marginal(const State &state, const Data &y, const Prior &prior, const int T=10) {
  double ll = 0;

  const int I = get_I(y);
  const auto N = get_N(y);
  const int J = get_J(y);

  // TODO: Parallelize?
  for (int i=0; i<I; i++) {
    for (int j=0; j<J; j++) {
      for (int n=0; n<N[i]; n++) {

        if (missing(y,i,n,j)) {
          ll += lf_m_given_y_theta(state, y, prior, i, n, j, T);
        } else {
          ll += ll_marginal(state, y, i, n, j); // f(m | y, theta) is cancelled in metropolis ratio
        }

      }
    }
  }

  return ll;
}

void impute_y(State &state, const Data &y, const int T=10) {
  const int I = get_I(y);
  const auto N = get_N(y);
  const int J = get_I(y);
  arma::vec imp_y(T);

  for (int i=0; i<I; i++) {
    for (int n=0; n<N[i]; n++) {
      for (int j=0; j<J; j++) {
        for (int t=0; t<T; t++) {
          imp_y[t] = rand_marginal(state, i, n, j);
        }
        state.missing_y[i](n,j) = arma::mean(imp_y);
      }
    }
  }
}
