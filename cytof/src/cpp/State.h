using type_lambda = std::vector<std::vector<int>>;
using type_e      = std::vector<std::vector<std::vector<int>>>;

struct State {
  arma::mat mus;    // J x K
  arma::vec psi;    // J
  arma::vec tau2;   // J
  arma::mat pi;     // I x J
  arma::vec sig2;   // I
  arma::vec v;      // K
  arma::mat H;      // J x K
  type_lambda lam;  // I x N
  arma::mat W;      // I x K
  arma::mat Z;      // J x K
  type_e e;         // I x N x J
  int K;
};
