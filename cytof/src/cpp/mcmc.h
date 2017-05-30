#include<RcppArmadillo.h> // linear algebra
#include<functional>      // std::function

using namespace Rcpp;

// Enable C++11 via this plugin (Rcpp 0.10.3 or later)
// [[Rcpp::plugins(cpp11)]]

// [[Rcpp::depends(RcppArmadillo)]]

// Generic Gibbs Sampler
template <typename S>
void gibbs(S state, 
          std::function<void(S&)> update, // function to update state
          std::function<void(const S&, int)> assign_to_out, // function to assign to out
          int B, int burn, int print_freq) {

  for (int i=0; i<B+burn; i++) {
    update(state);
    if (i >= burn) {
      assign_to_out(state, i-burn);
    }

    if (print_freq > 0 && (i+1) % print_freq == 0) {
      Rcout << "\rProgress:  " << i+1 << "/" << B+burn << "\t";
    }
  }

  if (print_freq > 0) { Rcout << std::endl; }
}

double logit(double p, double a, double b) {
  return log((p - a) / (b - p));
}

double inv_logit(double x, double a, double b) {
  //return (b * exp(x) + a) / (1 + exp(x));
  const double u = exp(-x);
  return (b + a * u) / (1 + u);
}


// Weighted sampling: takes prob. array and size; returns index.
int wsample_index(const double p[], int n) { // GOOD
  const double p_sum = std::accumulate(p, p+n, 0.0);
  const double u = R::runif(0,p_sum);

  int i = 0;
  double cumsum = 0;

  do {
    cumsum += p[i];
    i++;
  } while (cumsum < u);

  return i-1;
}

int wsample_index_log_prob(const double log_p[], const int n) {
  double p[n];
  const double log_p_max = *std::max_element(log_p, log_p+n);

  for (int i=0; i<n; i++) {
    p[i] = exp(log_p[i] - log_p_max);
  }

  return wsample_index(p, n);
}

//[[Rcpp::export]]
arma::vec rmvnorm(arma::vec m, arma::mat S) {
  int n = m.n_rows;
  arma::mat e = arma::randn(n);
  return arma::vectorise(m + arma::chol(S).t() * e);
}

double logdmvnorm(arma::vec y, arma::vec m, arma::mat S) {
  double ld_S, sign;
  arma::log_det(ld_S, sign, S);

  const int n = y.size();
  const auto c = y - m;
  
  const arma::vec v = c.t() * S.i() * c;
  return -0.5 * (ld_S + v[0] + n * log(2*M_PI));
}

namespace metropolis {

  // Uniariate Metropolis step with Normal proposal
  double uni(double curr, std::function<double(double)> log_fc, 
             double stepSig) {

    const double cand = R::rnorm(curr,stepSig);
    const double u = R::runif(0,1);
    double out;

    if (log_fc(cand) - log_fc(curr) > log(u)) {
      out = cand;
    } else {
      out = curr;
    }

    return out;
  }

  // Uniariate Metropolis step with Normal proposal
  arma::vec mv(arma::vec curr, std::function<double(arma::vec)> log_fc, 
               arma::mat stepSig) {

    const auto cand = rmvnorm(curr, stepSig);
    const double u = R::runif(0, 1);
    arma::vec out;

    if (log_fc(cand) - log_fc(curr) > log(u)) {
      out = cand;
    } else {
      out = curr;
    }

    return out;
  }
}

double lp_gamma(double x, double shape, double rate) {
  return (shape - 1) * log(x) - rate * x;
}

double lp_gamma_with_const(double x, double shape, double rate) {
  return lp_gamma(x, shape, rate) + shape * log(rate) - lgamma(shape);
}

double lp_invgamma(double x, double a, double bNumer) {
  return -(a + 1) * log(x) - bNumer / x;
}

double lp_invgamma_with_const(double x, double a, double bNumer) {
  return lp_invgamma(x, a, bNumer) + a * log(bNumer) - lgamma(a);
}

double lp_log_gamma(double log_x, double shape, double rate) {
  return lp_gamma(exp(log_x), shape, rate) + log_x;
}

double lp_log_invgamma(double log_x, double a, double bNumer) {
  return lp_invgamma(exp(log_x), a, bNumer) + log_x;
}

double lp_log_gamma_with_const(double log_x, double shape, double rate) {
  return lp_gamma_with_const(exp(log_x), shape, rate) + log_x;
}

double lp_log_invgamma_with_const(double log_x, double a, double bNumer) {
  return lp_invgamma_with_const(exp(log_x), a, bNumer) + log_x;
}

double lp_logit_unif(double logit_u) {
  return logit_u - 2 * log(1+ exp(logit_u));
}

// log density of truncated normal
double log_dtnorm(double x, double m, double s, double thresh, bool lt) {
  double ldnorm = R::dnorm(x, m, s, 1);
  double Phi = R::pnorm(x, m, s, 1, 0);
  double out;

  if (lt) {
    out = ldnorm - log(Phi);
  } else {
    out = ldnorm - log(1 - Phi);
  }

  return out;
}

int delta_0(double x) {
  return x == 0 ? 1 : 0;
}

int Ind(bool x) {
  return x ? 1 : 0;
}

arma::rowvec rdir(const arma::vec &a) {
  const int n = a.size();
  arma::rowvec x(n);
  double sum_x = 0;

  for (int i=0; i<n; i++) {
    x[i] = R::rgamma(a[i], 1);
    sum_x += x[i];
  }

  return x / sum_x;
}

// TODO: check this function
double rtnorm(double m, double s, double lo, double hi) {

  double draw, cand;
  bool valid = false;

  while (!valid) {
    cand = R::rnorm(m, s);
    if ((lo < cand) && (cand < hi)) {
      draw = cand;
      valid = true;
    }
  }

  return draw;
}

int runif_discrete(int a, int b) {
  return floor(R::runif(a, b+1));
}