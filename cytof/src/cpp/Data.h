using Data = std::vector<arma::mat>;

int get_I(const Data &y) {
  return y.size();
}

int get_Ni(const Data &y, int i) {
  return y[i].n_cols;
}

int get_J(const Data &y) {
  return y[0].n_cols;
}

/*
 * Data y:
 *   
 *   is a length (I) vector of (J x N_i) matrices. 
 */
