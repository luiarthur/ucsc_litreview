#ifndef UPDATE_S_H
#define UPDATE_S_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"

void update_si(State &state, const Data &data, const Prior &prior, const Locked &locked, int i) {

  double x = 0;
  int Lz;

  for (int z=0; z<2; z++) {
    Lz = get_Lz(state, z);
    for (int l=0; l<Lz; l++) {
      x += 1 / get_sig2_z(state, z)->at(i, l);
    }
  }

  double a_new = prior.a_s + (get_L0(state) + get_L1(state)) * prior.a_sig;
  double b_new = prior.b_s + x;

  state.s(i) = R::rgamma(a_new, b_new);
}


void update_s(State &state, const Data &data, const Prior &prior, const Locked &locked) {
  const int I = data.I;
  if (!locked.s) for (int i=0; i<data.I; i++) {
    update_s(state, data, prior, locked);
  }
}

#endif
