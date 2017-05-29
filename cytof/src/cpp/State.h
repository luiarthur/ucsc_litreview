using type_e = std::vector<arma::Mat<int>>;

struct State {
  arma::mat mus;      // J x K
  arma::vec psi;      // J
  arma::vec tau2;     // J
  arma::mat pi;       // I x J
  arma::vec c;        // J
  double d; 
  arma::vec sig2;     // I
  arma::vec v;        // K
  arma::mat H;        // J x K
  arma::Mat<int> lam; // I x N_i
  arma::mat W;        // I x K
  arma::Mat<int> Z;   // J x K
  type_e e;           // I x N_i x J
  int K;
};
