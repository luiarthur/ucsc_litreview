#include "mcmc.h"

struct State {
  std::vector<double> v;
  std::vector<double> phi;
  std::vector<double> m;
  double mu;
  double w2;
  double sig2;
}

//[[Rcpp::export]]
NumericMatrix fit(NumericVector n1, NumericVector N1, 
                  NumericVector N0, NumericVector M,
                  // priors
                  double m_phi, double s2_phi,
                  double a_sig, double b_sig,
                  double a_mu, double b_mu, double cs_mu,
                  double a_m, double b_m, double cs_m,
                  double a_w, double b_w,
                  // dpmm prior
                  double alpha, double cs_v,
                  std::function<double(double)> lg0,
                  std::function<double(double)> rg0,
                  // gibbs param
                  int B, int burn, int printEvery) {

  const int numLoci = n1.size();

  auto update = [n1, N1, N0, M, numLoci,
                 m_phi, s2_phi, 
                 a_sig, b_sig,
                 a_mu, b_mu, cs_mu,
                 a_m, b_m, cs_m,
                 a_w, b_w,
                 alpha,cs_v,lg0,rg0](State& s_old, State& s_new) {

    auto p = [](double mu, double vs, double ms) {
      return mu*vs*ms / (2*(1-mu) + mu*ms);
    };

    auto z = [N1,N0](double mu, double ms, int s) {
      return 2*N1[s] / (N0[s] * (2*(1-mu) + mu*ms));
    };

    auto ss = [numLoci](double mu, std::vector<double> phi, std::vector<double> m) {
      double sum = 0;
      for (int s=0; s<numLoci; s++) {
        sum += pow(log(z(mu,m[s],s)) - phi[s], 2.0);
      }
      return sum;
    }

    // update sig2 (Gibbs-step)
    s_new = rig(a_sig+numLoci/2, b_sig+ss(s_old.mu,s_old.phi,s_old.m)/2);

    // update phi (Gibbs-step)
    // update mu (Met-logit)
    // update v (Neal)
    // update w2 (Gibbs-step)
    // update m (Met)

  };

  // return
  List ret;
}
