#ifndef MISSING_MECHANISM_H
#define MISSING_MECHANISM_H

#include "mcmc.h"

// Probability of missing
double prob_miss(double y, double b0, double b1, double c0, double c1) {
  double x;
  double d = y - c0;

  if (d < 0) {
    x = b0 - b1 * pow(d, 2.0);
  } else {
    x = b0 - b1 * c1 * sqrt(d);
  }

  return mcmc::sigmoid(x);
}

double f_inj(double y, int m, double b0, double b1, double c0, double c1) {
  double out = prob_miss(y, b0, b1, c0, c1);
  if (m == 0) {
    out = 1 - out;
  }
  return out;
}

#endif
