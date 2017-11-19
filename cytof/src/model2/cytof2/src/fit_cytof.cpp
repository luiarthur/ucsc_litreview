#include <omp.h>

#include "mcmc.h"

#include "Data.h"
#include "State.h"
#include "Prior.h"
#include "loglike.h"

#include "beta.h" // TODO
#include "gams0.h" // TODO
#include "mus.h"
#include "sig2.h"
#include "tau2.h" // TODO
#include "psi.h" // TODO

#include "v.h"
#include "H.h"
#include "lam.h" // TODO
#include "W.h"

#include "missing_y.h" // TODO
#include "theta.h" // TODO

#include "K.h" // TODO

#include "unit_tests.h"

// Cytof Model for fixed K
//' @export
// [[Rcpp::export]]
std::vector<List> cytof_fix_K_fit(
  const std::vector<arma::mat> &y,
  int B, int burn, int thin, int compute_loglike_every, int print_freq) {

  std::vector<List> out(B);
  return out;
}
