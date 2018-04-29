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
    const int I = data.I;
    int Lz;
    for (int z=0; z<2; z++) {
      Lz = get_Lz(state, z);
      a_new[z].set_size(I, Lz);
      a_new[z].fill(prior.a_sig);
      b_new[z].set_size(I, Lz);
      for (int i=0; i<I; i++) {
        for (int l=0; l < Lz; l++) {
          b_new[z](i,l) = state.s(i) + 0;
        }
      }
    }
  }
  // fields
  std::vector<arma::mat> a_new;
  std::vector<arma::mat> b_new;
};


void update_sig2_zil(State &state, const Data &data, const Prior &prior, const SS_sig2 &ss_sig2, int z, int i, int l){

  double new_sig2_zil=mcmc::rinvgamma(ss_sig2.a_new[z](i,l),ss_sig2.b_new[z](i,l));

  // FIXME: This hacky stuff helps MCMC not select high values for sig2.
  //        Is there a better solution to avoid large sig2?
  if (new_sig2_zil > prior.sig2_max) {
    //new_sig2_zil = prior.sig2_max + R::runif(0, .01);
    new_sig2_zil = mcmc::rinvgamma(prior.a_sig, state.s[i]);
  }

  // This is the non-hacky stuff
  if (z == 0) {
    state.sig2_0(i,l)=new_sig2_zil;
  } else {
    state.sig2_1(i,l)=new_sig2_zil;
  }
}


void update_sig2(State &state, const Data &data, const Prior &prior, const Locked &locked){
  const int I = data.I;
  const int J = data.J;
  int Ni, Lz;
  int z, l;
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

  if(!locked.sig2_0) {
    Lz = get_L0(state);
    for (int i=0; i<I; i++) {
      for(l=0; l < Lz; l++) {
        update_sig2_zil(state, data, prior, ss_sig2, 0, i, l);
      }
    }
  }
  if(!locked.sig2_1) {
    Lz = get_L1(state);
    for (int i=0; i<I; i++) {
      for(l=0; l < Lz; l++) {
        update_sig2_zil(state, data, prior, ss_sig2, 1, i, l); 
      }
    }
  }
}

#endif
