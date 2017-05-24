#include "mcmc.h"
#include "Data.h"
#include "State.h"
#include "Prior.h"
#include "mus.h"

//[[Rcpp::export]]
List cytof_fit(List y) {
  return List::create(Named("mus") = 1.0);
}


