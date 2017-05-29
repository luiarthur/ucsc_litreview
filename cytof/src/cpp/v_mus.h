// Updating v. See Section 5.6 of manual


// TODO: Check this
void update_vk_mus_kToK(State &state, const Data &y, const Prior &prior, int k) {
  const int I = get_I(y);
  const int J = get_J(y);
  const int K = state.K;
  int N_i;
  int lin;
  double log_acc_prob;

  const double logit_vk = logit(state.v(k), 0, 1);

  // cand
  const double cand_logit_vk = R::rnorm(logit_vk, prior.cs_v);
  const double cand_vk = inv_logit(cand_logit_vk, 0, 1);
  auto cand_mus_k_to_K = state.mus.cols(k, K-1); // columns k:K
  auto cand_Z_k_to_K = state.Z.cols(k, K-1);

  log_acc_prob = log(cand_logit_vk - logit_vk) + (prior.alpha + 1) * log((1 + exp(-logit_vk)) / (1 + exp(-cand_logit_vk)));

  double cand_b_k = 1;

  // update Z, mu
  for (int l=0; l<K; l++) {
    if (l > k) {
      for (int j=0; j<J; j++) {
        cand_Z_k_to_K(j,l) = compute_z(state.H(j,l),prior.G(j,j),cand_b_k);
        if (cand_Z_k_to_K(j,l) != state.Z(j,k-l)) {
          cand_mus_k_to_K(j,l) = rmus(state.psi(j), sqrt(state.tau2(j)), 
                                      cand_Z_k_to_K(j,l),
                                      prior.mus_cutoff);
        }
      }
    } else if (l == k) {
      cand_b_k *= cand_vk;
    } else { // l < k
      cand_b_k *= state.v(l);
    }
  }

  // compute acceptance probability
  for (int i=0; i<I; i++) {
    for (int j=0; j<J; j++) {
      N_i = get_Ni(y, i);
      for (int n=0; n<N_i; n++) {
        lin = state.lam(i,n);

        if (lin >= k && state.Z(j,lin) != cand_Z_k_to_K(j, lin-k)) {
          log_acc_prob += marginal_lf(y[i](n,j), 
                                      cand_mus_k_to_K(j,k-lin),
                                      sqrt(state.sig2(i)),
                                      cand_Z_k_to_K(j,k-lin),
                                      state.pi(i,j)) - 
                          marginal_lf(y[i](n,j), 
                                      state.mus(j,lin),
                                      sqrt(state.sig2(i)),
                                      state.Z(j,lin),
                                      state.pi(i,j));
        }

      }
    }
  }

  if (log_acc_prob > log(R::runif(0,1))) {
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

