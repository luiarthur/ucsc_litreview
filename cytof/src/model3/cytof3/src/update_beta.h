#ifndef UPDATE_BETA_H
#define UPDATE_BETA_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"

void update_beta0i(State &state, const Data &data, const Prior &prior, int i){
}

void update_beta1i(State &state, const Data &data, const Prior &prior, int i){
}

void update_beta(State &state, const Data &data, const Prior &prior, const Fixed &fixed){
  for (int i=0; i < data.I; i++) {
    if (!fixed.beta_0) update_beta0i(state, data, prior, i);
    if (!fixed.beta_1) update_beta0i(state, data, prior, i);
  }
}

#endif
