#ifndef UPDATE_LAM_H
#define UPDATE_LAM_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"

void update_lam_in(State &state, const Data &data, const Prior &prior, int i, int n){
  const int J = data.J;
  const int K = prior.K;
  const int lg = 0; // no log
  int Lz;
  int z_jk;
  double log_p[K];
  double mix_den;

  for (int k=0; k<K; k++) {
    log_p[k] = log(state.W(i, k));
    for (int j=0; j<J; j++) {
      z_jk = state.Z(j,k);
      Lz = get_Lz(state, z_jk);
      mix_den = 0;
      for (int l=0; l<Lz; l++) {
        mix_den += get_eta_z(state,z_jk)->at(i,j,l) * 
          R::dnorm(data.y[i](n, j), 
                   get_mus_z(state, Lz)->at(l),
                   get_sig2_z(state, Lz)->at(i,l), lg);
      }
      log_p[k] += log(mix_den);
    }
  }

  state.lam[i](n) = mcmc::wsample_index_log_prob(log_p, K);
}

void update_lam(State &state, const Data &data, const Prior &prior, const Locked &locked){
  const int I = data.I;
  int Ni;

  for (int i=0; i<I; i++){
    Ni = data.N[i];
    for (int n=0; n<Ni; n++){
      update_lam_in(state, data, prior, i, n);
    }
  }
}

#endif
