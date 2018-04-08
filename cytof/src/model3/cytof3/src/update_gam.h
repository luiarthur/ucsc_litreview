#ifndef UPDATE_GAM_H
#define UPDATE_GAM_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"

void update_gam_inj(State &state, const Data &data, const Prior &prior, int i, int n, int j){

  const int z = state.Z(j, state.lam[i](n));
  const int Lz = get_Lz(state,z);
  double log_p[Lz];
  const int lg = 1; // log density

  for (int l=0; l<Lz; l++) {
    log_p[l] = log(get_eta_z(state,z)->at(i,n,j));
    log_p[l] += R::dnorm(data.y[i](n,j), 
                         get_mus_z(state, z)->at(l), 
                         get_sig2_z(state, z)->at(i,l), lg);
  }

  if (z==0) {
    state.eta_0(i,n,j) = mcmc::wsample_index_log_prob(log_p, Lz);
  } else {
    state.eta_1(i,n,j) = mcmc::wsample_index_log_prob(log_p, Lz);
  }
}

void update_gam(State &state, const Data &data, const Prior &prior, const Locked &locked){
  const int I = data.I;
  const int J = data.J;
  int Ni;

  if (!locked.gam) for (int i=0; i < I; i++) {
    for (int j=0; j < J; j++) {
      for (int n=0; n < Ni; n++) {
        update_gam_inj(state, data, prior, i, n, j);
      }
    }
  }
}

#endif
