#include <math.h> // isnan
/*
 * Data y:
 *   
 *   is a length (I) vector of (N_i x J) matrices. 
 */

using Data = std::vector<arma::mat>;

bool missing(const Data &y, int i, int n, int j) {
  double y_inj = y[i](n, j);
  return std::isnan(y_inj) || std::isinf(-y_inj);
}

//' Just a test
//' @export
// [[Rcpp::export]]
bool missing_R(const std::vector<arma::mat> &y, int i, int n, int j) {
  Rcout << "Value: " << y[i-1](n-1, j-1) << std::endl;
  return missing(y, i-1, n-1, j-1);
}

int get_I(const Data &y) {
  return y.size();
}

int get_Ni(const Data &y, int i) {
  return y[i].n_rows;
}

int get_J(const Data &y) {
  return y[0].n_cols;
}

std::vector<int> get_N(const Data &y) {
  const int I = get_I(y);
  std::vector<int> N(I);

  for (int i=0; i<I; i++) {
    N[i] = get_Ni(y, i);
  }

  return N;
}
