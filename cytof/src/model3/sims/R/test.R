library(rcommon)
library(cytof3)

#saveRDS(y, '../data/cytof_cb.rds')
y_orig = readRDS('../data/cytof_cb.rds')
y = resample(y_orig, prop=.01)
#y = y_orig

### Missing Mechanism params ###
mmp = miss_mech_params(y=c(-4, -2.5, -1.0), p=c(.1, .99, .01))

### TODO: add def for miss-mech in gen_default prior ###
prior = gen_default_prior(y, K=10, L0=10, L1=10)
prior$c0 = mmp['c0']
prior$c1 = mmp['c1']
prior$m_beta0 = mmp['b0']; prior$s2_beta0 = 1
#prior$cs_beta0 = 1
#prior$cs_beta1 = 1
b1_ab = gamma_params(mmp['b1'], .01)
prior$a_beta1 = b1_ab[1]; prior$b_beta1 = b1_ab[2]
yy = seq(-7,3,l=50)
bb = sample_from_miss_mech_prior(yy, prior$m_beta0, prior$s2_beta0, prior$a_beta1,
                                 prior$b_beta1, prior$c0, prior$c1)
plot(yy,bb[,1], type='n'); abline(v=0)
for (i in 1:NCOL(bb)) lines(yy, bb[,i], col='grey')

set.seed(1)
init0 = gen_default_init(prior)
set.seed(1)
init = gen_default_init(prior)
init$mus_0 = seq(-5,-.5, l=prior$L0)
init$mus_1 = seq(.5, 5, l=prior$L1)
locked = gen_default_locked(init)
locked$beta_1 = TRUE
#locked$mus_0 = TRUE
#locked$mus_1 = TRUE
#for (n in names(locked)) locked[n] = TRUE
#locked$mus_0 = F
#locked$mus_1 = F

system.time(
  out <- fit_cytof_cpp(y, B=200, burn=100, prior=prior, locked=locked, init=init, print_freq=1, show_timings=FALSE)
)

### Expensive order: H, lam, v, gam, y, beta, mus, sig2, eta, W, alpha, s.

out[[3]]$beta_0
out[[3]]$beta_1
out[[100]]$v
out[[100]]$H
out[[100]]$mus_0
out[[100]]$lam
out[[100]]$W


beta_0 = t(sapply(out, function(o) o$beta_0))
beta_1 = t(sapply(out, function(o) o$beta_1))

#plotPosts(beta_0)
#plotPosts(beta_1)

alpha = sapply(out, function(o) o$alpha)
mus_0 = sapply(out, function(o) o$mus_0)
mus_1 = sapply(out, function(o) o$mus_1)
plotPost(alpha)

mus = rbind(mus_0, mus_1)
ci_mus = apply(mus, 1, quantile, c(.025,.975))
plot(rowMeans(mus), col=rgb(0,0,1,.5), pch=20, cex=1.5, ylim=range(ci_mus))
abline(h=0, lty=2, col='grey')
add.errbar(t(ci_mus), col='grey')

sig2_0 = sapply(out, function(o) o$sig2_0)
plot(rowMeans(sig2_0))

N = prior$N
K = prior$K
lam_init = lapply(N, function(Ni) sample(0:(K-1), Ni, replace=TRUE))

my.image(t(out[[100]]$Z)[out[[100]]$W[1,]>.1,])

out[[54]]$lam[[1]]


### Force a copy by doing this:
### update_missing_y
### state.missing_y[i] = state.missing_y[i] + 0
### similar for gam, lam


### post miss mech
B = length(out)
mm_post = sapply(1:B, function(b) prob_miss(yy, beta_0[b,1], beta_1[b,1], prior$c0, prior$c1))
plot(yy,bb[,1], type='n'); abline(v=0)
for (i in 1:NCOL(bb)) lines(yy, bb[,i], col='grey')
#plot(yy, mm_post[,1], type='n', ylim=0:1); abline(v=c(prior$c0, 0), col='grey')
for (i in 1:NCOL(mm_post)) lines(yy,mm_post[,i], col='blue')
#for (i in 1:100) {
#  Sys.sleep(.1)
#  plot(yy,mm_post[,i], col='red', type='l', lwd=4, main=i)
#  abline(v=c(prior$c0, 0), col='grey')
#}


my.image(y[[1]], col=blueToRed(), mn=-4, mx=4)
ord = order(out[[B]]$lam[[1]])
my.image(out[[B]]$missing_y_mean[[1]][ord,], col=blueToRed(), mn=-4,mx=4)


hist(out[[B]]$missing_y_mean[[1]][,2], freq=T, col=rgb(0,0,1,.4), border='transparent')
hist(out[[B]]$missing_y_last[[1]][,2], freq=T, col=rgb(0,1,0,.4), border='transparent', add=T)
hist(y[[1]][,2], freq=T,add=T, col=rgb(0,0,0,.3), border='transparent')
abline(v=0, lwd=3)

### PP 
i = 2; j= 8
W_est = out[[B]]$W; Z_est = out[[B]]$Z
o = out[[B]]
yij = sapply(out, function(o) {
  k = sample(1:prior$K, 1, prob=W_est[i,])
  z_jk = Z_est[j,k]
  eta_z = if (z_jk == 0) o$eta_0[i,j,] else o$eta_1[i,j,]
  mus_z = if (z_jk == 0) o$mus_0 else o$mus_1
  sig2_z = if (z_jk == 0) o$sig2_0[i,] else o$sig2_1[i,]
  Lz = length(mus_z)
  l = sample(1:Lz, 1, prob=eta_z)
  rnorm(1, mus_z[l], sqrt(sig2_z[l]))
})
hist(out[[B]]$missing_y_mean[[i]][,j], prob=TRUE, col=rgb(0,0,1,.4), border='transparent')
hist(yij, add=TRUE, prob=TRUE, col=rgb(0,0,0,.4), border='transparent')
