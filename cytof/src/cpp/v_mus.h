// Updating v. See Section 5.6 of manual


void update_vk_mus_kToK(State &state, const Data &y, const Prior &prior, int k) {
  const int I = get_I(state.y);
  const int J = get_J(state.y);
  const int K = state.K;
  int N_i;
  double acc_prob;
  int lin;

  const double logit_vk = logit(state.v(k), 0, 1);
  const double cand_logit_vk = R::rnorm(logit_vk, prior.cs_v);

  arma::mat cand_mus = state.mus.col(k, K-1); // columns k:K

  acc_prob = log(cand_logit_vk - logit_vk) + 
              (prior.alpha + 1) * log((1 + exp(-logit_vk)) / (1 + exp(-cand_logit_vk)));

  for (int i=0; i<I; i++) {
    for (int j=0; j<J; j++) {
      N_i = get_Ni(y, i);
      for (int n=0; n<N_0; n++) {
        lin = state.lam[i][n];

        // FIXME: stopped here

        if (state.Z(j,lin) == 1) { 
          // TODO

        } else {
          // TODO

        }
      }
    }
  }
}   

void update_v_mus(State &state, const Data &y, const Prior &prior) {

}

