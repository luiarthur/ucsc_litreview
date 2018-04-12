#ifndef COMPUTE_LOGLIKE_H
#define COMPUTE_LOGLIKE_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"

double compute_loglike(const State &state, const Data &data, const Prior &prior, bool normalize_loglike){

  const int I = data.I;
  const int J = data.J;
  const int lg = 1; // log the density

  int Ni;
  double ll = 0;
  double s2;
  double mu;
  int z;
  int gam;
  int k;

  for (int i=0; i<I; i++) {
    for (int j=0; j<J; j++) {
      Ni = data.N(i);
      for (int n=0; n<Ni; n++) {
        k = state.lam[i](n);
        z = state.Z(j, k);
        gam = state.gam[i](n,j);
        mu = get_mus_z(state, z)->at(gam);
        s2 = get_sig2_z(state, z)->at(i, gam);
        ll += R::dnorm(state.missing_y[i](n,j), mu, sqrt(s2), lg);
      }
    }
  }

  if (normalize_loglike) ll /= sum(data.N);

  return ll;
}

#endif
