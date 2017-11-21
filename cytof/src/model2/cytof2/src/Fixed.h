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
 };

Fixed gen_fixed_obj(const Nullable<List> &truth_input) {
  const List truth = truth_input.isNull() ? List::create() : as<List>(truth_input);
  return Fixed {
    truth.containsElementNamed("beta_all"),
    truth.containsElementNamed("mus"),
    truth.containsElementNamed("sig2"),
    truth.containsElementNamed("tau2"),
    truth.containsElementNamed("psi"),
    truth.containsElementNamed("Z"),
    truth.containsElementNamed("lam"),
    truth.containsElementNamed("W"),
    truth.containsElementNamed("missing_y"),
    truth.containsElementNamed("K")
  };
}
