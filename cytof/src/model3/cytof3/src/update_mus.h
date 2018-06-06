#ifndef UPDATE_MUS_H
#define UPDATE_MUS_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"

struct SS_mus { // sufficient stats for mus
  // constructor
  SS_mus() : S_card(2), S_sum(2) {}
  // fields
  std::vector<arma::Mat<int>> S_card;
  std::vector<arma::mat> S_sum;
};

void update_muszl(State &state, const Data &data, const Prior &prior, const SS_mus &ss_mus, int z, int l, double mu_eps) {
  using namespace Rcpp;

  // compute var_mean, var_new
  double stat_var = 0;
  double stat_mean = 0;
  for (int i=0; i<data.I; i++) {
    stat_var += ss_mus.S_card[z](i,l) / get_sig2_z(state, z)->at(i,l);
    stat_mean += ss_mus.S_sum[z](i,l);
  } 

  const double denom = 1 + get_tau2_z(prior,z) * stat_var;
  const double var_new = get_tau2_z(prior,z) / denom;
  double mean_new = get_psi_z(prior,z) + get_tau2_z(prior,z) * stat_mean;
  mean_new /= denom;

  if (z == 0) {
    state.mus_0(l) = mcmc::rtnorm(mean_new, sqrt(var_new), -INFINITY, -mu_eps);
  } else {
    state.mus_1(l) = mcmc::rtnorm(mean_new, sqrt(var_new), mu_eps, INFINITY);
  }
}

void update_mus(State &state, const Data &data, const Prior &prior, const Locked &locked, double mu_eps){
  int Lz;
  int Ni;
  const int I = data.I;
  const int J = data.J;
  int z;
  int l;

  SS_mus ss_mus;
  // TODO: maybe move this to the constructor?
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
        l = state.gam[i](n,j);
        ss_mus.S_card[z](i,l)++;
        ss_mus.S_sum[z](i,l) += state.missing_y[i](n,j) / get_sig2_z(state,z)->at(i,l);
      }
    }
  } 

  if(!locked.mus_0) for(l=0; l < get_L0(state); l++) {
    update_muszl(state, data, prior, ss_mus, 0, l, mu_eps);
  }
  if(!locked.mus_1) for(l=0; l < get_L1(state); l++) {
    update_muszl(state, data, prior, ss_mus, 1, l, mu_eps);
  }
}


#endif
