#include "mcmc.h"
#include "Data.h"
#include "Prior_addon.h"
#include "State_addon.h"
#include "Fixed_addon.h"
#include "util.h"

#include "missing_mechanism.h"
#include "update_beta.h"

using namespace Rcpp;

//' Cytof Model for fixed K
//' TODO: add descriptions for params
//' @export
// [[Rcpp::export]]
std::vector<List> fit_cytof_cpp(
    const std::vector<arma::mat> &y, int B, int burn,
    List prior_ls, List fixed_ls, List init_ls,
    int thin=1, int thin_some=5,
    int compute_loglike_every=1, int print_freq=10, int ncores=1,
    bool show_timings=false, double prop_for_training=.05, bool shuffle_data=false,
    bool normalize_loglike=false) {
  
    const Prior prior = gen_prior_obj(prior_ls);
    const Fixed fixed= gen_fixed_obj(fixed_ls);
    State init= gen_state_obj(init_ls);
    
    auto update = [&](State &state) {
    };
    
    auto assign_to_out = [&](const State &state, int i) {
    };
    
    mcmc::gibbs<State>(init, update, assign_to_out, B, burn, print_freq);
    
    std::vector<List> out(B);
    return out;  
}  
