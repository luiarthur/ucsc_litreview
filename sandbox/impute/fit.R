source("mcmc.R")
default.prior = list(cs_b=c(1,1), m0=0, s2=10, a_sig=2, b_sig=1, cs_y=1)

fit = function(y, prior=default.prior,
               init=list(b=c(0,-2), mu=0, sig2=1, y=ifelse(is.na(y), 0, y)),
               B=2000,burn=2000, print_every=100) {

  N = length(y)
  missing = is.na(y)

  update_mu = function(state) {
    denom = state$sig2 + N*prior$s2
    m_new = (state$sig2 * prior$m0 + prior$s2 * sum(state$y)) / denom
    v_new = state$sig2 * prior$s2 / denom
    state$mu = rnorm(1, m_new, sqrt(v_new))
    state
  }

  update_sig2 = function(state) {
    a_new = prior$a_sig + N / 2
    b_new = prior$b_sig + sum((state$y - state$mu) ^ 2) / 2
    state$sig2 = 1 / rgamma(1, a_new, b_new)
    state
  }

  update_y = function(state) {
    yy = state$y
    for (i in 1:N) {
      if(missing[i]) {
        lp = function(yi) {
          dnorm(yi, state$mu, state$sig2, log=TRUE)
        }

        ll = function(yi) {
          p = sigmoid(state$b[1] + state$b[2] * yi)
          log(p)
        }

        yy[i] = mh(yy[i], ll, lp, prior$cs_y)
      }
    }
    state$y = yy
    state
  }

  update_b = function(state) {
    lp = function(b) 0
    ll = function(b) {
      p = sigmoid(b[1] + b[2] * state$y) * .99
      sum(missing * log(p) + (1-missing) * log(1-p))
    }
    state$b = mh_mv(state$b, ll, lp, prior$cs_b)
    state
  }
  
  update = function(state) {
    state = update_y(state)
    state = update_mu(state)
    state = update_sig2(state)
    state = update_b(state)
    state
  }

  gibbs(init, update, B, burn, print_every)
}
