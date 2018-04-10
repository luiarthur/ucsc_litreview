library(cytof3)

y = readRDS('../data/cytof_cb.rds')

prior = gen_default_prior(y, K=10, L0=10, L1=10)
init = gen_default_init(prior)
locked = gen_default_locked(init)

out = fit_cytof_cpp(y, B=100, burn=200, prior=prior, locked=locked, init=init, print_freq=1)

