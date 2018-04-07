#ifndef UPDATE_MISSING_Y_H
#define UPDATE_MISSING_Y_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"
#include "missing_mechanism.h"

void update_missing_yinj(State &state, const Data &data, const Prior &prior, const Locked &locked, int i, int n, int j){
  auto log_fc = [&](double y_inj) {
    double fc = 0;
    int z = state.Z(j, state.lam[i](n));
    int lg = 0; // no log

    arma::cube *eta;
    NumericVector *mus;
    NumericMatrix *sig2;

    if (z==0) {
      eta = &state.eta_0;
      mus = &state.mus_0;
      sig2 = &state.sig2_0;
    } else {
      eta = &state.eta_1;
      mus = &state.mus_1;
      sig2 = &state.sig2_1;
    }

    for (int l=0; l < mus->size(); l++) {
      fc += eta->at(i,j,l) * R::dnorm(y_inj, mus->at(l), sqrt(sig2->at(i,l)), lg);
    }

    fc *= f_inj(y_inj, data.M[i](n,j), state.beta_0[i], state.beta_1[i], prior.c0, prior.c1);

    return log(fc);
  };

  state.missing_y[i](n,j) = mcmc::mh(state.missing_y[i](n,j), log_fc, prior.cs_beta0);
}


void update_missing_y(State &state, const Data &data, const Prior &prior, const Locked &locked){
  if (!locked.missing_y) {
    for (int i=0; i < data.I; i++) {
      for (int j=0; j < data.J; j++) {
        for (int n=0; n < data.N[i]; n++) {
          if (data.M[i](n, j) == 1) { // 1 ->  y_inj is missing
            update_missing_yinj(state, data, prior, locked, i, n, j);
          }
        }
      }
    } 
  }
}

#endif
