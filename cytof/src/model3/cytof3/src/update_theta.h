#ifndef UPDATE_THETA_H
#define UPDATE_THETA_H

#include "mcmc.h"

#include "Data.h"
#include "Prior.h"
#include "State.h"
#include "Locked.h"

#include "update_beta.h" // metropolis
#include "update_missing_y.h" // metropolis
#include "update_mus.h" // gibbs
#include "update_sig2.h" // gibbs
#include "update_s.h" // gibbs
#include "update_gam.h" // gibbs
#include "update_eta.h" // gibbs
#include "update_v.h" // metropolis
#include "update_alpha.h" // gibbs
#include "update_H.h" // metropolis
#include "update_Z.h" // deterministic
#include "update_lam.h" // gibbs
#include "update_W.h" // gibbs

#include "my_timer.h" // TIME_CODE

void update_theta(State &state, const Data &data, const Prior &prior, const Locked &locked, bool show_timings=false, int thin_some=1) {
  INIT_TIMER;
  if (show_timings) Rcout << std::endl;

  // metropolis
  TIME_CODE(show_timings, "beta", update_beta(state, data, prior, locked));
  TIME_CODE(show_timings, "y", update_missing_y(state, data, prior, locked));

  // gibbs
  TIME_CODE(show_timings, "mus", update_mus(state, data, prior, locked));
  TIME_CODE(show_timings, "sig2", update_sig2(state, data, prior, locked));
  TIME_CODE(show_timings, "s",   update_s(state, data, prior, locked));

  // metropolis
  TIME_CODE(show_timings, "v", update_v(state, data, prior, locked));
  TIME_CODE(show_timings, "H", update_H(state, data, prior, locked));
  TIME_CODE(show_timings, "Z", update_Z(state, data, prior, locked));

  // gibbs
  TIME_CODE(show_timings, "alpha", update_alpha(state, data, prior, locked));
  TIME_CODE(show_timings, "lam", update_lam(state, data, prior, locked));
  TIME_CODE(show_timings, "gam", update_gam(state, data, prior, locked));
  TIME_CODE(show_timings, "eta", update_eta(state, data, prior, locked));
  TIME_CODE(show_timings, "W", update_W(state, data, prior, locked));
}

#endif
