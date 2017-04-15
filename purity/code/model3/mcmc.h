#include<Rcpp.h>
#include<functional> // std::function
#include<map>

using namespace Rcpp;

// Enable C++11 via this plugin (Rcpp 0.10.3 or later)
// [[Rcpp::plugins("cpp11")]]


// Generic Gibbs Sampler
template <typename S>
std::vector<S> gibbs(S init, std::function<void(S&,S&)> update, 
                     int B, int burn, int print_every) {

  // initialize output
  std::vector<S> out(B);
  for (int i=0; i<B; i++) {out[i] = init;}

  for (int i=0; i<B+burn; i++) {
    if (i <= burn) {
      update(out[0], out[0]);
    } else {
      update(out[i-burn-1], out[i-burn]);
    }

    if (print_every > 0 && (i+1) % print_every == 0) {
      Rcout << "\rProgress:  " << i+1 << "/" << B+burn << "\t";
    }
  }

  if (print_every > 0) { Rcout << std::endl; }

  return out;
}

// random inverse gamma 
double rig(double a, double b) {
  // R::rgamma takes as args: (double shape, double scale)
  // note also that 
  // X ~ Gamma(sh=a,sc=b) => 1/X ~ IG(sh=a, rate = 1/b)
  // Y ~ IG(sh=a, rate=b) = draw 1 / Gamma(sh=a, sc=1/b)
  return 1 / R::rgamma(a, 1/b);
}

// Uniariate Metropolis step with Normal proposal
double metropolis(double curr, std::function<double(double)> ll, 
                  std::function<double(double)> lp, double stepSig) {
  const double cand = R::rnorm(curr,stepSig);
  const double u = R::runif(0,1);
  double out;

  if (ll(cand) + lp(cand) - ll(curr) - lp(curr) > log(u)) {
    out = cand;
  } else {
    out = curr;
  }

  return out;
}

// Univariate Metropolis step with logit transform
double metLogit(double curr, std::function<double(double)> ll, 
                std::function<double(double)> lp, double stepSig) {

  auto logit = [](double p) { return log(p/(1-p)); };
  auto invLogit = [](double x) { return 1 / (1 + exp(-x)); };

  // capture invLogit,lp in []
  auto lp_logit = [invLogit,lp](double logit_p) {
    const double p = invLogit(logit_p);
    //const double log_J = -logit_p + 2*log(p); // ???
    const double log_J = -logit_p - 2*log(1+exp(logit_p)); // ???
    return lp(p) + log_J;
  };

  auto ll_logit = [invLogit,ll](double logit_p) { 
    return ll(invLogit(logit_p)); 
  };

  return invLogit(metropolis(logit(curr),ll_logit,lp_logit,stepSig));
}

// Weighted sampling: takes prob. array and size; returns index.
int wsample_index(double p[], int n) { // GOOD
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

double max(double x[], int n) {
  double mx = x[0];
  for (int i=1; i<n; i++) {
    if (x[i] > mx) {
      mx = x[i];
    }
  }
  return mx;
}

// weighted sampling of log probs
int wsampleLogProb_index(double logProb[], const int n) {
  double mx = max(logProb,n);
  double prob[n]; 
  for (int i=0; i<n; i++) {
    prob[i] = exp(logProb[i] - mx);
  }
  return wsample_index(prob,n);
}

void algo8(double alpha, 
           std::vector<double> &t_old, 
           std::vector<double> &t_new, 
           double cs,
           std::function<double(double,int)> lf,
           std::function<double(double)> lg0,
           std::function<double()> rg0,
           std::function<double(double,
                                std::function<double(double)>,
                                std::function<double(double)>,
                                double)> mh) {

  const int n = t_old.size();

  // create a map of unique t's
  std::map<double,int> map_t_count;
  for (int i=0; i<n; i++) {
    map_t_count[ t_old[i] ]++;
    t_new[i] = t_old[i];
  }

  // update each element in t
  for (int i=0; i<n; i++) {
    map_t_count[t_new[i]]--;

    double aux;
    if (map_t_count[t_new[i]] > 0) {
      aux = rg0();
    } else {
      aux = t_new[i];
      map_t_count.erase(t_new[i]);
    }

    double logProbAux = log(alpha) + lf(aux,i);

    const int K = map_t_count.size() + 1;
    double logProb[K];
    double unique_t[K];
    
    logProb[0] = logProbAux;
    unique_t[0] = aux;

    int k=1;
    for (auto const& ut : map_t_count) {
      logProb[k] = log(ut.second) + lf(ut.first,i);
      unique_t[k] = ut.first;
      k++;
    }

    t_new[i] = unique_t[wsampleLogProb_index(logProb,K)];
    map_t_count[ t_new[i] ]++;
  }

  // update by cluster
  std::map<double,std::vector<int>> map_t_idx;
  for (int i=0; i<n; i++) {
    if (map_t_idx.find( t_new[i] ) != map_t_idx.end()) { // if key exists
      map_t_idx[t_new[i]].push_back(i);
    } else {
      map_t_idx[t_new[i]] = {i};
    }
  }
  for (auto const& ut : map_t_idx) {
    auto idx = ut.second;
    auto ll = [idx,lf](double tj) {
      double out = 0;
      for (int i=0; i<idx.size(); i++) { out += lf(tj,idx[i]); }
      return out;
    };
    auto new_tj = mh(ut.first, ll, lg0, cs);
    for (int i=0; i<idx.size(); i++) {
      t_new[idx[i]] = new_tj;
    }
  }
}
