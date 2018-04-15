#ifndef UPDATE_VH_H
#define UPDATE_VH_H

#include "mcmc.h"
#include "State.h"
#include "Data.h"
#include "Prior.h"
#include "Locked.h"
#include "update_Z.h"
#include "util.h" // minus_idx
#include "update_H.h"
#include "dmixture.h"

arma::vec vH_to_vecLogitVH(Rcpp::NumericVector v, arma::mat H) {
  const int K = H.n_cols;
  const int J = H.n_rows;
  int c=0;

  arma::vec out(K + J*K);

  for (int k=0; k<K; k++) {
    out(c) = mcmc::logit(v(k));
    c++;
  }

  for (int k=0; k<K; k++) {
    for (int j=0; j<J; j++) {
      out(c) = H(j,k);
      c++;
    }
  }

  return out;
}

void vecLogitVH_to_vH(Rcpp::NumericVector &v, arma::mat &H, arma::vec vecLogitVH) {
  const int K = H.n_cols;
  const int J = H.n_rows;
  int c = 0;

  for (int k=0; k<K; k++) {
    v(k) = mcmc::sigmoid(vecLogitVH(c));
    c++;
  }

  for (int j=0; j<J; j++) {
    for (int k=0; k<K; k++) {
      H(j,k) = vecLogitVH(c);
      c++;
    }
  }
}

void update_vH(State &state, const Data &data, const Prior &prior, const Locked&locked) {
  const int J = data.J;
  const int I = data.I;
  const int K = prior.K;

  if (!locked.Z) {
    arma::mat Gi = prior.G.i();
    auto log_fc = [&](arma::vec vecLogitVH) {
      double ll = 0;
      double lp = 0;

      Rcpp::NumericVector v(K);
      arma::mat H(J, K);
      vecLogitVH_to_vH(v, H, vecLogitVH);
      
      // log prior for v
      const Rcpp::NumericVector log_v = log(v);
      const double sum_log_v = Rcpp::sum(log_v);
      lp += (state.alpha / K - 1) * sum_log_v;

      // log prior for H
      arma::colvec hk(J);
      for (int k=0; k<K; k++) {
        hk = H.col(k);
        lp += arma::as_scalar(hk.t() * Gi * hk) / (-2);
      }

      // log likelihood
      int Ni;
      int z_j_lin;

      Rcpp::IntegerMatrix Z(J,K);
      for (int k=0; k<K; k++) {
        for (int j=0; j<J; j++) {
          Z(j,k) = compute_zjk(H(j,k), prior.G(j,j), v(k));
        }
      }

      for (int i=0; i<I; i++) {
        Ni = data.N(i);
        for (int j=0; j<J; j++) {
          for (int n=0; n<Ni; n++) {
            z_j_lin = Z(j, state.lam[i](n));
            ll += dmixture(state, data, prior, z_j_lin, i, n, j);
          }
        }
      }

      return ll + lp;
    };


    // Create cs vector
    arma::vec cs(K + J*K);
    int c = 0;
    for (int k=0; k<K; k++) {
      cs(c) = prior.cs_v;
      c++;
    }
    for (int k=0; k<K; k++) {
      for (int j=0; j<J; j++) {
        cs(c) = prior.cs_h;
        c++;
      }
    }

    arma::vec vecLogitVH = vH_to_vecLogitVH(state.v, state.H);
    vecLogitVH = mcmc::mh_mv_ind<arma::vec>(vecLogitVH, log_fc, cs);

    vecLogitVH_to_vH(state.v, state.H, vecLogitVH);
    update_Z(state, data, prior, locked);
  }
}

#endif
