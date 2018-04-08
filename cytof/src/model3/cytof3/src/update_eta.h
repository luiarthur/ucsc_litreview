#ifndef UPDATE_ETA_H
#define UPDATE_ETA_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"

// TODO: Is this right? Is the manuscript right?
void update_eta_zij(State &state, const Data &data, const Prior &prior, int z, int i, int j){
  const int Ni = data.N(i);
  const int Lz = get_Lz(state, z);
  arma::rowvec a_new(Lz, get_a_eta_z(prior, z));

  for (int n=0; n<Ni; n++) {
    if (state.Z(j, state.lam[i](n)) == z) {
      a_new[ state.gam[i](n,j) ] += 1;
    }
  }

  if (z == 0) {
    state.eta_0.tube(i,j) = mcmc::rdir(a_new);
  } else {
    state.eta_1.tube(i,j) = mcmc::rdir(a_new);
  }
}


void update_eta_z(State &state, const Data &data, const Prior &prior, int z){
  for (int i=0; i < data.I; i++) {
    for (int j=0; j < data.J; j++) {
      update_eta_zij(state, data, prior, z, i, j);
    }
  }
}

void update_eta(State &state, const Data &data, const Prior &prior, const Locked &locked){
  if (!locked.eta_0) update_eta_z(state, data, prior, 0);
  if (!locked.eta_1) update_eta_z(state, data, prior, 1);
}

#endif
