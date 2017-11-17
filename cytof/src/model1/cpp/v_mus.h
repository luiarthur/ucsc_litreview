// Updating v. See Section 5.6 of manual

double compute_bk(const State &state, int k) {
  // k is the index of the array

  double b_k = 1;

  for (int l=0; l<=k; l++) {
    b_k *= state.v(l);
  }

  return b_k;
}

std::vector<double> compute_b(const State &state) {
  const int K = state.K;
  std::vector<double> b(K);

  b[0] = state.v[0];
  for (int l=1; l < K; l++) {
    b[l] = b[l-1] * state.v[l];
  }

  return b;
}

// TODO: Check this
void update_vk_mus_kToK_old(State &state, const Data &y, const Prior &prior, int k) {

  const int I = get_I(y);
  const int J = get_J(y);
  const int K = state.K;
  //int N_i;
  int lin;

  const double logit_vk = logit(state.v(k), 0, 1);

  // cand
  const double cand_logit_vk = R::rnorm(logit_vk, prior.cs_v);
  const double cand_vk = inv_logit(cand_logit_vk, 0, 1);
  //auto cand_mus_k_to_K = state.mus.cols(k, K-1); // columns k:K
  //auto cand_Z_k_to_K = state.Z.cols(k, K-1);
  arma::mat cand_mus_k_to_K(J, K-k);
  arma::Mat<int> cand_Z_k_to_K(J, K-k);

  //const double lp = log(cand_logit_vk - logit_vk) + (prior.alpha + 1) * log((1 + exp(-logit_vk)) / (1 + exp(-cand_logit_vk)));
  // const double lp = log(logit_vk - cand_logit_vk) + (prior.alpha + 1) * log( (1 + exp(-logit_vk)) / (1 + exp(-cand_logit_vk)) );
  const double lp = (logit_vk - cand_logit_vk) + (prior.alpha + 1) * ( log(1 + exp(-logit_vk)) - log(1 + exp(-cand_logit_vk)) );
  //const double lp = (cand_logit_vk - logit_vk) + (prior.alpha + 1) * ( log(1 + exp(-logit_vk)) - log(1 + exp(-cand_logit_vk)) );


  // update Z, mu
  //update bk
  double bk = 1;
  for (int l=0; l<k; l++) {
    bk *= state.v(l);
  }

  for (int l=k; l<K; l++) {
    if (l == k) {
      bk *= cand_vk;
    } else {
      bk *= state.v(l);
    }
    for (int j=0; j<J; j++) {
      cand_Z_k_to_K(j,l-k) = compute_z(state.H(j,l-k),
                                       prior.G(j,j),
                                       bk);

      if (cand_Z_k_to_K(j,l-k) != state.Z(j,l)) {
        cand_mus_k_to_K(j,l-k) = rmus(state.psi(j), sqrt(state.tau2(j)), 
                                      cand_Z_k_to_K(j,l-k),
                                      prior.mus_thresh);
      } else {
        //cand_mus_k_to_K(j,l-k) = state.Z(j,l);
        cand_mus_k_to_K(j,l-k) = state.mus(j,l);
      }
    }
  }

  // compute acceptance probability
  double ll = 0;
  //double sig_i;
  double pi_ij;
  double y_inj;

  double sig[I];
  int N[I];

  for (int i=0; i<I; i++) {
    sig[i] = sqrt(state.sig2(i));
    N[i] = get_Ni(y, i);
  }

//#pragma omp parallel for
  for (int i=0; i<I; i++) {
    //sig_i = sqrt(state.sig2(i));
    for (int j=0; j<J; j++) {
      pi_ij = state.pi(i, j);
      //N_i = get_Ni(y, i);
      for (int n=0; n<N[i]; n++) {
        lin = state.lam[i][n];
        y_inj = y[i](n,j);

        if (lin >= k && state.Z(j,lin) != cand_Z_k_to_K(j, lin-k)) {
          ll += marginal_lf(y_inj, cand_mus_k_to_K(j, lin-k),
                            sig[i], cand_Z_k_to_K(j, lin-k), pi_ij) - 
                marginal_lf(y_inj, state.mus(j, lin),
                            sig[i], state.Z(j, lin), pi_ij);
        }
      }
    }
  }
  //Rcout << ll << " ";

  if (ll + lp > log(R::runif(0,1))) {
    // update z, mu, v
    state.Z.cols(k,K-1) = cand_Z_k_to_K;
    state.mus.cols(k,K-1) = cand_mus_k_to_K;
    state.v(k) = cand_vk;
  }

}   

double compute_lpq_logit_vk_mus_kToK(const State &state, const Data & y, 
                                     const Prior &prior, 
                                     double cand_logit_vk, 
                                     const arma::mat cand_mus_k_to_K, 
                                     const arma::Mat<int> cand_Z_k_to_K, 
                                     int k){

  const int J = get_J(y);
  const int K = state.K;

  const double logit_vk = logit(state.v(k), 0, 1);

  const double lp_logit_vk = 
    (logit_vk - cand_logit_vk) + 
    (prior.alpha + 1) * ( log(1 + exp(-logit_vk)) - log(1 + exp(-cand_logit_vk)) );

  double s;
  double lpq_mus = 0;

  for (int j=0; j<J; j++) {
    for (int l=k; l<K; l++) {

      if (cand_Z_k_to_K(j,l-k) != state.Z(j,l)) {
        // diff mus log prior (cand - curr)
        lpq_mus += lp_mus(cand_mus_k_to_K(j,l-k), 
                          state.psi(j), sqrt(state.tau2(j)), 
                          cand_Z_k_to_K(j,l-k), prior);
        lpq_mus -= lp_mus(state.mus(j,l),
                          state.psi(j), sqrt(state.tau2(j)),
                          state.Z(j,l), prior);

        // diff mus log proposal (curr - cand)
        s = prior.cs_mu(j,l);
        lpq_mus += lp_mus(state.mus(j,l),
                          state.psi(j), s,
                          state.Z(j,l), prior);
        lpq_mus -= lp_mus(cand_mus_k_to_K(j,l-k), 
                          state.psi(j), s,
                          cand_Z_k_to_K(j,l-k), prior);
      }

    }
  }

  return lp_logit_vk + lpq_mus;
}

void update_vk_mus_kToK(State &state, const Data &y, const Prior &prior, int k) {

  const int I = get_I(y);
  const int J = get_J(y);
  const int K = state.K;
  int lin;

  const double logit_vk = logit(state.v(k), 0, 1);

  // cand
  const double cand_logit_vk = R::rnorm(logit_vk, prior.cs_v);
  const double cand_vk = inv_logit(cand_logit_vk, 0, 1);
  arma::mat cand_mus_k_to_K(J, K-k);
  arma::Mat<int> cand_Z_k_to_K(J, K-k);


  // update Z, mu, bk
  double bk = compute_bk(state, k);

  for (int l=k; l<K; l++) {
    if (l == k) {
      bk *= cand_vk;
    } else {
      bk *= state.v(l);
    }

    for (int j=0; j<J; j++) {
      cand_Z_k_to_K(j,l-k) = compute_z(state.H(j,l-k),
                                       prior.G(j,j),
                                       bk);

      if (cand_Z_k_to_K(j,l-k) != state.Z(j,l)) {
        cand_mus_k_to_K(j,l-k) = rmus(state.psi(j), prior.cs_mu(j,l), 
                                      cand_Z_k_to_K(j,l-k),
                                      prior.mus_thresh);
      } else {
        cand_mus_k_to_K(j,l-k) = state.mus(j,l);
      }
    }
  }

  // compute log likelihood
  double ll = 0;
  double pi_ij;
  double y_inj;

  double sig[I];
  int N[I];

  for (int i=0; i<I; i++) {
    sig[i] = sqrt(state.sig2(i));
    N[i] = get_Ni(y, i);
  }

//#pragma omp parallel for
  for (int i=0; i<I; i++) {
    for (int j=0; j<J; j++) {
      pi_ij = state.pi(i, j);

      for (int n=0; n<N[i]; n++) {
        lin = state.lam[i][n];
        y_inj = y[i](n,j);

        if (lin >= k && state.Z(j,lin) != cand_Z_k_to_K(j, lin-k)) {
          ll += marginal_lf(y_inj, cand_mus_k_to_K(j, lin-k),
                            sig[i], cand_Z_k_to_K(j, lin-k), pi_ij) - 
                marginal_lf(y_inj, state.mus(j, lin),
                            sig[i], state.Z(j, lin), pi_ij);
        }
      }
    }
  }

  // compute lpq_vk_mus_kToK
  const double lpq = compute_lpq_logit_vk_mus_kToK(state, y, prior, 
                                                   cand_logit_vk, 
                                                   cand_mus_k_to_K, 
                                                   cand_Z_k_to_K, k);

  // compute acceptance ratio
  if (ll + lpq > log(R::runif(0,1))) {
    // update z, mu, v
    state.Z.cols(k,K-1) = cand_Z_k_to_K;
    state.mus.cols(k,K-1) = cand_mus_k_to_K;
    state.v(k) = cand_vk;
  }

}

void update_v_mus(State &state, const Data &y, const Prior &prior) {
  const int K = state.K;

  for (int k=0; k<K; k++) {
    update_vk_mus_kToK(state, y, prior, k);
  }

}

