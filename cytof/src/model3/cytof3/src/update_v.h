#ifndef UPDATE_V_H
#define UPDATE_V_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"
#include "update_Z.h"
#include "dmixture.h"

void update_v_jointly(State &state, const Data &data, const Prior &prior, const Locked &locked){
  const int K = prior.K;
  const int J = data.J;
  const int I = data.I;

  auto log_fc = [&](Rcpp::NumericVector logit_v) {
    const Rcpp::NumericVector v = mcmc::sigmoid_vec(logit_v);
    const Rcpp::NumericVector log_v = log(v);
    const double sum_log_v = Rcpp::sum(log_v);
    //const double lp = state.alpha / K * sum_log_v;
    const double lp = (state.alpha / K - 1) * sum_log_v;

    int z;
    int Ni;
    int k;

    double ll = 0;
    for (int i=0; i<I; i++) {
      Ni = data.N(i);
      for (int j=0; j<J; j++) {
        for (int n=0; n<Ni; n++) {
          k = state.lam[i](n);
          z = compute_zjk(state.H(j,k), prior.G(j,j), v(k));
          ll += dmixture(state, data, prior, z, i, n, j);
        }
      }
    }

    return ll + lp;
  };

  /** Method 1: */
  /**
  Rcpp::NumericVector cs(K, prior.cs_v);
  const auto logit_v_cand = mcmc::rnorms(mcmc::logit_vec(state.v), cs);
  const auto v_cand = mcmc::sigmoid_vec(logit_v_cand);
  Rcpp::IntegerMatrix Z_cand(J, K);
  for (int k=0; k<K; k++) {
    for (int j=0; j<J; j++) {
      Z_cand(j,k) = compute_zjk(state.H(j,k), prior.G(j,j), v_cand(k));
    }
  }

  if (Rcpp::is_true(Rcpp::any(Z_cand != state.Z))) { //TODO: Is this really useful?
    const double u = R::runif(0,1);
    if (log_fc(logit_v_cand) - log_fc(mcmc::logit_vec(state.v)) > log(u)) {
      state.v = mcmc::sigmoid_vec(logit_v_cand);
      update_Z(state, data, prior, locked);
    }
  }
  **/

  /** Method 2: */
  const Rcpp::NumericVector cs(K, prior.cs_v);
  const Rcpp::NumericVector curr_logit_v = mcmc::logit_vec(state.v);
  const Rcpp::NumericVector cand_logit_v = mcmc::rnorms(curr_logit_v, cs);
  const double u = R::runif(0,1);
  if (log_fc(cand_logit_v) - log_fc(curr_logit_v) > log(u)) {
    state.v = mcmc::sigmoid_vec(cand_logit_v);
    update_Z(state, data, prior, locked);
  }
}

void update_v_sequentially(State &state, const Data &data, const Prior &prior, const Locked &locked){
 throw Rcpp::exception("In `update_v`: `joint_update=false` is not implemented.");
}

void update_v(State &state, const Data &data, const Prior &prior, const Locked &locked, bool joint_update=true){
  if (!locked.v && !locked.Z) {
    if (joint_update) {
      update_v_jointly(state, data, prior, locked);
    } else {
      update_v_sequentially(state, data, prior, locked);
    }
  }
}

#endif
