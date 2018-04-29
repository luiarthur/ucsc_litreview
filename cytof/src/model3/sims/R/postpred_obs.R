library(cytof3)
load('checkpoint.rda')

B = length(out)
gam = as.list(1:B)

locked$beta_0=TRUE
locked$beta_1=TRUE
locked$mus_0=TRUE
locked$mus_1=TRUE
locked$sig2_0=TRUE
locked$sig2_1=TRUE
locked$s=TRUE
locked$eta_0=TRUE
locked$eta_1=TRUE
locked$Z=TRUE
locked$lam=TRUE
locked$W=TRUE

for (b in 1:B) {
  print(b)
  init1 = out[[b]]
  if (b == 1) {
    init1 = init
  } else {
    init1$gam = new_out$gam
    init1$missing_y = new_out$missing_y
  }
  new_out = fit_cytof_cpp(y, B=1, burn=1, prior=prior, locked=locked,
                          init=init1, print_freq=0, normalize_loglike=TRUE,
                          save_gam=TRUE)[[1]]
  gam[[b]] = new_out$gam
}

mean(gam[[2]][[2]] - gam[[200]][[2]])
