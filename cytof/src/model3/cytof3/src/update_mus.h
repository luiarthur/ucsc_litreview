#ifndef UPDATE_MUS_H
#define UPDATE_MUS_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"
#include "missing_mechanism.h"

struct SS_mus { // sufficient stats for mus
  arma::Mat<int> S0_card;
  arma::Mat<int> S1_card;
  arma::mat S0_sum;
  arma::mat S1_sum;
};

void update_muszl(State &state, const Data &data, const Prior &prior, const Locked &locked, const SS_mus &ss_mus, int z, int l) {
  // TODO
}

void update_mus(State &state, const Data &data, const Prior &prior, const Locked &locked){
  const int L0 = get_L0(state);
  const int L1 = get_L1(state);
  int Ni;
  const int I = data.I;
  const int J = data.J;
  int z;
  int l;

  SS_mus ss_mus;
  ss_mus.S0_card.zeros(I, L0);
  ss_mus.S0_sum.zeros(I, L0);
  ss_mus.S1_card.zeros(I, L1);
  ss_mus.S1_sum.zeros(I, L1);

  for (int i=0; i<I; i++) {
    Ni = data.N[i];
    for (int j=0; j<J; j++) {
      for (int n=0; n<Ni; n++) {
        z = state.Z(j, state.lam[i](n));
        if (z == 0) {
          for (int l=0; l<L0; l++) {
            ss_mus.S0_card(i,l)++;
            ss_mus.S0_sum(i,l) += state.missing_y[i](n,j) / state.sig2_0(i,l);
          }
        } else {
          for (int l=0; l<L1; l++) {
            ss_mus.S1_card(i,l)++;
            ss_mus.S1_sum(i,l) += state.missing_y[i](n,j) / state.sig2_1(i,l);
          }
        }
      }
    }
  } 

  if(!locked.mus_0) for(int l=0; l < L0; l++) {
    update_muszl(state, data, prior, locked, ss_mus, 0, l);
  }

  if(!locked.mus_1) for(int l=0; l < L1; l++) {
    update_muszl(state, data, prior, locked, ss_mus, 1, l);
  }
}


#endif
