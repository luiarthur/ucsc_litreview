library(rcommon)
library(cytof3)

#saveRDS(y, '../data/cytof_cb.rds')
y_orig = readRDS('../data/cytof_cb.rds')
y = resample(y_orig, prop=.01)

prior = gen_default_prior(y, K=10, L0=8, L1=8)
init0 = gen_default_init(prior)
init = gen_default_init(prior)
#init$mus_0 = seq(-3,-1, l=10)
#init$mus_1 = seq(.1, 6, l=10)
locked = gen_default_locked(init)
#for (n in names(locked)) locked[n] = TRUE
#locked$mus_0 = F
#locked$mus_1 = F

system.time(
  out <- fit_cytof_cpp(y, B=100, burn=0, prior=prior, locked=locked, init=init, print_freq=1)
)

out[[100]]$beta_0
out[[3]]$beta_1
out[[10]]$beta_0
out[[100]]$v
out[[100]]$H
out[[100]]$mus_0
out[[100]]$lam
out[[100]]$W

alpha = sapply(out, function(o) o$alpha)
mus_0 = sapply(out, function(o) o$mus_0)
mus_1 = sapply(out, function(o) o$mus_1)
plotPost(alpha)

mus = rbind(mus_0, mus_1)
ci_mus = apply(mus, 1, quantile, c(.025,.975))
plot(rowMeans(mus), col=rgb(0,0,1,.5), pch=20, cex=1.5, ylim=range(ci_mus))
abline(h=0, lty=2, col='grey')
add.errbar(t(ci_mus), col='grey')

N = prior$N
K = prior$K
lam_init = lapply(N, function(Ni) sample(0:(K-1), Ni, replace=TRUE))

my.image(t(out[[100]]$Z))

out[[54]]$lam[[1]]


### Force a copy by doing this:
### update_missing_y
### state.missing_y[i] = state.missing_y[i] + 0
### similar for gam, lam
