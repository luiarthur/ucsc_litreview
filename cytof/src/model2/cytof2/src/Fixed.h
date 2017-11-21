struct Fixed {
  bool beta_all;

  bool gams_0;
  bool mus;
  bool sig2;
  bool tau2;
  bool psi;

  bool Z;
  bool lam;
  bool W;

  bool missing_y;
  bool K;
 };

Fixed gen_fixed_obj(const Nullable<List> &truth_input) {
  const List truth = truth_input.isNull() ? List::create() : as<List>(truth_input);
  Fixed f;

  f.beta_all = truth.containsElementNamed("beta_all");
  f.gams_0 = truth.containsElementNamed("gams_0");
  f.mus = truth.containsElementNamed("mus");
  f.sig2 = truth.containsElementNamed("sig2");
  f.tau2 = truth.containsElementNamed("tau2");
  f.psi = truth.containsElementNamed("psi");
  f.Z = truth.containsElementNamed("Z");
  f.lam = truth.containsElementNamed("lam");
  f.W =  truth.containsElementNamed("W");
  f.missing_y = truth.containsElementNamed("missing_y");
  f.K =  truth.containsElementNamed("K");

  return f;
}
