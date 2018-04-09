#ifndef UPDATE_Z_H
#define UPDATE_Z_H

int compute_zjk(double h_jk, double G_jj, double v_k) {
  const int lt = 1; // use left tail
  const int lg = 0; // don't log the result
  return mcmc::Ind(R::pnorm(h_jk, 0, sqrt(G_jj), lt, lg) < v_k);
}

void update_Z(State &state, const Data &data, const Prior &prior, const Locked &locked){
  const int J = data.J;
  const int K = prior.K;

  if(!locked.Z) for (int j=0; j<J; j++) {
    for (int k=0; k<K; k++) {
      state.Z(j,k) = compute_zjk(state.H(j,k), prior.G(j,j), state.v(k));
    }
  }
}

#endif
