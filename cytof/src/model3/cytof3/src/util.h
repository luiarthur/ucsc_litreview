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

// Return the uvec indices with a single index removed
arma::uvec minus_idx(int vec_length, int idx_to_exclude){
  const auto indices = arma::regspace<arma::vec>(0, vec_length-1);
  return arma::find(indices != idx_to_exclude);
}

template <typename T>
std::vector<T> cpVecT(std::vector<T> x) {
  const int N = x.size();
  std::vector<T> out(N);
  for (int n=0; n<N; n++) {
    out[n] = x[n] + 0;
  }
  return out;
}

/*
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
*/

#endif
