struct Data_idx {
  std::vector<arma::uvec> idx_TE;
  std::vector<arma::uvec> idx_TR;
  Data y_TR;
  Data y_TE;
};

Data_idx gen_data_idx(const Data &y, double prop_for_training=.05, bool shuf=false) {
  const int I = get_I(y);
  const auto N = get_N(y);

  int n_train, n_test;
  arma::uvec idx
  std::vector<uvec> idx_train(I);
  std::vector<uvec> idx_test(I);
  Data y_TR, y_TE;

  for (int i=0; i<I; i++) {
    n_train = N[i] * prop_for_training;
    n_test = N[i] - n_train;

    idx = arma::linspace<arma::uvec>(0, N[i]-1, N[i]);
    if (shuf) std::random_shuffle(idx.begin(), idx.end());
    
    idx_train[i] = idx.head(n_train);
    idx_test[i] = idx.tail(n_test);

    y_TR = y.rows(idx_train[i]);
    y_TE = y.rows(idx_test[i]);
  }

  Data_idx out;
  out.idx_TR = idx_train;
  out.idx_TE = idx_test;
  out.y_TR = y_TR;
  out.y_TE = y_TE;
  return out;
}
