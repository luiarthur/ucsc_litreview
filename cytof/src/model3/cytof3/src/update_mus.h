#ifndef UPDATE_MUS_H
#define UPDATE_MUS_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"
#include "missing_mechanism.h"

struct SS_mus { // sufficient stats for mus
  // constructor
  SS_mus() : S_card(2), S_sum(2) {}
  // fields
  std::vector<arma::Mat<int>> S_card;
  std::vector<arma::mat> S_sum;
};

void update_muszl(State &state, const Data &data, const Prior &prior, const Locked &locked, const SS_mus &ss_mus, int z, int l) {
  using namespace Rcpp;

  // TODO
  // compute var_new
  //double x;
  //const double denom = 1 + get_tau2_z(prior,z);
}

void update_mus(State &state, const Data &data, const Prior &prior, const Locked &locked){
  int Lz;
  int Ni;
  const int I = data.I;
  const int J = data.J;
  int z;
  int l;

  SS_mus ss_mus;
  for (z=0; z<2; z++) {
    Lz = get_Lz(state, z);
    ss_mus.S_card[z].zeros(I, Lz);
    ss_mus.S_sum[z].zeros(I, Lz);
  }

  for (int i=0; i<I; i++) {
    Ni = data.N[i];
    for (int j=0; j<J; j++) {
      for (int n=0; n<Ni; n++) {
        z = state.Z(j, state.lam[i](n));
        ss_mus.S_card[z](i,l)++;
        ss_mus.S_sum[z](i,l) += state.missing_y[i](n,j) / get_sig2_z(state,z)(i,l);
      }
    }
  } 

  if(!locked.mus_0) for(int l=0; l < get_Lz(state,0); l++) {
    update_muszl(state, data, prior, locked, ss_mus, 0, l);
  }
  if(!locked.mus_1) for(int l=0; l < get_Lz(state,1); l++) {
    update_muszl(state, data, prior, locked, ss_mus, 1, l);
  }
}


#endif
