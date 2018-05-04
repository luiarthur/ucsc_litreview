#ifndef UPDATE_V_REPULSIVE_H
#define UPDATE_V_REPULSIVE_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"

void update_v_repulsive(State &state, const Data &data, const Prior &prior, const Locked &locked){
  if (!locked.v && !locked.Z) {
    const int K = prior.K;
    const int J = data.J;
    const double alpha = state.alpha;
    double sum_zk;

    for (int k=0; k<K; k++) {
      sum_zk = sum(state.Z(_,k));
      state.v(k) = R::rbeta(sum_zk + alpha/K, J - sum_zk + 1.0);
    }
  }
}

#endif
