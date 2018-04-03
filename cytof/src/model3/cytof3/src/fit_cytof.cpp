#include "mcmc.h"

//' Cytof Model for fixed K
//' @export
// [[Rcpp::export]]
std::vector<List> cytof_fix_K_fit(
    const std::vector<arma::mat> &y, int B, int burn,
    int warmup=100,
    int thin=1, int thin_K=5,
    int compute_loglike_every=1, int print_freq=10, int ncores=1,
    bool show_timings=false, double prop_for_training=.05, bool shuffle_data=false,
    bool normalize_loglike=false,
    Nullable<List> prior_input = R_NilValue,
    Nullable<List> truth_input = R_NilValue,
    Nullable<List> init_input = R_NilValue) {
    
    std::vector<List> out(B);
    return out;  
}  