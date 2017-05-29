#include "mcmc.h"

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
                            arma::rowvec a_w,
                            int K_min, int K_max, double a_K,
                            int burn_small,
                            int B, int burn, int print_freq) {

  // Set up priors
  const auto prior = Prior {
    mus_thresh, cs_mu,
    m_psi, s2_psi, cs_psi,
    a_tau, b_tau, cs_tau2,
    s2_c, cs_c, 
    m_d, s2_d, cs_d,
    a_sig, b_sig, cs_sig2,
    alpha, cs_v, 
    G, cs_h, a_w,
    K_min, K_max, a_K
  };

  // create y by concatenating y_TE & y_TR. Better way?
  std::vector<arma::mat> y = y_TE;
  y.insert( y.end(), y_TR.begin(), y_TR.end() );

  // init thetas
  std::vector<State> thetas(K_max - K_min + 1);
  for (int K=0; K<(K_max-K_min); K++) {
    // TODO
    // little burn in for theta | K, for K = K_min, ... , K_max
    for (int i=0; i<burn_small; i++) {
      update_theta(thetas[K], y_TR, prior);
    }
  }
  
  // init theta
  State init_theta;
  // TODO

  auto update = [&](State &state) {
    update_K_theta(state, y_TR, y_TE, prior, thetas);
    update_theta(state, y, prior); // y_TE or y???
  };

  std::vector<List> out(B);

  auto ass = [&](const State &state, int i) {
    // TODO
  };


  //gibbs<State>(init, update, ass, B, burn, print_freq);

  return out;
}
