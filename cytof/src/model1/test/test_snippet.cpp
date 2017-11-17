#include<RcppArmadillo.h>

using namespace Rcpp;

// [[Rcpp::depends(RcppArmadillo)]]


//[[Rcpp::export]]
arma::mat test(const std::vector<arma::mat> &y) {
  
  auto K = y.size();
  Rcout << K << std::endl;

  return y[0];
}

// [[Rcpp::export]]
std::vector<double> test2(double a, double b){
  std::vector<double> out = {a, b};
  return out;
}

class State {
public:
  State(double x_) : x(x_) {}
  double get_x() { return x; }
  void set_x(double x_) { x = x_; }
private:
  double x;
};


RCPP_MODULE(mod) {
  class_<State>( "State" )
  .constructor<double>()
  .property("x", &State::get_x, &State::set_x)
  ;
}

// [[Rcpp::export]]
int wsample_index_vec(const arma::vec p) { // GOOD
  const int n = p.size();
  const double p_sum = arma::sum(p);
  const double u = R::runif(0,p_sum);

  int i = 0;
  double cumsum = 0;

  do {
    cumsum += p[i];
    i++;
  } while (cumsum < u);

  return i-1;
}


// [[Rcpp::export]]
arma::mat submatX(const arma::mat X, int i, int j) { // GOOD
  return X.submat(0, 0, i-1, j-1);
}


