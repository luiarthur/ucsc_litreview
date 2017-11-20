using type_lam = std::vector<std::vector<int>>;

struct State {
  arma::vec beta_1;    // J
  arma::mat beta_0;    // I x J
  arma::vec betaBar_0; // J

  arma::mat gams_0;    // I x J
  arma::cube mus;      // I x J x 2
  arma::mat sig2;      // I x J
  arma::vec tau2;      // 2
  arma::vec psi;       // 2

  // Note that v | alpha ~ Beta(alpha, 1). If alpha is random, then
  // in the evalutation of the prior, the normalizing constant is needed!
  arma::vec v;         // K
  arma::mat H;         // J x K
  type_lam lam;        // I x N_i
  arma::mat W;         // I x K
  arma::Mat<int> Z;    // J x K

  std::vector<arma::mat> missing_y; // I x (N_i x J)

  int K;
};

int z(const State &state, int i, int n, int j) {
  return state.Z[j, state.lam[i][n]];
}

int compute_zjk(double h_jk, double G_jj, double b_k) {
  const int lt = 1; // use left tail
  const int lg = 0; // don't log the result
  return Ind(R::pnorm(h_jk, 0, sqrt(G_jj), lt, lg) < b_k);
}

double gam(const State &state, int i, int n, int j) {
  return z(state, i, n, j) == 1 ? 0 : state.gams_0[i, j];
}

double mu(const State &state, int i, int n, int j) {
  int z_inj = z(state, i, n, j);
  return state.mus[i, j, z_inj];
}
