#ifndef UPDATE_W_H
#define UPDATE_W_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"

void update_W(State &state, const Data &data, const Prior &prior, const Locked &locked){
  const int I = data.I;
  const int K = prior.K;
  int Ni;

  arma::rowvec Wi_new(K);
  arma::rowvec d_new(K);

  if (!locked.W) for (int i=0; i < I; i++) {
    d_new.fill(prior.d_W);
    Ni = data.N(i);

    for (int n=0; n<Ni; n++) {
      d_new[ state.lam[i](n) ] += 1;
    }

    Wi_new = mcmc::rdir(d_new);
    state.W(i, _) = Rcpp::NumericVector(Wi_new.begin(), Wi_new.end());
  }
}

#endif
