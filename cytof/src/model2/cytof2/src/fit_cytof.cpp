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

//' Cytof Model for fixed K
//'
//' @param y A list of matrices, y[[i]] having dimensions N[i] x J, where N[i] is the number of cells in sample i, J is the number of markers, and i=1,..,I is the sample size with I being the total number of samples.
//' @param B The number of MCMC samples to collect.
//' @param burn The burn-in for MCMC.
//' @param thin Frequency for thinning (default=0, no thinning). (Not Implemented.)
//' @param compute_loglike_every How often to compute log-likelihood. Relative to the rest of the mcmc updates, computing the likelihood is not that expensive. So it's default is 1 (compute log likelihood every iteration).
//' @param print_freq How often to print progress. Setting to 1 is recommended when N is in the order of thousands. (default=10)
//' @param prior_input A list of priors. Set to NULL (default) to use default priors. (More details to come.)
//' @param truth_input A list containing the values of certain parameters to hold fixed. Primarily used for (1) simultaion studies, and (2) fixing K. Set to NULL (default) to disable. 
//' @param init_input A list containing the initial values of the parameters. When set to NULL (default), default initial values are used.
//'
//' @export 
// [[Rcpp::export]]
std::vector<List> cytof_fix_K_fit(
  const std::vector<arma::mat> &y, int B, int burn,
  int thin=0, int compute_loglike_every=1, int print_freq=10,
  Nullable<List> prior_input = R_NilValue,
  Nullable<List> truth_input = R_NilValue,
  Nullable<List> init_input = R_NilValue) {

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
