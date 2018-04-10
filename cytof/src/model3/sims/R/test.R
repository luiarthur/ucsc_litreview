library(cytof3)

#saveRDS(y, '../data/cytof_cb.rds')
y_orig = readRDS('../data/cytof_cb.rds')
y = resample(y_orig, prop=.01)

prior = gen_default_prior(y, K=10, L0=10, L1=10)
init = gen_default_init(prior)
locked = gen_default_locked(init)
#locked$s = TRUE
#locked$gam = TRUE
#locked$eta = TRUE
#locked$Z = TRUE
#locked$lam = TRUE
#locked$W = TRUE

system.time(
  out <- fit_cytof_cpp(y, B=10, burn=0, prior=prior, locked=locked, init=init, print_freq=1)
)

