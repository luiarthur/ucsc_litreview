#include <omp.h>

#include "mcmc.h"

#include "Data.h"
#include "Data_idx.h" // TODO
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

#include "mytime.h"
#include "theta.h"

#include "K.h" // TODO

#include "unit_tests.h"

//' Cytof Model for fixed K
//'
//' @param y A list of matrices, y[[i]] having dimensions N[i] x J, where N[i] is the number of cells in sample i, J is the number of markers, and i=1,..,I is the sample size with I being the total number of samples.
//' @param B The number of MCMC samples to collect.
//' @param burn The burn-in for MCMC.
//' @param thin Frequency for thinning. e.g. thin=10 means only keep every 10th sample. (default=1, no thinning). 
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
  int thin=1, int compute_loglike_every=1, int print_freq=10, int ncores=1,
  bool show_timings=false, double prop_for_training=.05, bool shuffle_data=false,
  Nullable<List> prior_input = R_NilValue,
  Nullable<List> truth_input = R_NilValue,
  Nullable<List> init_input = R_NilValue) {

  const int I = get_I(y);
  const int J = get_J(y);

  // REMOVE THE FOLLOWING LINES IN PRODUCTION
  const auto idx_of_all_missing = get_idx_of_missing(y);
  arma::uvec top_20(idx_of_all_missing.n_rows);
  for (int i=0; i<idx_of_all_missing.n_rows; i++) top_20[i] = i;
  std::random_shuffle(top_20.begin(), top_20.end());
  top_20.resize(20);
  const arma::Mat<int> idx_of_missing = idx_of_all_missing.rows(top_20);
  // REMOVE THE PRECEDING LINES IN PRODUCTION

  Rcout << "I:" << I << ", J:" << J << std::endl;

  const auto fixed_params = gen_fixed_obj(truth_input);
  const auto prior = gen_prior_obj(prior_input, J);
  const int K = getInitOrFix(safeList(init_input), safeList(truth_input), 
                             "K", (prior.K_min + prior.K_max) / 2);
  const auto init = gen_init_obj(init_input, truth_input, prior, y, K);

  // Random K
  Data y_TE, y_TR;
  std::vector<State> thetas(prior.K_max - prior.K_min + 1);

  if (!fixed_params.K) {
    gen_data_idx(y, prop_for_training, shuffle_data);
    thetas = gen_vec_init_obj(init_input, truth_input, prior, y_TR);
    Rcout << "K is random." << std::endl;
  }
  // End of Random K

  auto update = [&y, &prior, &fixed_params, &y_TR, &y_TE, &thetas, thin, show_timings](State &state) {
    Rcout << "\r";
    for (int t=0; t<thin; t++) {
      update_theta(state, y, prior, fixed_params, show_timings);
      if (!fixed_params.K) { // Random K
        update_K_theta(state, y_TE, y_TR, y, fixed_params, prior, thetas);
      }
    }
  };

  std::vector<List> out(B);

  double ll;
  Data missing_y_sum = std::vector<arma::mat>(I);
  for (int i=0; i<I; i++) {
    missing_y_sum[i] = arma::zeros<arma::mat>(get_Ni(y,i), J);
  }

  auto ass = [&](const State &state, int ii) {
    if (ii - burn >= 0) {
      if ( (ii-burn+1) % compute_loglike_every == 0 || ii == burn ) {
        ll = loglike(state, y);
      }

      for (int s=0; s<I; s++) {
        missing_y_sum[s] += state.missing_y[s];
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
          Named("v") = state.v, // REMOVE IN PRODUCTION
          Named("H") = state.H, // REMOVE IN PRODUCTION
          Named("Z") = state.Z,
          Named("lam") = state.lam, // REMOVE IN PRODUCTION. Just keep last one.
          Named("missing_y_only") = get_missing_only(state, idx_of_missing), // REMOVE IN PRODUCTION
          Named("W") = state.W,
          Named("ll") = ll);
    }

    if (ii - burn == B-1) {
      auto missing_y_mean = init.missing_y;
      for (int s=0; s<I; s++) {
        missing_y_mean[s] = missing_y_sum[s] / B;
      }
      out[B-1]["missing_y_mean"] = missing_y_mean;
      out[B-1]["idx_of_missing"] = idx_of_missing;
    }
  };

  omp_set_num_threads(ncores);
  gibbs<State>(init, update, ass, B, burn, print_freq);

  return out;
}
