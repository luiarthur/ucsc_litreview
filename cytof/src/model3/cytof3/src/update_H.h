#ifndef UPDATE_H_H
#define UPDATE_H_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"
#include "update_Z.h"
#include "util.h" // minus_idx
#include "dmixture.h"

#include <omp.h>

// TODO: profile this function. Optimize if bottleneck.
void compute_m_S2_for_hjk(const State &state, const Data &data, const Prior &prior, double &m_j, double &S2_j, const int j, const int k) {
  const int J = data.J;
  const auto minus_j = minus_idx(J, j);
  arma::uvec at_k(1); at_k(0) = k;
  arma::uvec at_j(1); at_j(0) = j;
  const arma::mat C = prior.G(at_j, minus_j) * prior.G(minus_j, minus_j).i();

  m_j = arma::as_scalar( C * state.H(minus_j, at_k) );
  S2_j = prior.G(j,j) - arma::as_scalar( C * prior.G(minus_j, at_j) );
}

void update_Hjk(State &state, const Data &data, const Prior &prior, int j, int k) {
  double m_j; double S2_j;
  compute_m_S2_for_hjk(state, data, prior, m_j, S2_j, j, k);

  const int I = data.I;

  // TODO: Profile and make more efficient? Joint updates?
  auto log_fc = [&](double h_jk) {
    const double lp = -pow(h_jk - m_j, 2) / (2 * S2_j);
    double ll = 0;
    int Ni;
    int z_jk;

    for (int i=0; i<I; i++) {
      Ni = data.N(i);
      for (int n=0; n<Ni; n++) {
        if (state.lam[i](n) == k) {
          z_jk = compute_zjk(h_jk, prior.G(j,j), state.v(k));
          ll += log(dmixture(state, data, prior, z_jk, i, n, j));
        }
      }
    }

    return lp + ll;
  };

  state.H(j, k) = mcmc::mh(state.H(j,k), log_fc, prior.cs_h);
}

void update_H(State &state, const Data &data, const Prior &prior, const Locked &locked) {
  const int J = data.J;
  const int K = prior.K;

  if (!locked.H && !locked.Z) {
#pragma omp parallel for
    for (int k=0; k<K; k++) {
      for (int j=0; j<J; j++) {
        update_Hjk(state, data, prior, j, k);
        state.Z(j,k) = compute_zjk(state.H(j,k), prior.G(j,j), state.v(k));
      }
    }
  }
}


#endif
