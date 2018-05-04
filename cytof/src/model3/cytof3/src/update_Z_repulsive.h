#ifndef UPDATE_Z_REPULSIVE_H
#define UPDATE_Z_REPULSIVE_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"
#include <omp.h>

void update_zjk_repulsive(State &state, const Data &data, const Prior &prior, const Locked &locked, int j, int k){
  // TODO
}

void update_zk_repulsive(State &state, const Data &data, const Prior &prior, const Locked &locked, int k){
  // TODO
}

void update_Z_repulsive(State &state, const Data &data, const Prior &prior, const Locked &locked, bool update_z_by_column=true){

  if(!locked.Z) {
    const int J = data.J;
    const int K = prior.K;
    for (int k=0; k<K; k++) {
      if (update_z_by_column) {
        // update z_k a column at a time
        update_zk_repulsive(state, data, prior, locked, k);
      } else {
        // update z_jk one at a time
        for (int j=0; j<J; j++) {
          update_zjk_repulsive(state, data, prior, locked, j, k);
        }
      }
    }
  }

}


#endif
