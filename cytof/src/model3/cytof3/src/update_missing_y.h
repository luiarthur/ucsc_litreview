#ifndef UPDATE_MISSING_Y_H
#define UPDATE_MISSING_Y_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"
#include "missing_mechanism.h"
#include "dmixture.h"


void update_missing_yinj(State &state, const Data &data, const Prior &prior, int i, int n, int j){
  const int z = state.Z(j, state.lam[i](n));
  const int lg = 0; // no log density
  const int l = state.gam[i](n,j);

  auto log_fc = [&](double y_inj) {
    double fc = 0;
    //fc = dmixture(state, data, prior, z, i, n, j);
    fc = R::dnorm(state.missing_y[i](n,j), 
                  get_mus_z(state, z)->at(l),
                  sqrt(get_sig2_z(state, z)->at(i,l)), lg);
    fc *= prob_miss(y_inj, state.beta_0(i), state.beta_1(i), prior.c0, prior.c1);

    return log(fc);
  };

  state.missing_y[i](n,j) = mcmc::mh(state.missing_y[i](n,j), log_fc, prior.cs_y);
}


void update_missing_y(State &state, const Data &data, const Prior &prior, const Locked &locked){
  if (!locked.missing_y) {
    for (int i=0; i < data.I; i++) {
      for (int j=0; j < data.J; j++) {
        for (int n=0; n < data.N[i]; n++) {
          if (data.M[i](n, j) == 1) { // 1 ->  y_inj is missing
            update_missing_yinj(state, data, prior, i, n, j);
          }
        }
      }
    } 
  }
}

#endif
