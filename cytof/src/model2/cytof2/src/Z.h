void update_Z(State &state, const Data &y, const Prior &prior) {
  const int J = get_J(y);
  const int K = state.K;
  const auto b = compute_b(state);

  for (int j=0; j<J; j++) {
    for (int k=0; k<K; k++) {
      state.Z(j,k) = compute_zjk(state.H(j,k), prior.G(j,j), b[k]);
    }
  }
}
