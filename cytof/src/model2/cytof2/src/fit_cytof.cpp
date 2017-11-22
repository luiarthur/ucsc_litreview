#include <omp.h>

#include "mcmc.h"

#include "Data.h"
#include "Prior.h"
#include "State.h"
#include "Fixed.h"
#include "loglike.h"

#include "beta.h"
#include "gams0.h"
#include "mus.h"
#include "sig2.h"
#include "tau2.h"
#include "psi.h"

#include "v.h"
#include "H.h"
#include "Z.h"
#include "lam.h" // TODO: After theta, do part II
#include "W.h"

#include "missing_y.h"
#include "theta.h"

#include "K.h" // TODO

#include "unit_tests.h"

// Cytof Model for fixed K
//' @export
// [[Rcpp::export]]
std::vector<List> cytof_fix_K_fit(
  const std::vector<arma::mat> &y,
  Nullable<List> prior_input,
  Nullable<List> truth_input,
  Nullable<List> init_input,
  int B, int burn, int thin, int compute_loglike_every, int print_freq) {

  const int I = get_I(y);
  const int J = get_J(y);

  Rcout << "I:" << I << ", J:" << J << std::endl;

  const auto fixed_params = gen_fixed_obj(truth_input);
  const auto prior = gen_prior_obj(prior_input, J);
  const auto init = gen_init_obj(init_input, truth_input, prior, y);


  auto update = [&y, &prior, &fixed_params](State &state) {
    Rcout << "\r";
    update_theta(state, y, prior, fixed_params);
  };

  std::vector<List> out(B);

  double ll;
  auto ass = [&](const State &state, int ii) {
    if (ii - burn >= 0) {
      if ( (ii-burn+1) % compute_loglike_every == 0 || ii == burn ) {
        ll = loglike(state, y);
      }
      out[ii - burn] = List::create(
          Named("beta_1") = state.beta_1,
          Named("beta_0") = state.beta_0,
          Named("betaBar_0") = state.betaBar_0,
          Named("gams_0") = state.gams_0,
          Named("mus") = state.mus,
          Named("sig2") = state.sig2,
          Named("tau2") = state.tau2,
          Named("psi") = state.psi,
          Named("Z") = state.Z,
          Named("lam") = state.lam, // REMOVE IN PRODUCTION
          Named("missing_y") = state.missing_y, // REMOVE IN PRODUCTION
          Named("W") = state.W,
          Named("ll") = ll);
    }
  };

  gibbs<State>(init, update, ass, B, burn, print_freq);

  return out;
}
