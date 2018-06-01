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
          //b_new[z](i,l) = (prior.a_s / prior.b_s) + 0;
        }
      }
    }
  }
  // fields
  std::vector<arma::mat> a_new;
  std::vector<arma::mat> b_new;
};


void update_sig2_zil(State &state, const Data &data, const Prior &prior, const SS_sig2 &ss_sig2, int z, int i, int l){

  const double a_new = ss_sig2.a_new[z](i,l);
  const double b_new = ss_sig2.b_new[z](i,l);
  const bool lg=true;
  double new_sig2_zil;

  // Version 0
  //new_sig2_zil = mcmc::rinvgamma(a_new, b_new);
  // FIXME: This hacky stuff helps MCMC not select high values for sig2.
  //        Is there a better solution to avoid large sig2?
  // Version 1
  //new_sig2_zil = prior.sig2_max + R::runif(0, .01);
  // Version 2
  //new_sig2_zil = mcmc::rinvgamma(prior.a_sig, state.s(i));
  // Version 3
  //new_sig2_zil = R::rnorm(prior.sig2_max, .01);
  //while (new_sig2_zil < 0) new_sig2_zil = R::rnorm(prior.sig2_max, .01);


  // Version 4. Equivalent to a truncated InvGamma prior trancated at sig2_max
  const double lg_u_max = mcmc::pinvgamma(prior.sig2_max, a_new, b_new, lg);
  const double q = R::runif(0,1); // ~ Unif(0,1)
  const double lg_u = log(q) + lg_u_max;
  new_sig2_zil = mcmc::qinvgamma(lg_u, a_new, b_new, lg);
  //Rcout << "Hacky. a_new: " << a_new << ", b_new: " << b_new << std::endl;
  //Rcout << "Hacky. lg_u: " << lg_u << std::endl;
  //Rcout << "sig2 (i: " << i << ", l: " << l << ") is " <<new_sig2_zil<<std::endl;


  // Version 5
  //new_sig2_zil = (z==0) ? state.sig2_0(i,l) + 0 : state.sig2_1(i,l) + 0;
  //Rcout << "Hacky (i,l):" << i << "," << l << std::endl;

  if (new_sig2_zil > prior.sig2_max) {
    Rcout << "This message should not be showing! new_sig2_zil: " << 
      new_sig2_zil << std::endl;
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
