// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

// cytof3_unit_tests_cpp
void cytof3_unit_tests_cpp();
RcppExport SEXP _cytof3_cytof3_unit_tests_cpp() {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    cytof3_unit_tests_cpp();
    return R_NilValue;
END_RCPP
}
// test_gen_data_obj
Rcpp::List test_gen_data_obj(const std::vector<Rcpp::NumericMatrix>& y);
RcppExport SEXP _cytof3_test_gen_data_obj(SEXP ySEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const std::vector<Rcpp::NumericMatrix>& >::type y(ySEXP);
    rcpp_result_gen = Rcpp::wrap(test_gen_data_obj(y));
    return rcpp_result_gen;
END_RCPP
}
// fit_cytof_cpp
std::vector<List> fit_cytof_cpp(const std::vector<Rcpp::NumericMatrix>& y, int B, int burn, List prior_ls, List locked_ls, List init_ls, int thin, int thin_some, int compute_loglike_every, int print_freq, int joint_update_freq, bool use_repulsive, bool show_timings, bool normalize_loglike, bool print_new_line, bool print_ll, bool save_gam, bool update_z_by_column);
RcppExport SEXP _cytof3_fit_cytof_cpp(SEXP ySEXP, SEXP BSEXP, SEXP burnSEXP, SEXP prior_lsSEXP, SEXP locked_lsSEXP, SEXP init_lsSEXP, SEXP thinSEXP, SEXP thin_someSEXP, SEXP compute_loglike_everySEXP, SEXP print_freqSEXP, SEXP joint_update_freqSEXP, SEXP use_repulsiveSEXP, SEXP show_timingsSEXP, SEXP normalize_loglikeSEXP, SEXP print_new_lineSEXP, SEXP print_llSEXP, SEXP save_gamSEXP, SEXP update_z_by_columnSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const std::vector<Rcpp::NumericMatrix>& >::type y(ySEXP);
    Rcpp::traits::input_parameter< int >::type B(BSEXP);
    Rcpp::traits::input_parameter< int >::type burn(burnSEXP);
    Rcpp::traits::input_parameter< List >::type prior_ls(prior_lsSEXP);
    Rcpp::traits::input_parameter< List >::type locked_ls(locked_lsSEXP);
    Rcpp::traits::input_parameter< List >::type init_ls(init_lsSEXP);
    Rcpp::traits::input_parameter< int >::type thin(thinSEXP);
    Rcpp::traits::input_parameter< int >::type thin_some(thin_someSEXP);
    Rcpp::traits::input_parameter< int >::type compute_loglike_every(compute_loglike_everySEXP);
    Rcpp::traits::input_parameter< int >::type print_freq(print_freqSEXP);
    Rcpp::traits::input_parameter< int >::type joint_update_freq(joint_update_freqSEXP);
    Rcpp::traits::input_parameter< bool >::type use_repulsive(use_repulsiveSEXP);
    Rcpp::traits::input_parameter< bool >::type show_timings(show_timingsSEXP);
    Rcpp::traits::input_parameter< bool >::type normalize_loglike(normalize_loglikeSEXP);
    Rcpp::traits::input_parameter< bool >::type print_new_line(print_new_lineSEXP);
    Rcpp::traits::input_parameter< bool >::type print_ll(print_llSEXP);
    Rcpp::traits::input_parameter< bool >::type save_gam(save_gamSEXP);
    Rcpp::traits::input_parameter< bool >::type update_z_by_column(update_z_by_columnSEXP);
    rcpp_result_gen = Rcpp::wrap(fit_cytof_cpp(y, B, burn, prior_ls, locked_ls, init_ls, thin, thin_some, compute_loglike_every, print_freq, joint_update_freq, use_repulsive, show_timings, normalize_loglike, print_new_line, print_ll, save_gam, update_z_by_column));
    return rcpp_result_gen;
END_RCPP
}
// shuffle_mat
arma::mat shuffle_mat(arma::mat X);
RcppExport SEXP _cytof3_shuffle_mat(SEXP XSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< arma::mat >::type X(XSEXP);
    rcpp_result_gen = Rcpp::wrap(shuffle_mat(X));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_cytof3_cytof3_unit_tests_cpp", (DL_FUNC) &_cytof3_cytof3_unit_tests_cpp, 0},
    {"_cytof3_test_gen_data_obj", (DL_FUNC) &_cytof3_test_gen_data_obj, 1},
    {"_cytof3_fit_cytof_cpp", (DL_FUNC) &_cytof3_fit_cytof_cpp, 18},
    {"_cytof3_shuffle_mat", (DL_FUNC) &_cytof3_shuffle_mat, 1},
    {NULL, NULL, 0}
};

RcppExport void R_init_cytof3(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
