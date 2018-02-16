source("hmc.R")
source("../impute/mcmc.R")

gen.default.init = function(X) {
  K = NCOL(X)
  list(b=double(K), sig2=1)
}

gen.default.prior = function(X) {
  K = NCOL(X)
  list(a=2, b=1, cs=rep(1,K), L=35)
}

fit = function(y, X, init=gen.default.init(X), prior=gen.default.prior(X),
               add_intercept=TRUE, B=100, burn=0, print_every=0) {

  N = NROW(X)

  update_b = function(state) {
    lp = function(b) 0
    ll = function(b) sum(dnorm(y, X%*%b, state$sig2, log=TRUE))
    #state$b = mh_mv(state$b, ll, lp, prior$cs)

    U = function(b) lp(b) + ll(b)
    grad_U = function(b) colSums(c(X%*%b-y) * X) / state$sig2
    state$b = hmc(U, grad_U, eps=prior$cs, L=prior$L, state$b)

    state
  }

  update_sig2 = function(state) {
    a_new = prior$a + N / 2
    b_new = prior$b + sum((y - X%*%state$b) ^ 2) / 2
    state$sig2 = 1 / rgamma(1, a_new, b_new)
    state
  }

  update = function(state) {
    state = update_b(state)
    state = update_sig2(state)
    state
  }

  gibbs(init, update, B, burn, print_every)
}
