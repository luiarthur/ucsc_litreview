#include "mcmc.h"
#include "mytime.h"

#include "Data.h"
#include "State.h"
#include "Prior.h"

#include "mus.h"   // 5.1
#include "psi.h"   // 5.2
#include "tau2.h"  // 5.3
#include "pi.h"    // 5.4
#include "sig2.h"  // 5.5

#include "z.h"
#include "v_mus.h"     // 5.6
#include "H_mus.h"     // 5.7

#include "lam.h"   // 5.8
#include "e.h"     // 5.9
#include "w.h"     // 5.10
#include "c.h"     // 5.11
#include "d.h"     // 5.12

#include "theta.h"     // 5.13.2


//[[Rcpp::export]]
std::vector<List> cytof_fix_K_fit(
    const Data &y,
    double mus_thresh, arma::vec cs_mu,
    double m_psi, double s2_psi, arma::vec cs_psi,
    double a_tau, double b_tau, arma::vec cs_tau2,
    double s2_c, double cs_c,
    double m_d, double s2_d, double cs_d,
    double a_sig, double b_sig, arma::vec cs_sig2,
    double alpha, double cs_v,
    arma::mat G, double cs_h, 
    double a_w, int K,
    int window, double target, double t,
    int B, int burn, int print_freq) {

  const int I = get_I(y);
  const int J = get_J(y);

  // precompute matrix inverses for update_H
  arma::vec S2(J);
  arma::mat R(J, J-1);

  for (int j=0; j<J; j++) {
    const auto j_idx = arma::regspace<arma::vec>(0, J-1);
    const arma::uvec minus_j = arma::find(j_idx != j);
    const arma::mat G_minus_j_inv = G(minus_j, minus_j).i();
    const double G_jj = G(j,j);
    arma::uvec at_j; at_j << j;
    const arma::rowvec G_j_minus_j = G(at_j, minus_j);

    R.row(j) = G_j_minus_j * G_minus_j_inv;
    const arma::vec S2j = G_jj - R.row(j) * G_j_minus_j.t();

    S2(j) = S2j(0);
  }

  // Set up prior
  auto prior = Prior {
    mus_thresh, cs_mu,
    m_psi, s2_psi, cs_psi,
    a_tau, b_tau, cs_tau2,
    s2_c, cs_c, 
    m_d, s2_d, cs_d,
    a_sig, b_sig, cs_sig2,
    alpha, cs_v, 
    G, R, S2, cs_h,
    a_w,
    0, 0, 0
  };


  State init;

  init.K = K;
  init.mus = arma::mat(J,K);
  init.mus.fill(m_psi);
  init.psi = arma::vec(J);
  init.psi.fill(m_psi);
  init.tau2 = arma::vec(J);
  init.tau2.fill(b_tau);
  init.pi = arma::mat(I,J);
  init.pi.fill(.5);
  init.c = arma::vec(J);
  init.c.fill(.5);
  init.d = exp(m_d);
  init.sig2 = arma::vec(I);
  init.sig2.fill(b_sig);
  init.v = arma::vec(K);
  init.v.fill(.5);
  init.H = arma::mat(J,K);
  init.H.fill(0);
  init.W = arma::mat(I,K);
  init.W.fill(1.0 / K);
  init.Z = arma::Mat<int>(J,K);
  double b_k = 1;
  for (int j=0; j<J; j++) {
    for (int k=0; k<K; k++) {
      b_k *= init.v[k];
      init.Z(j,k) = compute_z(0, G(j,j), b_k);
    }
  }
  adjust_lam_e_dim(init, y);

  auto update = [&y, &prior](State &state) {
    Rcout << "\r";
    update_theta(state, y, prior);
  };

  std::vector<List> out(B);

  // Adaptive MCMC
  std::vector<double> acc_sig2(I);
  std::vector<double> acc_psi(J);
  std::vector<double> acc_tau2(J);
  State prev_state = init;

  auto ass = [&](const State &state, int ii) {

    if (ii - burn >= 0) {
      out[ii - burn] = List::create(
          Named("mus") = state.mus,
          Named("psi") = state.psi,
          Named("tau2") = state.tau2,
          Named("pi") = state.pi,
          //Named("c") = state.c,
          //Named("d") = state.d,
          Named("sig2") = state.sig2,
          Named("v") = state.v, // remove
          //Named("H") = state.H, // remove
          Named("lam") = state.lam,
          Named("W") = state.W,
          //Named("e") = state.e,
          Named("Z") = state.Z);
    } else { // ii < burn
      // TODO: adaptive MCMC
      if ( window > 0 && ii > 0) {
        for (int i=0; i<I; i++) {
          autotune(acc_sig2[i], prior.cs_sig2[i],
                   state.sig2[i], prev_state.sig2[i],
                   ii, window, target, t);
        }
        for (int j=0; j<J; j++) {
          autotune(acc_psi[j], prior.cs_psi[j],
                   state.psi[j], prev_state.psi[j],
                   ii, window, target, t);
          autotune(acc_tau2[j], prior.cs_tau2[j],
                   state.tau2[j], prev_state.tau2[j],
                   ii, window, target, t);
        }
      }
      prev_state = state;
    }
  };

  Rcout << "Start Gibbs..." << std::endl;
  gibbs<State>(init, update, ass, B, burn, print_freq);

  return out;
}
