#include<Rcpp.h> // linear algebra
#include<omp.h>
// [[Rcpp::plugins(openmp)]]

//[[Rcpp::export]]
double sumPar(Rcpp::NumericVector x) {
  double out=0;
#pragma omp parallel for
  for (int i=0; i<x.size(); i++) {
    out += x[i];
  }

  return out;
}
