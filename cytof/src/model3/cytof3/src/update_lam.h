#ifndef UPDATE_LAM_H
#define UPDATE_LAM_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"
#include "dmixture.h"

#include <omp.h>

void update_lam_in(State &state, const Data &data, const Prior &prior, int i, int n){
  const int J = data.J;
  const int K = prior.K;
  int z_jk;
  double log_p[K];

  for (int k=0; k<K; k++) {
    log_p[k] = log(state.W(i, k));
    for (int j=0; j<J; j++) {
      z_jk = state.Z(j,k);
      log_p[k] += log( dmixture(state, data, prior, z_jk, i, n, j) );
    }
  }

  state.lam[i](n) = mcmc::wsample_index_log_prob(log_p, K);
}


void update_lam(State &state, const Data &data, const Prior &prior, const Locked &locked){
  if (!locked.lam) {
    const int I = data.I;
    int Ni;

    for (int i=0; i<I; i++){
      Ni = data.N[i];
#pragma omp parallel for shared(state, data, prior, i)
      for (int n=0; n<Ni; n++){
        update_lam_in(state, data, prior, i, n);
      }
    }

  }
}

#endif
