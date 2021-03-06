#include<omp.h>
// [[Rcpp::plugins(openmp)]]

#include "mcmc.h"
#include "mytime.h"

#include "Data.h"
#include "State.h"
#include "Prior.h"
#include "loglike.h"
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
#include "K_theta.h"   // 5.13.1

#include <omp.h> // openmp for shared memory parallel
// [[Rcpp::plugins(openmp)]]


//[[Rcpp::export]]
std::vector<List> cytof_fit(
    const Data &y_TE, const Data &y_TR, 
    double mus_thresh, arma::mat cs_mu,
    double m_psi, double s2_psi, arma::vec cs_psi,
    double a_tau, double b_tau, arma::vec cs_tau2,
    double s2_c, double cs_c,
    double m_d, double s2_d, double cs_d,
    double a_sig, double b_sig, arma::vec cs_sig2,
    double alpha, double cs_v,
    arma::mat G, double cs_h, double cs_hj,
    double a_w,
    int K_min, int K_max, int a_K,
    Nullable<arma::mat> true_mus, Nullable<arma::vec> true_psi,
    Nullable<arma::vec> true_tau2, Nullable<arma::vec> true_sig2,
    Nullable<arma::Mat<int>> true_Z, Nullable<type_lam> true_lam,
    Nullable<arma::mat> true_W, Nullable<arma::mat> true_pi,
    int burn_small,
    int ncores,
    int B, int burn, int compute_loglike_every, int print_freq) {

  // SET NUM THREADS FOR OMP
  int nProcessors = omp_get_max_threads();
  std::cout<<"nproc: "<< nProcessors<<std::endl;
  //omp_set_num_threads(nProcessors / 2);
  if (ncores > 0) {
    omp_set_num_threads(ncores);
    std::cout<<"threads used: "<<omp_get_num_threads()<<std::endl;
  }

  // join the testing and training data
  std::vector<arma::mat> y(y_TE.size());
  for (int i=0; i<y.size(); i++) {
    y[i] = arma::join_cols(y_TE[i], y_TR[i]);
  }

  const int I = get_I(y);
  const int J = get_J(y);

  // Messages:
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

  // Set up priors
  const auto prior = Prior {
    mus_thresh, cs_mu,
    m_psi, s2_psi, cs_psi,
    a_tau, b_tau, cs_tau2,
    s2_c, cs_c, 
    m_d, s2_d, cs_d,
    a_sig, b_sig, cs_sig2,
    alpha, cs_v, 
    G, R, S2, cs_h,
    a_w,
    K_min, K_max, a_K
  };

  // TODO: FROM HERE ON
  // initialize parameters

  std::vector<int> N_TE(I);
  for (int i=0; i<I; i++) {
    N_TE[i] = y_TE[i].n_rows;
  }


  // init thetas
  // TODO: enable setting this from function
  std::vector<State> thetas(K_max - K_min + 1);
  int K;

  //omp_set_num_threads(4); 
  //#pragma omp parallel shared(thetas) private(K)
  //{
  //#pragma omp for
  for (K=0; K<(K_max - K_min + 1); K++) {
    // 1-D params
    const int KK = K + K_min;

    thetas[K].K = KK;
    thetas[K].mus = arma::mat(J,KK);
    thetas[K].mus.fill(m_psi);
    thetas[K].psi = arma::vec(J);
    thetas[K].psi.fill(m_psi);
    thetas[K].tau2 = arma::vec(J);
    thetas[K].tau2.fill(b_tau);
    thetas[K].pi = arma::mat(I,J);
    thetas[K].pi.fill(.5);
    thetas[K].c = arma::vec(J);
    thetas[K].c.fill(.5);
    thetas[K].d = exp(m_d);
    thetas[K].sig2 = arma::vec(I);
    thetas[K].sig2.fill(b_sig);
    thetas[K].v = arma::vec(KK);
    thetas[K].v.fill(.5);
    thetas[K].H = arma::mat(J,KK);
    thetas[K].H.fill(0);
    thetas[K].W = arma::mat(I,KK);
    thetas[K].W.fill(1.0 / KK);
    thetas[K].Z = arma::Mat<int>(J,KK);
    double b_k = 1;
    for (int j=0; j<J; j++) {
      for (int k=0; k<KK; k++) {
        b_k *= thetas[K].v[k];
        thetas[K].Z(j,k) = compute_z(0, G(j,j), b_k);
      }
    }

    adjust_lam_e_dim(thetas[K], y_TR);

    // little burn in for theta | K, for K = K_min, ... , K_max
    Rcout << "Start burn-in, K: " << KK << std::endl;
    for (int b=0; b<burn_small; b++) {
      Rcout << "\r" << b+1 << " / " << burn_small;
      update_theta(thetas[K], y_TR, prior);
    }
    Rcout << std::endl;
  }

  //}  // end of omp parallel loop

  // init theta
  // TODO: Make this initializable 
  State init_theta = thetas[0];
  // update lambda and e because the dimensions depends on dimensions
  // of the full data
  adjust_lam_e_dim(init_theta, y);

  auto update = [&](State &state) {
    //Rcout << std::endl << std::endl;
    Rcout << "\rCurrent K: " << state.K << "  ";
    //Rcout << "Update K & theta" << std::endl;
    update_K_theta(state, y_TR, y_TE, y, N_TE, prior, thetas);
    //Rcout << "Update theta" << std::endl;
    update_theta(state, y, prior); // y_TE or y???
  };

  std::vector<List> out(B);

  auto ass = [&out](const State &state, int i) {
    out[i] = List::create(
        Named("mus") = state.mus,
        Named("psi") = state.psi,
        Named("tau2") = state.tau2,
        Named("pi") = state.pi,
        Named("c") = state.c,
        Named("d") = state.d,
        Named("sig2") = state.sig2,
        Named("v") = state.v,
        Named("H") = state.H,
        Named("lam") = state.lam, // BIG
        Named("W") = state.W,
        Named("Z") = state.Z,
        //Named("e") = state.e, // BIG
        Named("K") = state.K);
  };

  Rcout << "Start Gibbs..." << std::endl;
  gibbs<State>(init_theta, update, ass, B, burn, print_freq);

  return out;
}
