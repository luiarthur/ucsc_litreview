#ifndef UPDATE_NU_H
#define UPDATE_NU_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"
#include "update_Z_repulsive.h"

void update_nu(State &state, const Data &data, const Prior &prior, const Locked &locked){
  if (!locked.nu) {
    const int K = prior.K;
    const int J = data.J;

    double u;
    double t;
    double min_t = INFINITY;

    for (int k1=0; k1<K-1; k1++) {
      for (int k2=k1+1; k2<K; k2++) {
        u = R::runif(0, dist_z(state.Z(_,k1), state.Z(_,k2), state.nu));
        t = -sum(abs(state.Z(_,k1) - state.Z(_,k2))) / (2 * log(1-u));
        if (t < min_t) {
          min_t = t;
        }
      }
    }

    double new_b = min_t < prior.nu_b ? min_t : prior.nu_b;
    state.nu = R::runif(prior.nu_a, new_b);
    //Rcout << state.nu <<std::endl;

  }
}
 

#endif
