#include "mcmc.h"

#include "Data.h"
#include "State.h"
#include "Prior.h"

#include "mus.h"   // 5.1
#include "psi.h"   // 5.2
#include "tau2.h"  // 5.3
#include "pi.h"    // 5.4
#include "sig2.h"  // 5.5

#include "z.h"
#include "v_mus.h"     // 5.6
#include "H_mus.h"     // 5.7

#include "lam.h"   // 5.8
#include "e.h"     // 5.9
#include "w.h"     // 5.10
#include "c.h"     // 5.11
#include "d.h"     // 5.12

#include "theta.h"     // 5.13.2
#include "K_theta.h"   // 5.13.1

//[[Rcpp::export]]
List cytof_fit(List y, int B, int burn, int print_freq) {
  return List::create(Named("mus") = 1.0);
}


