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

double gam(const State &state, int i, int n, int j) {
  return z(state, i, n, j) == 1 ? 0 : state.gams_0[i, j];
}

double mu(const State &state, int i, int n, int j) {
  int z_inj = z(state, i, n, j);
  return state.mus.slice(z_inj)[i, j];
}
