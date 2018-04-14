library(rcommon)
library(cytof3)

source("plot_mus.R")

#saveRDS(y, '../data/cytof_cb.rds')
y_orig = readRDS('../data/cytof_cb.rds')
y = resample(y_orig, prop=.01)
#y = y_orig

### Missing Mechanism params ###
mmp = miss_mech_params(y=c(-4, -2.5, -1.0), p=c(.1, .99, .01))

### TODO: add def for miss-mech in gen_default prior ###
prior = gen_default_prior(y, K=10, L0=11, L1=12)
prior$c0 = mmp['c0']
prior$c1 = mmp['c1']
prior$m_beta0 = mmp['b0']; prior$s2_beta0 = 1
prior$cs_beta0 = .1
prior$cs_beta1 = .1

# Are these good priors?
prior$psi_0 = -2
prior$psi_1 = 2
prior$tau2_0 = .5^2
prior$tau2_1 = 1
prior$cs_v = .1 # I think this should be better
prior$cs_h = .1 # I think this should be better
prior$a_sig=3; prior$a_s=.4; prior$b_s=2

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
init$mus_0 = seq(-5,-1, l=prior$L0)
init$mus_1 = seq(1, 5, l=prior$L1)
init$sig2_0 = matrix(.25, prior$I, prior$L0) # TODO: Did this work?
init$sig2_1 = matrix(.25, prior$I, prior$L1) # TODO: Did this work?
init$Z = matrix(1, prior$J, prior$K)
init$H = matrix(-2, prior$J, prior$K)
locked = gen_default_locked(init)
locked$beta_0 = TRUE # TODO: Can I make this random?
locked$beta_1 = TRUE # TODO: Can I make this random?
#locked$sig2_0 = TRUE # TODO: Can I make this random?
#locked$sig2_1 = TRUE # TODO: Can I make this random?

#locked$mus_0 = TRUE  # TODO: Can I make this random?
#locked$mus_1 = TRUE  # TODO: Can I make this random?

### kmeans
preimpute_y = preimpute(y)
init$missing_y = preimpute_y
Y = do.call(rbind, preimpute_y)
Z_est_kmeans = kmeans(Y, centers=10)
my.image(unique(Z_est_kmeans$centers > 0))

system.time(
  out <- fit_cytof_cpp(y, B=200, burn=100, prior=prior, locked=locked, init=init, print_freq=1, show_timings=FALSE, normalize_loglike=TRUE, joint_update_freq=0)
)

B = length(out)

### loglike 
ll = sapply(out, function(o) o$ll)
plot(ll, type='l')

### Expensive order: H, lam, v, gam, y, beta, mus, sig2, eta, W, alpha, s.

beta_0 = t(sapply(out, function(o) o$beta_0))
beta_1 = t(sapply(out, function(o) o$beta_1))

#plotPosts(beta_0)
#plotPosts(beta_1)

alpha = sapply(out, function(o) o$alpha)
mus_0 = sapply(out, function(o) o$mus_0)
mus_1 = sapply(out, function(o) o$mus_1)
v = sapply(out, function(o) o$v)
plot(rowMeans(v))

plotPost(alpha)


mus = rbind(mus_0, mus_1)
#plotPosts(t(mus[1:4,]))
plot_mus(out)

sig2_0 = sapply(out, function(o) o$sig2_0)
ci_sig2_0 = apply(sig2_0, 1, quantile, c(.025,.975))
plot(rowMeans(sig2_0), col=rgb(0,0,1,.5), pch=20, cex=1.5, ylim=range(ci_sig2_0))
abline(h=0, lty=2, col='grey')
add.errbar(t(ci_sig2_0), col='grey')

s = sapply(out, function(o) o$s)
ci_s = apply(s, 1, quantile, c(.025,.975))
plot(rowMeans(s), col=rgb(0,0,1,.5), pch=20, cex=1.5, ylim=range(ci_s))
abline(h=0, lty=2, col='grey')
add.errbar(t(ci_s), col='grey')

N = prior$N
K = prior$K

### Z ###
my.image(t(out[[B]]$Z)[out[[B]]$W[1,]>.1,])

table(out[[B]]$lam[[1]])


### Force a copy by doing this:
### update_missing_y
### state.missing_y[i] = state.missing_y[i] + 0
### similar for gam, lam


### post miss mech
#plotPosts(beta_0)
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

### Check missing values mean. Should be < 0.
missing_y_mean = out[[B]]$missing_y_mean[[1]]
idx_miss = which(is.na(y[[1]]), arr.ind=TRUE)
missing_y_mean[idx_miss]
#y[[1]][idx_miss]


### PP 
W_est = out[[B]]$W; Z_est = out[[B]]$Z

i = 1; j= 7
hist(out[[B]]$missing_y_mean[[i]][,j], freq=T, col=rgb(0,0,1,.4), border='transparent', nclass=20)
hist(out[[B]]$missing_y[[i]][,j], freq=T, col=rgb(0,1,0,.4), border='transparent', add=T, nc=20)
hist(y[[i]][,j], freq=T,add=T, col=rgb(0,0,0,.3), border='transparent', nc=20)
abline(v=0, lwd=3)


i=1
#for (j in 1:prior$J) {
o = out[[B]]
yij = sapply(out, function(o) {
  k = sample(1:prior$K, 1, prob=W_est[i,])
  #k = sample(1:prior$K, 1000, prob=W_est[i,], replace=TRUE)
  z_jk = Z_est[j,k]
  #mean(z_jk)
  eta_z = if (z_jk == 0) o$eta_0[i,j,] else o$eta_1[i,j,]
  mus_z = if (z_jk == 0) o$mus_0 else o$mus_1
  sig2_z = if (z_jk == 0) o$sig2_0[i,] else o$sig2_1[i,]
  Lz = length(mus_z)
  l = sample(1:Lz, 1, prob=eta_z)
  rnorm(1, mus_z[l], sqrt(sig2_z[l]))
})
hist(out[[B]]$missing_y[[i]][,j], prob=TRUE, col=rgb(0,0,1,.4), border='transparent', xlim=c(-8,8), nclass=20, main=paste('i: ', i,', j: ', j))
hist(yij, add=TRUE, prob=TRUE, col=rgb(0,0,0,.5), border='transparent', nclass=20)
abline(v=rowMeans(mus), lty=2, col='grey'); abline(v=0, lwd=2)
#Sys.sleep(1)
#}

for (b in 1:B) {
  my.image(t(out[[b]]$Z), main=b)
  Sys.sleep(.1)
}
