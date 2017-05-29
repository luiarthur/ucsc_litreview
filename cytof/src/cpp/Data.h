using Data = std::vector<arma::mat>;

int get_I(const Data &y) {
  return y.size();
}

int get_Ni(const Data &y, int i) {
  return y[i].n_rows;
}

int get_J(const Data &y) {
  return y[0].n_cols;
}

double marginal_lf(double y, double mu, double sig, int z, double pi) {
  double ld = log_dtnorm(y, mu, sig, 0, 1);
  double out;
  if (z == 1) {
    out = ld;
  } else {
    out = log(pi * delta_0(y) + (1-pi) * exp(ld));
  }
  return out;
}




/*
 * Data y:
 *   
 *   is a length (I) vector of (N_i x J) matrices. 
 */
