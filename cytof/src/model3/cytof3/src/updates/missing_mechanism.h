#ifndef MISSING_MECHANISM_H
#define MISSING_MECHANISM_H

#include "../mcmc.h"

//' Probability of missing
//' @export
//[[Rcpp::export]]
double pm(double y, double b0, double b1, double c0, double c1) {
  double out;
  double d = y - c0;

  if (d < 0) {
    out = b0 - b1 * pow(d, 2.0);
  } else {
    out = b0 - b1 * c1 * sqrt(d);
  }
  return out;
}

#endif
