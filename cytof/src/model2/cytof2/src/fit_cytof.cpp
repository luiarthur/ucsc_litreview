#include <omp.h>

#include "mcmc.h"

#include "Data.h"
#include "State.h"
#include "Prior.h"
#include "loglike.h"

#include "unit_tests.h"

std::vector<List> cytof_fix_K_fit(
  const Data &y,
  int B, int burn, int thin, int compute_loglike_every, int print_freq) {

  std::vector<List> out(B);
  return out;
}
