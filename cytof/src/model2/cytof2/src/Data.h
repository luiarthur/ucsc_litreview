/*
 * Data y:
 *   
 *   is a length (I) vector of (N_i x J) matrices. 
 */

using Data = std::vector<arma::mat>;

bool missing(const Data &y, int i, int n, int j) {
  return NumericVector::is_na(y[i][n, j]);
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
