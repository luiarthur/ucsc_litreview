source("../mcmc/mcmc.R")
default.prior = list(cs_b=c(1,1), m0=0, s2=10, a_sig=2, b_sig=1, cs_y=1)

fit = function(y, prior=default.prior,
               init=list(b=c(0,-2), mu=0, sig2=1, y=ifelse(is.na(y), 0, y)),
               B=2000,burn=2000, print_every=100) {

  N = length(y)
  missing = is.na(y)

  update_mu = function(state) {
  }

  update_sig2 = function(state) {
  }

  update_y = function(state) {
  }

  update_b = function(state) {
  }
  
  update = function(state) {
    state$y = update_y(state)
    state$mu = update_mu(state)
    state$sig2 = update_sig2(state)
    state$b = update_b(state)
    state$ll = sum(dnorm(state$y, state$mu, state$sig2, log=TRUE))
    state
  }

  gibbs(init, update, B, burn, print_every)
}
