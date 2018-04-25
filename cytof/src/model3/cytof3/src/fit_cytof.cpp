#include "mcmc.h"
#include "Data.h"
#include "Prior_addon.h"
#include "State_addon.h"
#include "Locked_addon.h"

#include "util.h"
#include "update_theta.h"
#include "compute_loglike.h"
#include "update_all_jointly.h"

#include <omp.h>           // shared memory multicore parallelism
// [[Rcpp::plugins(openmp)]]

using namespace Rcpp;

// TODO. Remove all colon after `at` param.

//' Cytof Model for fixed K
//' TODO: add descriptions for params
//' @param y  A list of NumericMatrix with same number of columns.
//' @param B  (int). Number of MCMC samples (post burn-in).
//' @param burn  (int). Burn in iterations in MCMC.
//' @param prior_ls  Priors. Generated by `gen_default_prior`.
//' @param locked_ls  Parameters that are not random. Generated by `gen_default_locked`.
//' @param init_ls  Initial values. Generated by `gen_default_init`.
//' @param thin  (int). Thinning.
//' @param thin_some  (int). Thinning amount for some parameters.
//' @param compute_loglike_every  (int). Frequency of computing loglike.
//' @param normalize_loglike  (bool). Whether the log-likelihood should be normalized.
//' @param joint_update_freq(int). Frequency of proposing from prior (0 -> don't do it). NOT READY!
//' @param print_new_line(bool). Whether or not to print new line for MCMC progress
//' @export
// [[Rcpp::export]]
std::vector<List> fit_cytof_cpp(
  const std::vector<Rcpp::NumericMatrix> &y, int B, int burn,
  List prior_ls, List locked_ls, List init_ls,
  int thin=1, int thin_some=1,
  int compute_loglike_every=1, int print_freq=10, int ncores=1,
  int joint_update_freq=0,
  bool show_timings=false, 
  bool normalize_loglike=false,
  bool print_new_line=false) {

  omp_set_num_threads(ncores);

  const Prior prior = gen_prior_obj(prior_ls);
  const Locked locked= gen_locked_obj(locked_ls);
  const Data data = gen_data_obj(y);
  const State init = gen_state_obj(init_ls);
  const int I = data.I;
  const int J = data.J;

  //int iter=1;
  
  // update function
  auto update = [&](State &state) {
    for (int t=0; t<thin; t++) {
      TIME_CODE(show_timings, "theta", 
        update_theta(state, data, prior, locked, show_timings, thin_some)
      );
    }

    /** Do giant propose from prior every so often
    if (joint_update_freq > 0 && iter % joint_update_freq == 0) {
      INIT_TIMER;
      TIME_CODE(show_timings, "update_all_jointly", update_all_jointly(state, data, prior, locked));
    }
    iter++;
    */
  };

  // accumulater for sum of missing y's
  std::vector<Rcpp::NumericMatrix> missing_y_mean(I);
  for (int i=0; i<I; i++) {
    missing_y_mean[i] = Rcpp::NumericMatrix(data.N[i], J);
  }
  
  // output 
  std::vector<List> out(B);

  // loglike
  std::vector<double> ll;

  // assign function
  auto assign_to_out = [&](const State &state, int i) {
    // update loglike
    if ( (i-burn+1) % compute_loglike_every == 0 || i == burn ) {
      ll.push_back(compute_loglike(state, data, prior, normalize_loglike));
    }
    // only do the following after burn-in
    if (i - burn >= 0) {
      // update missing_y_mean
      for (int s=0; s<I; s++) {
        missing_y_mean[s] += state.missing_y[s] / B;
      }

      // TODO: profile the speed of these operations
      out[i - burn] = List::create(
        Named("beta_0") = state.beta_0 + 0,
        Named("beta_1") = state.beta_1 + 0,
        //Named("missing_y") = cpVecT<Rcpp::NumericMatrix>(state.missing_y), // remove in production
        Named("mus_0") = state.mus_0 + 0,
        Named("mus_1") = state.mus_1 + 0,
        Named("sig2_0") = state.sig2_0 + 0,
        Named("sig2_1") = state.sig2_1 + 0,
        Named("s") = state.s + 0,
        //Named("gam") = cpVecT<Rcpp::IntegerMatrix>(state.gam), // remove in production
        Named("eta_0") = state.eta_0 + 0,
        Named("eta_1") = state.eta_1 + 0,
        Named("v") = state.v + 0,
        Named("alpha") = state.alpha + 0,
        Named("H") = state.H + 0,
        Named("Z") = state.Z + 0,
        Named("lam") = cpVecT<Rcpp::IntegerVector>(state.lam),
        Named("W") = state.W + 0
      );
    }

    // Append `missing_y_mean` and `missing_y_last` to last iteration of MCMC
    // Append gam to last iteration of MCMC
    // Now, this can serve as init to future MCMC
    if (i == B + burn - 1) {
      out[B-1]["missing_y_mean"] = missing_y_mean;
      out[B-1]["missing_y"] = state.missing_y;
      out[B-1]["gam"] = state.gam;
      out[B-1]["ll"] = ll;
      out[B-1]["prior"] = prior_ls;
    }
  };


  mcmc::gibbs<State>(init, update, assign_to_out, B, burn, print_freq, print_new_line);
  
  return out;  
}  
