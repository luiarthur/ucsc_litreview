#ifndef UPDATE_H_H
#define UPDATE_H_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"
#include "update_Z.h"
#include "util.h"


// TODO: profile this function. Optimize if bottleneck.
void compute_m_S_for_hjk(const State &state, const Data &data, const Prior &prior, double &m_j, double &S2_j, const int j, const int k) {
  const int J = data.J;
  const auto minus_j = minus_idx(J, j);
  arma::uvec at_k(1); at_k(0) = k;
  arma::uvec at_j(1); at_j(0) = j;
  const auto C = prior.G(at_j, minus_j) * prior.G(minus_j, minus_j).i();

  m_j = arma::as_scalar( C * state.H(minus_j, at_k) );
  S2_j = arma::as_scalar( prior.G(j,j) - C * prior.G(minus_j, at_j) );
}

void update_Hjk(State &state, const Data &data, const Prior &prior, int j, int k) {
  double m_j; double S2_j;
  compute_m_S_for_hjk(state, data, prior, m_j, S2_j, j, k);
  // TODO: Core implementation
}

void update_H(State &state, const Data &data, const Prior &prior, const Locked &locked) {
  const int J = data.J;
  const int K = prior.K;

  if (!locked.H && !locked.Z) {
    for (int j=0; j<J; j++) {
      for (int k=0; k<K; k++) {
        update_Hjk(state, data, prior, j, k);
      }
    }
  }
}


#endif
