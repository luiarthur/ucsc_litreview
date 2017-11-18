// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

// magicAdd
double magicAdd(double a);
RcppExport SEXP _cytof2_magicAdd(SEXP aSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< double >::type a(aSEXP);
    rcpp_result_gen = Rcpp::wrap(magicAdd(a));
    return rcpp_result_gen;
END_RCPP
}
// coolLogit
double coolLogit(double p, double a, double b);
RcppExport SEXP _cytof2_coolLogit(SEXP pSEXP, SEXP aSEXP, SEXP bSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< double >::type p(pSEXP);
    Rcpp::traits::input_parameter< double >::type a(aSEXP);
    Rcpp::traits::input_parameter< double >::type b(bSEXP);
    rcpp_result_gen = Rcpp::wrap(coolLogit(p, a, b));
    return rcpp_result_gen;
END_RCPP
}
// coolRTrunc
double coolRTrunc(double m, double s, double lo, double hi);
RcppExport SEXP _cytof2_coolRTrunc(SEXP mSEXP, SEXP sSEXP, SEXP loSEXP, SEXP hiSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< double >::type m(mSEXP);
    Rcpp::traits::input_parameter< double >::type s(sSEXP);
    Rcpp::traits::input_parameter< double >::type lo(loSEXP);
    Rcpp::traits::input_parameter< double >::type hi(hiSEXP);
    rcpp_result_gen = Rcpp::wrap(coolRTrunc(m, s, lo, hi));
    return rcpp_result_gen;
END_RCPP
}
// dtnorm
double dtnorm(double x, double m, double s, double lo, double hi);
RcppExport SEXP _cytof2_dtnorm(SEXP xSEXP, SEXP mSEXP, SEXP sSEXP, SEXP loSEXP, SEXP hiSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< double >::type x(xSEXP);
    Rcpp::traits::input_parameter< double >::type m(mSEXP);
    Rcpp::traits::input_parameter< double >::type s(sSEXP);
    Rcpp::traits::input_parameter< double >::type lo(loSEXP);
    Rcpp::traits::input_parameter< double >::type hi(hiSEXP);
    rcpp_result_gen = Rcpp::wrap(dtnorm(x, m, s, lo, hi));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_cytof2_magicAdd", (DL_FUNC) &_cytof2_magicAdd, 1},
    {"_cytof2_coolLogit", (DL_FUNC) &_cytof2_coolLogit, 3},
    {"_cytof2_coolRTrunc", (DL_FUNC) &_cytof2_coolRTrunc, 4},
    {"_cytof2_dtnorm", (DL_FUNC) &_cytof2_dtnorm, 5},
    {NULL, NULL, 0}
};

RcppExport void R_init_cytof2(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
