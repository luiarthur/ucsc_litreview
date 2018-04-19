#ifndef UPDATE_ALL_JOINTLY_H
#define UPDATE_ALL_JOINTLY_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"
#include "compute_loglike.h"

// Do this once in a while
// Propose from prior
void update_all_jointly(State &state, const Data &data, const Prior &prior, const Locked &locked){
  const int I = data.I;
  const int J = data.J;
  const auto N = data.N;
  const auto K = prior.K;
  const int L0 = get_L0(state);
  const int L1 = get_L1(state);

  int Ni;

  State cand;

  // sample beta
  for (int i=0; i < I; i++) {
    cand.beta_0 = Rcpp::NumericVector(I);
    cand.beta_1 = Rcpp::NumericVector(I);
    if(!locked.beta_0) cand.beta_0(i) = R::rnorm(prior.m_beta0, sqrt(prior.s2_beta0));
    if(!locked.beta_1) cand.beta_1(i) = mcmc::rtnorm(prior.m_beta1, sqrt(prior.s2_beta1), 0, INFINITY);
  }
  // sample mus
  if(!locked.mus_0) {
    cand.mus_0 = Rcpp::NumericVector(L0);
    for (int l=0; l < L0; l++) cand.mus_0(l) = R::rnorm(prior.psi_0, sqrt(prior.tau2_0));
  }
  if(!locked.mus_1) {
    cand.mus_1 = Rcpp::NumericVector(L1);
    for (int l=0; l < L1; l++) cand.mus_1(l) = R::rnorm(prior.psi_1, sqrt(prior.tau2_1));
  }
  // sample s
  if(!locked.s) {
    cand.s = Rcpp::NumericVector(I);
    for (int i=0; i<I; i++) cand.s(i) = R::rgamma(prior.a_s, 1/prior.b_s);
  }
  // sample sig2
  if(!locked.sig2_0){
    cand.sig2_0 = Rcpp::NumericMatrix(I, L0);
    for (int i=0; i<I; i++) for (int l=0; l < L0; l++) {
      cand.sig2_0(i,l) = mcmc::rinvgamma(prior.a_sig, cand.s(i));
    }
  }
  if(!locked.sig2_1){
    cand.sig2_1 = Rcpp::NumericMatrix(I, L1);
    for (int i=0; i<I; i++) for (int l=0; l < L1; l++) {
      cand.sig2_1(i,l) = mcmc::rinvgamma(prior.a_sig, cand.s(i));
    }
  }
  // sample alpha
  if(!locked.alpha && !locked.Z) {
    cand.alpha = R::rgamma(prior.a_alpha, 1/prior.b_alpha);
  }
  // sample v
  if(!locked.v && !locked.Z) {
    cand.v = Rcpp::NumericVector(K);
    for (int k=0; k < K; k++) cand.v(k) = R::rbeta(cand.alpha/K, 1);
  }
  // sample H
  if(!locked.H && !locked.Z) {
    cand.H.resize(J,K);
    for (int k=0; k < K; k++) {
      for (int j=0; j<J; j++) {
        cand.H(j,k) = R::rnorm(0, prior.G(j,j));
      }
    }
  }
  // sample Z
  if (!locked.Z) {
    cand.Z = Rcpp::IntegerMatrix(J,K);
    update_Z(cand, data, prior, locked);
  }
  // sample W
  arma::rowvec d_W(K);
  d_W.fill(prior.d_W);
  arma::rowvec Wi_new(K);
  if (!locked.W) {
    cand.W = Rcpp::NumericMatrix(I,K);
    for (int i=0; i<I; i++) {
      Wi_new = mcmc::rdir(d_W);
      cand.W(i, _) = Rcpp::NumericVector(Wi_new.begin(), Wi_new.end());
    }
  }

  // sample lam
  if (!locked.lam) {
    cand.lam.resize(I);
    for (int i=0; i<I; i++) {
      double log_p[K];
      Ni = N(i);
      cand.lam[i] = Rcpp::IntegerVector(Ni);
      for (int n=0; n<Ni; n++) {
        for (int k=0; k<K; k++) log_p[k] = log(cand.W(i,k));
        cand.lam[i](n) = mcmc::wsample_index_log_prob(log_p, K);
      }
    }
  }
  // sample eta
  arma::rowvec a_eta_0(L0);
  a_eta_0.fill(get_a_eta_z(prior, 0));
  cand.eta_0.resize(I,J,L0);

  arma::rowvec a_eta_1(L1);
  a_eta_1.fill(get_a_eta_z(prior, 1));
  cand.eta_1.resize(I,J,L1);

  for (int i=0; i<I; i++) {
    for (int j=0; j<J; j++) {
      if (!locked.eta_0) cand.eta_0.tube(i,j) = mcmc::rdir(a_eta_0);
      if (!locked.eta_1) cand.eta_1.tube(i,j) = mcmc::rdir(a_eta_1);
    }
  }

  // sample gam
  if(!locked.gam) {
    cand.gam.resize(I);
    double log_p0[L0];
    double log_p1[L1];
    int z;
    int Lz;

    for (int i=0; i<I; i++) {
      Ni = N(i);
      cand.gam[i] = Rcpp::IntegerMatrix(Ni, J);
      for (int j=0; j<J; j++) {
        for (int n=0; n<Ni; n++) {
          z = cand.Z(j, cand.lam[i](n));
          Lz = get_Lz(state, z);
          for (int l=0; l<Lz; l++) {
            if (z == 0) {
              log_p0[l] = log(cand.eta_0(i,j,l));
            } else {
              log_p1[l] = log(cand.eta_1(i,j,l));
            }
          }
          if (z == 0) {
            cand.gam[i](n,j) = mcmc::wsample_index_log_prob(log_p0, Lz);
          } else {
            cand.gam[i](n,j) = mcmc::wsample_index_log_prob(log_p1, Lz);
          }
        }
      }
    }
  }

  // sample missing_y
  if(!locked.missing_y) {
    cand.gam.resize(I);
    int l;
    int z;
    double mu;
    double s2;
    for (int i=0; i < I; i++) {
      Ni = N(i);
      cand.missing_y[i] = Rcpp::NumericMatrix(Ni, J);
      for (int j=0; j<J; j++) {
        for (int n=0; n<Ni; n++) {
          z = cand.Z(j, cand.lam[i](n));
          l = state.gam[i](n,j);
          mu = get_mus_z(cand,z)->at(l);
          s2 = get_sig2_z(cand,z)->at(i,l);
          cand.missing_y[i](n,j) = R::rnorm(mu, sqrt(s2));
        }
      }
    }
  }

  // Metropolis
  const double u = R::runif(0,1);
  const bool normalize_loglike = false;
  const double ll_cand = compute_loglike(cand,  data, prior, normalize_loglike);
  const double ll_curr = compute_loglike(state, data, prior, normalize_loglike);
  if (ll_cand - ll_curr > log(u)) {
    state = cand;
    Rcout << "ll_cand - ll_curr: " << ll_cand - ll_curr << std::endl;
    Rcout << "Accepted prior proposal!" << std::endl;
  }
}

#endif
