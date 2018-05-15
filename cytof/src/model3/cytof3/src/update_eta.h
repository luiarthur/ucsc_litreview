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
  arma::rowvec a_new(Lz);
  a_new.fill(get_a_eta_z(prior, z));

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
  const int I = data.I;
  const int J = data.J;

  for (int i=0; i < I; i++) {
    for (int j=0; j < J; j++) {
      update_eta_zij(state, data, prior, z, i, j);
    }
  }
}

void update_eta(State &state, const Data &data, const Prior &prior, const Locked &locked){
  if (!locked.eta_0) update_eta_z(state, data, prior, 0);
  if (!locked.eta_1) update_eta_z(state, data, prior, 1);
}

void update_eta_obs(arma::cube &eta_0_obs, arma::cube &eta_1_obs, const State &state, const Data &data) {
  const int I = data.I;
  const int J = data.J;
  const int L0 = get_L0(state);
  const int L1 = get_L1(state);
  const auto N = data.N;
  int Ni;
  int z_jlin;
  int l;

  eta_0_obs.fill(0);
  eta_1_obs.fill(0);

  arma::Mat<int> s0(I, J);
  arma::Mat<int> s1(I, J);

  for (int i=0; i<I; i++) {
    Ni = N(i);
    for (int j=0; j<J; j++) {
      s0.fill(0);
      s1.fill(0);
      for (int n=0; n<Ni; n++) {
        z_jlin = state.Z(j, state.lam[i](n));
        l = state.gam[i](n, j);
        if (!data.M[i](n,j)) { // not missing
          if (z_jlin == 0) {
            eta_0_obs(i, j, l)++;
            s0(i,j)++;
          } else {
            eta_1_obs(i, j, l)++;
            s1(i,j)++;
          }
        }
      }
      //Rcout << s0(i,j) << std::endl;
      //Rcout << s1(i,j) << std::endl;
      eta_0_obs.tube(i,j) /= (s0(i,j) + 1E-6);
      eta_1_obs.tube(i,j) /= (s1(i,j) + 1E-6);
    }
  }

}

#endif
