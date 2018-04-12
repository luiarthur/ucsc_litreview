#ifndef UPDATE_BETA_H
#define UPDATE_BETA_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"
#include "missing_mechanism.h"

void update_beta0i(State &state, const Data &data, const Prior &prior, int i){
  auto log_fc = [&](double b0i) {
    const double lp = -pow(b0i - prior.m_beta0, 2) / (2 * prior.s2_beta0);
    const int J = data.J;
    const int Ni = data.N(i);
    
    double ll = 0;
    for (int j=0; j < J; j++) {
      for (int n=0; n < Ni; n++) {
        ll += log(f_inj(state.missing_y[i](n,j), data.M[i](n,j), b0i, state.beta_1(i), prior.c0, prior.c1));
      }
    }
    
    return lp + ll;
  };
  
  state.beta_0(i) = mcmc::mh(state.beta_0(i), log_fc, prior.cs_beta0);
}



void update_beta1i(State &state, const Data &data, const Prior &prior, int i){
  auto log_fc = [&](double log_b1i) {
    const double lp = mcmc::lp_log_gamma(log_b1i, prior.a_beta1, prior.b_beta1);
    const int J = data.J;
    const int Ni = data.N(i);
    const double b1i = exp(log_b1i);
    
    double ll = 0;
    for (int j=0; j < J; j++) {
      for (int n=0; n < Ni; n++) {
        ll += log(f_inj(state.missing_y[i](n,j), data.M[i](n,j), state.beta_0(i), b1i, prior.c0, prior.c1));
      }
    }
    
    return lp + ll;
  };
  
  state.beta_1(i) = exp(mcmc::mh(log(state.beta_1(i)), log_fc, prior.cs_beta1));
}

void update_beta(State &state, const Data &data, const Prior &prior, const Locked &locked){
  const int I = data.I;
  for (int i=0; i < data.I; i++) {
    if (!locked.beta_0) update_beta0i(state, data, prior, i);
    if (!locked.beta_1) update_beta1i(state, data, prior, i);
  }
}

#endif
