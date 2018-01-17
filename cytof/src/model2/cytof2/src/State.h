using type_lam = std::vector<arma::Col<int>>;

struct State {
  arma::vec beta_1;    // J
  arma::vec x;         // J
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
  return state.Z(j, state.lam[i][n]);
}

int compute_zjk(double h_jk, double G_jj, double b_k) {
  const int lt = 1; // use left tail
  const int lg = 0; // don't log the result
  return Ind(R::pnorm(h_jk, 0, sqrt(G_jj), lt, lg) < b_k);
}

double gam(const State &state, int i, int n, int j) {
  return z(state, i, n, j) == 1 ? 0 : state.gams_0(i, j);
}

double mu(const State &state, int i, int n, int j) {
  int z_inj = z(state, i, n, j);
  return state.mus(i, j, z_inj);
}

// Check to see if the truth is specified, if so use it.
// otherwise, check if an initial value is provided, if so use it.
// otherwise, initialize.
template<typename T>
T getInitOrFix(List init_ls, List truth_ls, const char* param, T init) {
  if (truth_ls.containsElementNamed(param)) {
    Rcout << param << " is fixed at truth." << std::endl;
    return truth_ls[param];
  } else if (init_ls.containsElementNamed(param)) {
    Rcout << param << " is provided with initial values." << std::endl;
    return init_ls[param];
  } else {
    Rcout << param << " is initialized internally." << std::endl;
    return init;
  }
}

List safeList(Nullable<List> ls) {
  return ls.isNull() ? List::create() : as<List>(ls);
}

State gen_init_obj(const Nullable<List> &init_input,
                   const Nullable<List> &truth_input, 
                   const Prior &prior, const Data &y, int K) {
  const List init = safeList(init_input);
  const List truth = safeList(truth_input);

  const int I = get_I(y);
  const int J = get_J(y);
  const auto N = get_N(y);

  State state;
  state.K = K;

  const arma::vec init_beta_1 = arma::ones<arma::vec>(J);
  state.beta_1 = getInitOrFix(init, truth, "beta_1", init_beta_1);

  const arma::vec init_x = arma::ones<arma::vec>(J);
  state.x = getInitOrFix(init, truth, "x", init_x);

  const arma::mat init_beta_0 = arma::zeros<arma::mat>(I,J);
  state.beta_0 = getInitOrFix(init, truth, "beta_0", init_beta_0);

  const arma::vec init_betaBar_0 = arma::zeros<arma::vec>(J);
  state.betaBar_0 = getInitOrFix(init, truth, "betaBar_0", init_betaBar_0);

  const arma::mat init_gams_0 = arma::ones<arma::mat>(I,J);
  state.gams_0 = getInitOrFix(init, truth, "gams_0", init_gams_0);

  arma::cube init_mus(I, J, 2);
  init_mus.slice(0).fill(-1);
  init_mus.slice(1).fill(1);
  state.mus = getInitOrFix(init, truth, "mus", init_mus);

  const arma::mat init_sig2 = arma::ones<arma::mat>(I,J);
  state.sig2 = getInitOrFix(init, truth, "sig2", init_sig2);

  arma::vec init_tau2(2);
  init_tau2(0) = 1;
  init_tau2(1) = 1;
  state.tau2 = getInitOrFix(init, truth, "tau2", init_tau2);

  arma::vec init_psi(2);
  init_psi(0) = -1;
  init_psi(1) = 1;
  state.psi = getInitOrFix(init, truth, "psi", init_psi);

  type_lam init_lam = type_lam(I);
  for (int i=0; i<I; i++) {
    init_lam[i] = arma::Col<int>(N[i]);
    for (int n=0; n<N[i]; n++) {
      //init_lam[i][n] = 0;
      init_lam[i][n] = floor(R::runif(0,K));
    }
  };
  state.lam = getInitOrFix(init, truth, "lam", init_lam);

  const arma::mat init_W = arma::ones<arma::mat>(I,K) / K;
  state.W = getInitOrFix(init, truth, "W", init_W);

  // Z
  //const arma::vec init_v = arma::ones<arma::vec>(K) / K;
  const arma::vec init_v = arma::randu<arma::vec>(K);
  state.v = getInitOrFix(init, truth, "v", init_v);

  //const arma::mat init_H = arma::zeros<arma::mat>(J,K);
  const arma::mat init_H = arma::randn<arma::mat>(J,K);
  state.H = getInitOrFix(init, truth, "H", init_H);

  const arma::vec b = arma::cumprod(state.v);
  arma::Mat<int> init_Z = arma::zeros<arma::Mat<int>>(J,K);
  for (int j=0; j<J; j++) {
    for (int k=0; k<K; k++) {
      init_Z(j,k) = compute_zjk(state.H(j,k), prior.G(j,j), b[k]);
    }
  }
  state.Z = getInitOrFix(init, truth, "Z", init_Z);
  // End of Z

  Data init_missing_y = std::vector<arma::mat>(I);
  for (int i=0; i<I; i++) {
    init_missing_y[i] = arma::zeros<arma::mat>(N[i], J);
    for (int j=0; j<J; j++) {
      for (int n=0; n<N[i]; n++) {
        if (missing(y, i, n, j)) {
          init_missing_y[i](n, j) = -10;
        } else {
          init_missing_y[i](n, j) = y[i](n, j);
        }
      }
    }
  }

  //Rcout << "missing dims (I,J,N1): " <<  get_I(init_missing_y) << "," << get_J(init_missing_y) << "," << get_Ni(init_missing_y,0) << std::endl;

  state.missing_y = getInitOrFix(init, truth, "missing_y", init_missing_y);

  return state;
}

void gen_vec_init_obj(const Nullable<List> &init_input,
                      const Nullable<List> &truth_input, 
                      const Prior &prior, const Data_idx &data_idx,
                      std::vector<State> &thetas) {
  const int num_of_k = thetas.size();
  for (int k=0; k<num_of_k; k++) {
    thetas[k] = gen_init_obj(init_input, truth_input, prior, data_idx.y_TR, prior.K_min + k);
  }
}
