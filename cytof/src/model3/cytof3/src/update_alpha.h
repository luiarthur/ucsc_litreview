#ifndef UPDATE_ALPHA_H
#define UPDATE_ALPHA_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"

void update_alpha(State &state, const Data &data, const Prior &prior, const Locked &locked){
  if(!locked.alpha) {
    const int K = prior.K;

    double sum_log_v = 0;
    for (int k=0; k<K; k++) {
      sum_log_v += log(state.v[k]);
    }

    const double shape_new = prior.a_alpha + K;
    const double rate_new = prior.b_alpha + sum_log_v / K;

    state.alpha = R::rgamma(shape_new, 1/rate_new); // R::rgamma(shape, scale)
  }
}


#endif
