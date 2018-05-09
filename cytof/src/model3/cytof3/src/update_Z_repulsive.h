#ifndef UPDATE_Z_REPULSIVE_H
#define UPDATE_Z_REPULSIVE_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"
#include <omp.h>

int flip_bit(int z, double p) {
  // Randomly flip z between 0 and 1 with probability p
  // 0 < p < 1
  int out = z;

  if (p > R::runif(0,1)) {
    // flip the bit
    if (z==0) {
      out = 1;
    } else {
      out = 0;
    }
  }

  return out;
}

Rcpp::IntegerVector flip_bits(Rcpp::IntegerVector zk, double p) {
  const int J = zk.size();
  Rcpp::IntegerVector out(J);

  for (int j=0; j<J; j++) {
    out(j) = flip_bit(zk(j), p);
  }

  return out;
}

void update_zjk_repulsive(State &state, const Data &data, const Prior &prior, int j, int k){
  // TODO
  throw Rcpp::exception("In `update_zjk_repulsive`: NOT IMPLEMENTED!");
}

// Computes the distance between z
// We want high distance to be high in value
// This is `1-C0` in our manuscript
double dist_z(Rcpp::IntegerVector z1, Rcpp::IntegerVector z2, double nu) {
  return 1 - exp( -sum(abs(z1 - z2)) / (2 * nu) );
}

void update_zk_repulsive(State &state, const Data &data, const Prior &prior, int k){
  // TODO
  const Rcpp::IntegerVector zk_cand = flip_bits(state.Z(_,k), prior.a_Z);
  const Rcpp::IntegerVector zk_curr = state.Z(_,k);
  const double vk = state.v(k);
  const int J = data.J;
  const int I = data.I;
  int Ni;
  const int K = prior.K;

  auto log_fc = [&](Rcpp::IntegerVector zk) {
    double ll = 0;
    double lp = 0;

    // prior computation
    int zk_sum = sum(zk);
    lp += zk_sum * log(vk) + (J - zk_sum) * log(1-vk);
    for (int kk=0; kk < K; kk++) {
      if (kk != k) {
        lp += log(dist_z(zk, state.Z(_,kk), state.nu));
      }
    }

    // likelihood computation
    for (int i=0; i<I; i++) {
      Ni = data.N(i);
      for (int j=0; j<J; j++) {
        for (int n=0; n<Ni; n++) {
          if (state.lam[i](n) == k) {
            ll += log(dmixture(state, data, prior, zk(j), i, n, j));
          }
        }
      }
    }

    return ll + lp;
  };

  const double u = R::runif(0,1);
  if (log_fc(zk_cand) - log_fc(zk_curr) > u) {
    state.Z(_,k) = zk_cand;
  }
}

void update_Z_repulsive(State &state, const Data &data, const Prior &prior, const Locked &locked, bool update_z_by_column=true){

  if(!locked.Z) {
    const int J = data.J;
    const int K = prior.K;
    for (int k=0; k<K; k++) {
      if (update_z_by_column) {
        // update z_k a column at a time
        update_zk_repulsive(state, data, prior, k);
      } else {
        // update z_jk one at a time
        for (int j=0; j<J; j++) {
          update_zjk_repulsive(state, data, prior, j, k);
        }
      }
    }
  }

}


#endif
