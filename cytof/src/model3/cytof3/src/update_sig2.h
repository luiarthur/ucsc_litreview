#ifndef UPDATE_SIG2_H
#define UPDATE_SIG2_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"

struct SS_sig2 { // sufficient stats for sig2
  // constructor
  SS_sig2(const State &state, const Data &data, const Prior &prior) : a_new(2), b_new(2) {
    for (int z=0; z<2; z++) {
      a_new[z].set_size(data.I, get_Lz(state, z));
      a_new[z].fill(prior.a_sig);
      for (int i=0; i<data.I; i++) {
        b_new[z].set_size(data.I, get_Lz(state, z));
        b_new[z].fill(state.s(i));
      }
    }
  }
  // fields
  std::vector<arma::mat> a_new;
  std::vector<arma::mat> b_new;
};


void update_sig2_zil(State &state, const Data &data, const Prior &prior, const SS_sig2 &ss_sig2, int z, int i, int l){
  if (z == 0) {
    state.sig2_0(i,l)=mcmc::rinvgamma(ss_sig2.a_new[z](i,l),ss_sig2.b_new[z](i,l));
  } else {
    state.sig2_1(i,l)=mcmc::rinvgamma(ss_sig2.a_new[z](i,l),ss_sig2.b_new[z](i,l));
  }
}


void update_sig2(State &state, const Data &data, const Prior &prior, const Locked &locked){
  const int I = data.I;
  const int J = data.J;
  int Ni, Lz;
  int z, l;
  double x;
  SS_sig2 ss_sig2(state, data, prior);

  for (int i=0; i<I; i++) {
    Ni = data.N[i];
    for (int j=0; j<J; j++) {
      for (int n=0; n<Ni; n++) {
        z = state.Z(j, state.lam[i](n));
        l = state.gam[i](n, j);
        ss_sig2.a_new[z](i,l) += 0.5; // increase cardinality by 1/2
        ss_sig2.b_new[z](i,l) += pow(state.missing_y[i](n,j) - get_mus_z(state,z)->at(l), 2) / 2;
      }
    }
  }

  if(!locked.sig2_0) for (int i=0; i<I; i++) for(l=0; l < get_Lz(state,0); l++) {
    update_sig2_zil(state, data, prior, ss_sig2, 0, i, l);
  }
  if(!locked.sig2_1) for (int i=0; i<I; i++) for(l=0; l < get_Lz(state,1); l++) {
    update_sig2_zil(state, data, prior, ss_sig2, 1, i, l);
  }
}

#endif
