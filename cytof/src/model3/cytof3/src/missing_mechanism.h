#ifndef MISSING_MECHANISM_H
#define MISSING_MECHANISM_H

#include "mcmc.h"

// Probability of missing
double prob_miss(double y, double b0, double b1) {
  if (b1 > 0) {
    throw std::invalid_argument("b0 must be negative!");
  }
  return mcmc::sigmoid(b0 + b1 * y);
}

double f_inj(double y, int m, double b0, double b1) {
  double out = prob_miss(y, b0, b1);
  if (m == 0) {
    out = 1 - out;
  }
  return out;
}

#endif
