#ifndef UTIL_H
#define UTIL_H

#include <RcppArmadillo.h> // linear algebra, and convenient matrices / vectors

//' Shuffle matrix by rows
//' @export
//[[Rcpp::export]]
arma::mat shuffle_mat(arma::mat X) { //Tested. Good.
 const int N = X.n_rows;
 arma::uvec idx = arma::linspace<arma::uvec>(0, N-1, N);
 std::random_shuffle(idx.begin(), idx.end());
 return X.rows(idx);
}

// Not safe. FIXME: Limit type to numerics only?
// see:
//   https://blog.rmf.io/cxx11/almost-static-if
//   https://stackoverflow.com/questions/14294267/class-template-for-numeric-types
//
// Sums over elements of std-vector. Should work for vector<int> and vector<double>
template <typename T>
T vsum(std::vector<T> v) {
 T sum_of_elements = 0;
 
 for (auto& vi : v) {
   sum_of_elements += vi; 
 }
 
 return sum_of_elements;
}

// Tested. Good.
// Converts a vector of arma-matrices to an Rcpp-list of matrices.
template <typename T>
Rcpp::List vmatrix_to_lmatrix(const std::vector<arma::Mat<T>> &vm) {
  const int B = vm.size();
  Rcpp::List out(B);
  
  for (int b=0; b < B; b++) {
    out[b] = vm[b];
  }
  
  return out;
}

#endif
