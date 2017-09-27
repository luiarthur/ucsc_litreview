#include "mcmc.h"
#include "mytime.h"

#include "Data.h"
#include "State.h"
#include "Prior.h"
#include "Fixed.h" // struct of fixed variables

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
    double mus_thresh, arma::mat cs_mu,
    double m_psi, double s2_psi, arma::vec cs_psi,
    double a_tau, double b_tau, arma::vec cs_tau2,
    double s2_c, double cs_c,
    double m_d, double s2_d, double cs_d,
    double a_sig, double b_sig, arma::vec cs_sig2,
    double alpha, double cs_v,
    arma::mat G, double cs_h, 
    double a_w, int K,
    Nullable<arma::mat> true_mus, Nullable<arma::vec> true_psi,
    Nullable<arma::vec> true_tau2, Nullable<arma::vec> true_sig2,
    Nullable<arma::Mat<int>> true_Z, Nullable<type_lam> true_lam,
    Nullable<arma::mat> true_W, Nullable<arma::mat> true_pi,
    int window, double target, double t,
    int B, int burn, int thin, int print_freq) {

  // SET NUM THREADS FOR OMP
  int nProcessors = omp_get_max_threads();
  std::cout<<"nproc: "<< nProcessors<<std::endl;
  //omp_set_num_threads(nProcessors / 2);
  omp_set_num_threads(3);
  std::cout<<"threads used: "<<omp_get_num_threads()<<std::endl;

  const int I = get_I(y);
  const int J = get_J(y);
  
  /// Messages:
  const bool fixed_mus = true_mus.isNotNull();
  if (fixed_mus) Rcout << "mu is fixed" << std::endl;
  const bool fixed_psi = true_psi.isNotNull();
  if (fixed_psi) Rcout << "psi is fixed" << std::endl;
  const bool fixed_tau2 = true_tau2.isNotNull();
  if (fixed_tau2) Rcout << "tau2 is fixed" << std::endl;
  const bool fixed_sig2 = true_sig2.isNotNull();
  if (fixed_sig2) Rcout << "sig2 is fixed" << std::endl;
  const bool fixed_Z = true_Z.isNotNull();
  if (fixed_Z) Rcout << "Z is fixed" << std::endl;
  const bool fixed_lam = true_lam.isNotNull();
  if (fixed_lam) Rcout << "lam is fixed" << std::endl;
  const bool fixed_W = true_W.isNotNull();
  if (fixed_W) Rcout << "W is fixed" << std::endl;
  const bool fixed_pi = true_pi.isNotNull();
  if (fixed_pi) Rcout << "pi is fixed" << std::endl;

  // create fixed params object
  const auto fixed_params = Fixed {
    fixed_mus,
    fixed_psi,
    fixed_tau2,
    fixed_sig2,
    fixed_Z,
    fixed_lam,
    fixed_W,
    fixed_pi
  };


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

  // start init
  init.K = K;
  init.mus = arma::mat(J,K);
  //init.mus.fill(m_psi);
  init.psi = arma::vec(J);
  init.psi.fill(m_psi);
  init.tau2 = arma::vec(J);
  init.tau2.fill(b_tau / (a_tau - 1));
  init.pi = arma::mat(I,J);
  init.pi.fill(.5);
  init.c = arma::vec(J);
  init.c.fill(.5);
  init.d = exp(m_d);
  init.sig2 = arma::vec(I);
  init.sig2.fill(b_sig / (a_sig - 1));
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
      // TODO: Better way to initialize mus?
      if (init.Z(j,k) == 1) {
        init.mus(j,k) = mus_thresh + .1;
      } else {
        init.mus(j,k) = mus_thresh - .1;
      }
    }
  }
  adjust_lam_e_dim(init, y);
  // reset init if parameters are fixed
  if (fixed_mus)   init.mus = as<arma::mat>(true_mus);
  if (fixed_psi)   init.psi = as<arma::vec>(true_psi);
  if (fixed_tau2)  init.tau2 = as<arma::vec>(true_tau2);
  if (fixed_sig2)  init.sig2 = as<arma::vec>(true_sig2);
  if (fixed_Z)     init.Z = as<arma::Mat<int>>(true_Z);
  if (fixed_lam)   init.lam = as<type_lam>(true_lam);
  if (fixed_W)     init.W = as<arma::mat>(true_W);
  if (fixed_pi)    init.pi = as<arma::mat>(true_pi);
  init.e = sample_e_prior(init.Z, init.lam, init.pi, y);
  // end of init

  auto update = [&y, &prior, &fixed_params](State &state) {
    Rcout << "\r";
    update_theta(state, y, prior, fixed_params);
  };

  std::vector<List> out(B);

  // Adaptive MCMC
  // sum of param
  arma::vec sum_sig2(I);  sum_sig2.fill(0);
  arma::vec sum_psi(J);   sum_psi.fill(0);
  arma::vec sum_tau2(J);  sum_tau2.fill(0);
  arma::mat sum_mus(J,K); sum_mus.fill(0);
  // TODO. need also for: c, d, v, h
  // squared sum of param
  arma::vec sum2_sig2(I);  sum2_sig2.fill(0);
  arma::vec sum2_psi(J);   sum2_psi.fill(0);
  arma::vec sum2_tau2(J);  sum2_tau2.fill(0);
  arma::mat sum2_mus(J,K); sum2_mus.fill(0);
  // TODO. need also for: c, d, v, h

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
          autotune2(log(state.sig2[i]), sum_sig2[i], sum2_sig2[i], prior.cs_sig2[i], ii);
        }
        for (int j=0; j<J; j++) {
          autotune2(state.psi[j], sum_psi[j], sum2_psi[j], prior.cs_psi[j], ii);
          autotune2(log(state.tau2[j]), sum_tau2[j], sum2_tau2[j], prior.cs_psi[j], ii);
          //for (int k=0; k<K; k++) {
          //  autotune2(state.mus(j,k), sum_mus(j,k), sum2_mus(j,k), 
          //            prior.cs_mu(j,k), ii);
          //}
        }
      }
    }
  };

  Rcout << "Start Gibbs..." << std::endl;
  gibbs<State>(init, update, ass, B, burn, print_freq);

  return out;
}
