struct Data_idx {
  std::vector<arma::uvec> idx_TE;
  std::vector<arma::uvec> idx_TR;
  Data y_TR;
  Data y_TE;
};

void gen_data_idx(const Data &y, Data_idx &data_idx, double prop_for_training=.05, bool shuf=false) {
  const int I = get_I(y);
  const auto N = get_N(y);

  int n_train, n_test;
  arma::uvec idx;
  std::vector<arma::uvec> idx_train(I);
  std::vector<arma::uvec> idx_test(I);
  std::vector<arma::mat> y_TR(I);
  std::vector<arma::mat> y_TE(I);

  for (int i=0; i<I; i++) {
    n_train = N[i] * prop_for_training;
    n_test = N[i] - n_train;

    idx = arma::linspace<arma::uvec>(0, N[i]-1, N[i]);
    if (shuf) {
      std::random_shuffle(idx.begin(), idx.end());
    }
    
    idx_train[i] = idx.head(n_train);
    idx_test[i] = idx.tail(n_test);

    y_TR[i] = y[i].rows(idx_train[i]);
    y_TE[i] = y[i].rows(idx_test[i]);
  }

  data_idx.idx_TR = idx_train;
  data_idx.idx_TE = idx_test;
  data_idx.y_TR = y_TR;
  data_idx.y_TE = y_TE;
}
