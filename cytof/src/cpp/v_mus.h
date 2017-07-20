// Updating v. See Section 5.6 of manual


// TODO: Check this
void update_vk_mus_kToK(State &state, const Data &y, const Prior &prior, int k) {

  const int I = get_I(y);
  const int J = get_J(y);
  const int K = state.K;
  int N_i;
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
  double sig_i;
  double pi_ij;
  double y_inj;
  for (int i=0; i<I; i++) {
    sig_i = sqrt(state.sig2(i));
    for (int j=0; j<J; j++) {
      pi_ij = state.pi(i, j);
      N_i = get_Ni(y, i);
      for (int n=0; n<N_i; n++) {
        lin = state.lam[i][n];
        y_inj = y[i](n,j);

        if (lin >= k && state.Z(j,lin) != cand_Z_k_to_K(j, lin-k)) {
          ll += marginal_lf(y_inj, cand_mus_k_to_K(j, lin-k),
                            sig_i, cand_Z_k_to_K(j, lin-k), pi_ij) - 
                marginal_lf(y_inj, state.mus(j, lin),
                            sig_i, state.Z(j, lin), pi_ij);
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

void update_v_mus(State &state, const Data &y, const Prior &prior) {
  const int K = state.K;

  for (int k=0; k<K; k++) {
    update_vk_mus_kToK(state, y, prior, k);
  }

}

