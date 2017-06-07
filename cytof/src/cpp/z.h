int compute_z(double h_jk, double G_jj, double b_k) {
  return Ind(R::pnorm(h_jk, 0, sqrt(G_jj), 1, 0) < b_k);
  //                                 lt=true, no log
}
