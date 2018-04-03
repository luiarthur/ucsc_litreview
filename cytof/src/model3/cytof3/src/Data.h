#ifndef DATA_H
#define DATA_H

#include <RcppArmadillo.h>

struct Data {
  const arma::mat Y; // N_sum x J
  const std::vector<arma::uvec> idx; // vector of length I. Each element is vector of N[i] ints.
  const std::vector<int> N; // vector of size I. Represents size of each y[i].
  const int N_sum; // total number of observations
  const int J;
  const int I;
};


// Need to Check!
Data gen_data_obj(const std::vector<arma::mat> &y) {
  // Set I, J
  const int I = y.size();
  const int J = y[0].n_cols;
  
  std::vector<arma::uvec> idx(I);
  std::vector<int> N(I);
  int N_sum = 0;
  int n_current = 0;
  
  for (int i=0; i < I; i++)  {
    // Set N[i], N_sum
    N[i] = y[i].n_rows;    
    N_sum += N[i];
    
    // Set idx[i]
    idx[i].resize(N[i]);
    for (int n=0; n < N[i]; n++) {
      idx[i][n] = n_current;
      n_current++;
    }
  }
  
  // Set Y
  arma::mat Y(N_sum, J);
  for (int i=0; i < I; i++) {
    Y.rows(idx[i]) = y[i];
  }
  
  return Data{Y, idx, N, N_sum, J, I};
}

// [[Rcpp::export]]
Rcpp::List test_gen_data_obj(const std::vector<arma::mat> &y) {
  Data data = gen_data_obj(y);
  return Rcpp::List::create(
    Rcpp::Named("Y") = data.Y,
    Rcpp::Named("idx") = data.idx,
    Rcpp::Named("N") = data.N,
    Rcpp::Named("N_sum") = data.N_sum,
    Rcpp::Named("J") = data.J,
    Rcpp::Named("I") = data.I
  );
}

#endif