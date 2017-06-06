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
#include "K_theta.h"   // 5.13.1

#include <omp.h> // openmp for shared memory parallel
// [[Rcpp::plugins(openmp)]]


//[[Rcpp::export]]
std::vector<List> cytof_fit(const Data &y_TE, const Data &y_TR, 
                            double mus_thresh, double cs_mu,
                            double m_psi, double s2_psi, double cs_psi,
                            double a_tau, double b_tau, double cs_tau2,
                            double s2_c, double cs_c,
                            double m_d, double s2_d, double cs_d,
                            double a_sig, double b_sig, double cs_sig2,
                            double alpha, double cs_v,
                            arma::mat G, double cs_h, 
                            double a_w,
                            int K_min, int K_max, int a_K,
                            int burn_small,
                            int B, int burn, int print_freq) {

  std::vector<arma::mat> y(y_TE.size());
  for (int i=0; i<y.size(); i++) {
    y[i] = arma::join_cols(y_TE[i], y_TE[i]);
  }

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
    thetas[K].W.fill(1/KK);
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
  State init_theta = thetas[0];
  // update lambda and e because the dimensions depends on dimensions
  // of the full data
  adjust_lam_e_dim(init_theta, y);

  auto update = [&](State &state) {
    //Rcout << std::endl << std::endl;
    Rcout << "\rCurrent K: " << state.K;
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
        //Named("c") = state.c,
        //Named("d") = state.d,
        Named("sig2") = state.sig2,
        //Named("v") = state.v,
        //Named("H") = state.H,
        Named("lam") = state.lam,
        Named("W") = state.W,
        Named("Z") = state.Z,
        //Named("e") = state.e,
        Named("K") = state.K);
  };

  Rcout << "Start Gibbs..." << std::endl;
  gibbs<State>(init_theta, update, ass, B, burn, print_freq);

  return out;
}
