// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

// missing_R
bool missing_R(const std::vector<arma::mat>& y, int i, int n, int j);
RcppExport SEXP _cytof2_missing_R(SEXP ySEXP, SEXP iSEXP, SEXP nSEXP, SEXP jSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const std::vector<arma::mat>& >::type y(ySEXP);
    Rcpp::traits::input_parameter< int >::type i(iSEXP);
    Rcpp::traits::input_parameter< int >::type n(nSEXP);
    Rcpp::traits::input_parameter< int >::type j(jSEXP);
    rcpp_result_gen = Rcpp::wrap(missing_R(y, i, n, j));
    return rcpp_result_gen;
END_RCPP
}
// cytof_fix_K_fit
std::vector<List> cytof_fix_K_fit(const std::vector<arma::mat>& y, Nullable<List> prior_input, Nullable<List> truth_input, Nullable<List> init_input, int B, int burn, int thin, int compute_loglike_every, int print_freq);
RcppExport SEXP _cytof2_cytof_fix_K_fit(SEXP ySEXP, SEXP prior_inputSEXP, SEXP truth_inputSEXP, SEXP init_inputSEXP, SEXP BSEXP, SEXP burnSEXP, SEXP thinSEXP, SEXP compute_loglike_everySEXP, SEXP print_freqSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const std::vector<arma::mat>& >::type y(ySEXP);
    Rcpp::traits::input_parameter< Nullable<List> >::type prior_input(prior_inputSEXP);
    Rcpp::traits::input_parameter< Nullable<List> >::type truth_input(truth_inputSEXP);
    Rcpp::traits::input_parameter< Nullable<List> >::type init_input(init_inputSEXP);
    Rcpp::traits::input_parameter< int >::type B(BSEXP);
    Rcpp::traits::input_parameter< int >::type burn(burnSEXP);
    Rcpp::traits::input_parameter< int >::type thin(thinSEXP);
    Rcpp::traits::input_parameter< int >::type compute_loglike_every(compute_loglike_everySEXP);
    Rcpp::traits::input_parameter< int >::type print_freq(print_freqSEXP);
    rcpp_result_gen = Rcpp::wrap(cytof_fix_K_fit(y, prior_input, truth_input, init_input, B, burn, thin, compute_loglike_every, print_freq));
    return rcpp_result_gen;
END_RCPP
}
// unit_tests
void unit_tests();
RcppExport SEXP _cytof2_unit_tests() {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    unit_tests();
    return R_NilValue;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_cytof2_missing_R", (DL_FUNC) &_cytof2_missing_R, 4},
    {"_cytof2_cytof_fix_K_fit", (DL_FUNC) &_cytof2_cytof_fix_K_fit, 9},
    {"_cytof2_unit_tests", (DL_FUNC) &_cytof2_unit_tests, 0},
    {NULL, NULL, 0}
};

RcppExport void R_init_cytof2(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
