#ifndef DATA_H
#define DATA_H

#include <RcppArmadillo.h>
#include "util.h" // vsum, vmatrix_to_lmatrix

struct Data {
  const std::vector<arma::mat> y; // Data. I x (N[i] x J)
  const Rcpp::IntegerVector N; // vector of size I. Represents size of each y[i].
  const int N_sum; // sum of N
  const int J; // Number of markers
  const int I; // Number of samples
  const std::vector<arma::Mat<int>> M; // Missingness indicator. 1 -> missing, 0 -> observed.
};


// Good.
Data gen_data_obj(const std::vector<arma::mat> &y) {
  // Set I, J
  const int I = y.size();
  const int J = y[0].n_cols;
  
  Rcpp::IntegerVector N(I);
  std::vector<arma::Mat<int>> M(I);
  double y_inj;
  
  for (int i=0; i < I; i++) {
    N[i] = y[i].n_rows;
    M[i].resize(N[i], J);
    for (int j=0; j < J; j++) { // Column-major
      for (int n=0; n < N[i]; n++) {
        y_inj = y[i](n, j);
        M[i](n, j) = std::isnan(y_inj) || std::isinf(-y_inj);
      }
    }
  }
  
  const int N_sum = std::accumulate(N.begin(), N.end(), 0);
  
  return Data{y, N, N_sum, J, I, M};
}

// 'A test function for generating a data object from a list of matrices (y)
// '@param y: List of matrices of same dimensions.
// '@export
// [[Rcpp::export]]
Rcpp::List test_gen_data_obj(const std::vector<arma::mat> &y) {
  Data data = gen_data_obj(y);
  
  return Rcpp::List::create(
    Rcpp::Named("y") = vmatrix_to_lmatrix(data.y),
    Rcpp::Named("N") = data.N,
    Rcpp::Named("N_sum") = data.N_sum,
    Rcpp::Named("J") = data.J,
    Rcpp::Named("I") = data.I,
    Rcpp::Named("M") = vmatrix_to_lmatrix(data.M)
  );
}

#endif
