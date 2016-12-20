#include<Rcpp.h>
#include<functional> // std::function
#include<ctime>
#include<map>

using namespace Rcpp;

// Enable C++11 via this plugin (Rcpp 0.10.3 or later)
// [[Rcpp::plugins("cpp11")]]


double logit(double p) {
  return log(p / (1-p));
}

double invLogit(double x) {
  return 1 / (1 + exp(-x));
}

double metropolis(double curr, std::function<double(double)> ll, std::function<double(double)> lp, double stepSig)
{
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

double metLogit(double curr, std::function<double(double)> ll, std::function<double(double)> lp, double stepSig)
{
  auto lp_logit = [lp](double logit_p) { // capture lp in []
    const double p = invLogit(logit_p);
    const double log_J = -logit_p + 2 * log(p);
    return lp(p) + log_J;
  };
  auto ll_logit = [ll](double logit_p) { return ll(invLogit(logit_p)); };
  return invLogit(metropolis(logit(curr), ll_logit, lp_logit, stepSig));
}


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

double wsample(double x[], double p[], int n) { // GOOD
  return x[wsample_index(p,n)];
}


// neal algorithm 8
NumericVector algo8(double alpha, NumericVector t, 
                    std::function<double(double,int)> lf,
                    std::function<double(double)> lg0,
                    std::function<double()> rg0,
                    std::function<double(double,
                                         std::function<double(double)>,
                                         std::function<double(double)>,
                                         double)> mh,
                    double cs) {
  auto f = [lf](double x, int i){ return exp(lf(x,i)); };
  const int n = t.size();
  std::vector<double> newT(t.begin(), t.end());

  // create a map of unique t's
  std::map<double,int> map_t_count;
  for (int i=0; i<n; i++) {
    if (map_t_count.find( t[i] ) != map_t_count.end()) 
    { // if key exists
      map_t_count[t[i]]++;
    } else {
      map_t_count[t[i]] = 1;
    }
  }

  // update each element in t
  for (int i=0; i<n; i++) {
    map_t_count[newT[i]]--;

    double aux;
    if (map_t_count[newT[i]] > 0) {
      aux = rg0();
    } else {
      aux = newT[i];
      map_t_count.erase(newT[i]);
    }

    double probAux = alpha * f(aux,i);

    const int K = map_t_count.size();
    double prob[K+1];
    double unique_t[K+1];
    
    prob[0] = probAux;
    unique_t[0] = aux;

    int k=1;
    for (auto const& ut : map_t_count) {
      prob[k] = ut.second * f(ut.first,i);
      unique_t[k] = ut.first;
      k++;
    }

    newT[i] = unique_t[wsample_index(prob,K)];
    if (map_t_count.find( newT[i] ) != map_t_count.end()) {
      map_t_count[newT[i]]++;
    } else {
      map_t_count[newT[i]] = 1;
    }
  }

  // update by cluster
  std::map<double,std::vector<int>> map_t_idx;
  for (int i=0; i<n; i++) {
    if (map_t_idx.find( newT[i] ) != map_t_idx.end()) { // if key exists
      map_t_idx[newT[i]].push_back(i);
    } else {
      map_t_idx[newT[i]] = {i};
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
      newT[idx[i]] = new_tj;
    }
  }

  return NumericVector(newT.begin(), newT.end());
}

//////////////////////////////////////////////////////////////////
struct State {
    NumericVector phi;
    double sig2;
    double mu;
    NumericVector v;
    NumericVector m;
    double w2;
}

std::vector<State> gibbs(State init, std::function<S(S)> update, 
                         int B, int burn, int printevery) {

  std::vector<State> out(B);
  out[0] = init;

  for (int i=0; i<B+burn; i++) {
    if (i <= burn) {
      out[0] = update(out[0]);
    } else {
      out[i-burn] = update(out[i-burn-1]);
    }

    if (printEvery > 0 && (i+1) % printEvery == 0) {
      Rcout << "\rProgress:  " << i+1 << "/" << B+burn << "\t";
    }
  }

  return out;
}

//////////////////////////////////////////////////////////////////

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

  const int N = y.size();

  // v
  NumericMatrix out_v(N,B);
  out_v(_,0) = NumericVector(N,0.5);

  // phi
  NumericMatrix out_phi(N,B);
  out_phi(_,0) = NumericVector(N,0.0);

  // m
  NumericMatrix out_m(N,B);
  out_phi(_,0) = NumericVector(N,2.0);

  // mu
  NumericVector out_mu(B);
  out_mu(0) = .5;

  // w2
  NumericVector out_w2(B);
  out_w2(0) = 1;

  // sig2
  NumericVector out_sig2(B);
  out_sig2(0) = 1;


  // functions for neal8
  auto lf = [y,m](double p, int i) {return y[i]*log(p)+(m[i]-y[i])*log(1-p);};
  auto lg0 = [](double p){return 0.0;};
  auto rg0 = [](){return R::runif(0,1);};

  // gibbs loop
  out = gibbs(init, update, B, burn, printEvery)

  return out;
}
