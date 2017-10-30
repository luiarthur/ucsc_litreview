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

double marginal_lfz0(double y, double mu, double sig, double pi) {
  double f = dtnorm(y, mu, sig, 0, false); // lt = false
  return log(pi * delta_0(y) + (1-pi) * f);
}

double marginal_lfz1(double y, double mu, double sig, double pi) {
  return log_dtnorm(y, mu, sig, 0, false); // lt = false
}


double marginal_lf(double y, double mu, double sig, int z, double pi) {
  double out;
  if (z == 1) {
    out = marginal_lfz1(y, mu, sig, pi);
  } else {
    out = marginal_lfz0(y, mu, sig, pi);
  }
  return out;
}



/*
 * Data y:
 *   
 *   is a length (I) vector of (N_i x J) matrices. 
 */
