#ifndef DMIXTURE_H
#define DMIXTURE_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"

// Returns the density of the mixture used to update v and lam.
double dmixture(const State &state, const Data &data, const Prior &prior, 
                int z, int i, int n, int j){
  const int lg = 0; // dont' log the normal density
  double mix_den = 0;
  const int Lz = get_Lz(state, z);

  for (int l=0; l<Lz; l++) {
    mix_den += get_eta_z(state, z)->at(i,j,l) * 
      R::dnorm(data.y[i](n, j), 
               get_mus_z(state, z)->at(l),
               get_sig2_z(state, z)->at(i,l), lg);
  }

  return mix_den;
}

#endif
