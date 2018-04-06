#ifndef FIXED_H
#define FIXED_H

#include <Rcpp.h>

struct Fixed {
  bool beta_0 = false;
  bool beta_1 = false;
  bool missing_y = false;
  bool mus_0 = false;
  bool mus_1 = false;
  bool sig2_0 = false;
  bool sig2_1 = false;
  bool s = false;
  bool gam = false;
  bool eta_0 = false;
  bool eta_1 = false;
  bool v = false;
  bool alpha = false;
  bool H = false;
  bool lam = false;
  bool W = false;
};

#endif
