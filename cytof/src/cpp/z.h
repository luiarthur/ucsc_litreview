int compute_z(double h_jk, double G_jj, double b_k) {
  return Ind(R::pnorm(h_jk, 0, G_jj, 1, 0) < b_k);
}
