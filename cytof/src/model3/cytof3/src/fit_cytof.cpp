#include "mcmc.h"
#include "Data.h"
#include "Prior_addon.h"
#include "State_addon.h"
#include "Fixed_addon.h"

using namespace Rcpp;

//' Cytof Model for fixed K
//' @export
// [[Rcpp::export]]
std::vector<List> fit_cytof_cpp(
    const std::vector<arma::mat> &y, int B, int burn,
    List prior_ls, List fixed_ls, List init_ls,
    int warmup=100,
    int thin=1, int thin_K=5,
    int compute_loglike_every=1, int print_freq=10, int ncores=1,
    bool show_timings=false, double prop_for_training=.05, bool shuffle_data=false,
    bool normalize_loglike=false) {
    
    std::vector<List> out(B);
    return out;  
}  
