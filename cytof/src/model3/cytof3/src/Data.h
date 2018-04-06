#ifndef DATA_H
#define DATA_H

#include <Rcpp.h>

struct Data {
  const std::vector<Rcpp::NumericMatrix> y; // Data. I x (N[i] x J)
  const Rcpp::IntegerVector N; // vector of size I. Represents size of each y[i].
  const int N_sum; // sum of N
  const int J; // Number of markers
  const int I; // Number of samples
  const std::vector<Rcpp::IntegerMatrix> M; // Missingness indicator. 1 -> missing, 0 -> observed.
};


// Good.
Data gen_data_obj(const std::vector<Rcpp::NumericMatrix> &y) {
  // Set I, J
  const int I = y.size();
  const int J = y[0].ncol();
  
  Rcpp::IntegerVector N(I);
  std::vector<Rcpp::IntegerMatrix> M(I);
  double y_inj;
  
  for (int i=0; i < I; i++) {
    N[i] = y[i].nrow();
    M[i] = Rcpp::IntegerMatrix(N[i], J);
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

//' A test function for generating a data object from a list of matrices (y)
//' @param y: List of matrices of same dimensions.
//' @export
// [[Rcpp::export]]
Rcpp::List test_gen_data_obj(const std::vector<Rcpp::NumericMatrix> &y) {
  Data data = gen_data_obj(y);
  
  return Rcpp::List::create(
    Rcpp::Named("y") = data.y,
    Rcpp::Named("N") = data.N,
    Rcpp::Named("N_sum") = data.N_sum,
    Rcpp::Named("J") = data.J,
    Rcpp::Named("I") = data.I,
    Rcpp::Named("M") = data.M
  );
}

#endif
