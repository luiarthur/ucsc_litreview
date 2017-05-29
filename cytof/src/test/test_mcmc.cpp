#include "../cpp/mcmc.h"

struct State { 
  arma::vec beta;
  double sig2;
};

//[[Rcpp::export]]
arma::mat fit(arma::vec y, arma::mat X, 
              arma::vec init_beta, double cs_beta,
              double a_sig, double b_sig, 
              double init_sig2, double cs_sig2,
              int B, int burn, int print_freq) {

  // Initialize
  const int n = X.n_rows;
  const int k = X.n_cols;
  const auto I_n = arma::eye<arma::mat>(n, n);
  const arma::mat XXi = (X.t() * X).i();

  auto init = State{ init_beta, init_sig2 };

  // preallocate output
  arma::mat out(k + 1, B);

  // Update Fn
  auto update = [&] (State& state) {
    // update beta
    auto ll_beta = [&](arma::vec b) {
      //return logdmvnorm(y, X * b, state.sig2 * I_n);
      const auto m = y - X * b;
      const arma::vec ss = m.t() * m;
      return -ss[0] / (2 * state.sig2);
    };

    auto lp_beta = [&](arma::vec b) { return 0; };
    auto lfc_beta = [&](arma::vec b) {
      return lp_beta(b) + ll_beta(b);
    };

    state.beta = metropolis::mv(state.beta, lfc_beta, XXi);
     
    // update sig2
    const auto Xb = X * state.beta;
    auto ll_sig2 = [&](double log_sig2) {
      const auto m = y - Xb;
      const arma::vec ss = m.t() * m;
      const auto sig2 = exp(log_sig2);
      return -(n/2) * log(sig2) - ss[0] /(2 * sig2);
    };
    auto lp_sig2 = [&](double log_sig2) {
      return lp_log_invgamma(log_sig2, a_sig, b_sig);
    };
    auto lfc_sig2 = [&](double log_sig2) {
      return lp_sig2(log_sig2) + ll_sig2(log_sig2);
    };

    state.sig2 = exp(metropolis::uni(log(state.sig2), lfc_sig2, cs_sig2));
  };

  //// Assign Function
  auto ass = [&](State const &state, int i) {
    for (int j=0; j<k; j++) {
      out(j, i) = state.beta(j);
    }
    out(k, i) = state.sig2;
  };


  gibbs<State>(init, update, ass, B, burn, print_freq);

  //return D;
  return out.t();
}
