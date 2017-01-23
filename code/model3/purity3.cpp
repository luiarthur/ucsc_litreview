#include "mcmc.h"

struct State {
  std::vector<double> v;
  std::vector<double> phi;
  std::vector<double> m;
  double mu;
  double w2;
  double sig2;
};

//[[Rcpp::export]]
List fit(NumericVector n1, NumericVector N1, 
         NumericVector N0, NumericVector M,
         double m_phi, double s2_phi,
         double a_sig, double b_sig,
         double a_mu, double b_mu, double cs_mu,
         double a_m, double b_m, double cs_m,
         double a_w, double b_w,
         double alpha, double a_v, double b_v, double cs_v,
         int B, int burn, int printEvery) {

  const int numLoci = n1.size();

  auto update = [&](State& s_old, State& s_new) {

    // Helper functions
    auto p = [](double mu, double vs, double ms) {
      return mu*vs*ms / (2*(1-mu) + mu*ms);
    };

    auto z = [&](double mu, double ms, int s) {
      return 2*N1[s] / (N0[s] * (2*(1-mu) + mu*ms));
    };

    auto ss = [&](double mu, std::vector<double> phi, std::vector<double> m) {
      double sum = 0;
      for (int s=0; s<numLoci; s++) {
        sum += pow(log(z(mu,m[s],s)) - phi[s], 2.0);
      }
      return sum;
    };


    // update sig2 (Gibbs-step)
    s_new.sig2 = rig(a_sig + numLoci/2, 
                     b_sig + ss(s_old.mu,s_old.phi,s_old.m)/2);


    // update phi (Gibbs-step)
    double phi_denom = s_new.sig2 + s2_phi;
    double phi_mean, phi_sd;

    // note that omp is slower here
    for (int s=0; s<numLoci; s++) {
      phi_mean = ( log(z(s_old.mu,s_old.m[s],s))*s2_phi + 
                   m_phi*s_new.sig2 ) / phi_denom;
      phi_sd = sqrt(s_new.sig2 * s2_phi / phi_denom);
      s_new.phi[s] = R::rnorm(phi_mean, phi_sd);
    }


    // update mu (Met-logit)
    auto llMu = [&](double mu) {
      double ll1 = -ss(mu, s_new.phi, s_old.m) / (2*s_new.sig2);
      double ll2 = 0.0;

      for (int s=0; s<numLoci; s++) {
        double ps = p(mu, s_old.v[s], s_old.m[s]);
        ll2 += n1[s] * log(ps) + (N1[s]-n1[s])*log(1-ps);
      }

      return ll1 + ll2;
    };

    auto lpMu = [&](double mu) {
      return (a_mu-1)*log(mu) + (b_mu-1)*log(1-mu);
    };

    s_new.mu = metLogit(s_old.mu, llMu, lpMu, cs_mu);


    // update v (Neal)
    auto lf = [&](double vs, int s) {
      double ps = p(s_new.mu, vs, s_old.m[s]);
      return n1[s]*log(ps) + (N1[s]-n1[s])*log(1-ps);
    };
    auto lg0 = [&](double vs) {return (a_v-1)*log(vs) + (b_v-1)*log(1-vs);};
    auto rg0 = [&]() {return R::rbeta(a_v,b_v);};

    algo8(alpha, s_old.v, s_new.v, cs_v, lf, lg0, rg0, metLogit);


    // update w2 (Gibbs-step)
    double ssM = 0.0;
    for (int s=0; s<numLoci; s++) {
      ssM += pow( log(M[s]/s_old.m[s]), 2);
    }
    s_new.w2 = rig(a_w+numLoci/2, b_w+ssM/2);


    // update m (Met)
    for (int s=0; s<numLoci; s++) {
      auto lp = [&](double ms) {
        double out;

        if (ms <= 0) 
          out = -1E10;
        else
          out = (a_m-1)*log(ms) - b_m*ms;

        return out;
      };
      auto ll = [&](double ms) {
        double out;
        if (ms <= 0) {
          out = -1E10;
        } else {
          double zs = z(s_new.mu, ms, s);
          double ps = p(s_new.mu, s_new.v[s], ms);
          double ll1 = n1[s]*log(ps) + (N1[s]-n1[s])*log(1-ps);
          double ll2 = -pow( log(zs)-s_new.phi[s], 2) / (2*s_new.sig2);
          double ll3 = -pow( log(M[s]/ms), 2) / (2*s_new.w2);
          out = ll1 + ll2 + ll3;
        }
        return out;
      };

      s_new.m[s] = metropolis(s_old.m[s], ll, lp, cs_m);
    }

  };

  // preallocate output;
  List ret;

  std::vector<double> init_v(numLoci, 0.5);
  std::vector<double> init_phi(numLoci, 0.0);
  std::vector<double> init_m(numLoci, 2.0);
  double init_mu = .5;
  double init_w2 = 1;
  double init_sig2 = 1;

  auto init = State{ 
    init_v, init_phi, init_m, init_mu, init_w2, init_sig2
  };


  NumericMatrix out_v(numLoci, B);
  NumericMatrix out_phi(numLoci, B);
  NumericMatrix out_m(numLoci, B);
  NumericVector out_mu(B);
  NumericVector out_w2(B);
  NumericVector out_sig2(B);

  auto samps = gibbs<State>(init, update, B, burn, printEvery);

  for (int i=0; i<B; i++) {
    NumericVector v_col( samps[i].v.begin(), samps[i].v.end() );
    out_v(_,i) = v_col;

    NumericVector phi_col( samps[i].phi.begin(), samps[i].phi.end() );
    out_phi(_,i) = phi_col;

    NumericVector m_col( samps[i].m.begin(), samps[i].m.end() );
    out_m(_,i) = m_col;


    out_mu[i] = samps[i].mu;
    out_w2[i] = samps[i].w2;
    out_sig2[i] = samps[i].sig2;
  }

  ret["v"] = out_v;
  ret["phi"] = out_phi;
  ret["m"] = out_m;
  ret["mu"] = out_mu;
  ret["w2"] = out_w2;
  ret["sig2"] = out_sig2;


  return ret;
}
