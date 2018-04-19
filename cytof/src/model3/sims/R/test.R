library(ggplot2)
library(rcommon)
library(cytof3)

source("plot_mus.R")
source("plot_dat.R")
source("postpred_yij.R")

#saveRDS(y, '../data/cytof_cb.rds')
y_orig = readRDS('../data/cytof_cb.rds')
#y = resample(y_orig, prop=.01)
y = y_orig
#y = preimpute(y_orig, .01)
#y = y_orig

### TODO: add def for miss-mech in gen_default prior ###
prior = gen_default_prior(y, K=10, L0=5, L1=5)

# Are these good priors?
prior$psi_0 = -2
prior$psi_1 = 2
prior$tau2_0 = .5^2
prior$tau2_1 = 1

#prior$cs_v = .01 # I think this should be better
#prior$cs_h = 1 # I think this should be better
# 1,1 -> great changes
prior$cs_v = 1
prior$cs_h = 1

#prior$a_sig=3; prior$a_s=.04; prior$b_s=2
# sig2 ~ IG(mean=.1, sd=.01)
sig2_ab = invgamma_params(m=.1, sig=.01)
prior$a_sig=sig2_ab[1]
s_ab = gamma_params(m=sig2_ab[2], v=1)
prior$a_s=s_ab[1]; prior$b_s=s_ab[2]

sig2_prior = 1 / rgamma(1000, prior$a_sig, rgamma(1000, prior$a_s, prior$b_s))
#hist(sig2_prior)

### Missing Mechanism Prior ###

# Missing Mechanism params
mmp = miss_mech_params(y=c(-6, -2.5, -1.0), p=c(.1, .99, .01))

prior$c0 = mmp['c0']
prior$c1 = mmp['c1']
prior$m_beta0 = mmp['b0']; prior$s2_beta0 = .001 
prior$m_beta1 = mmp['b1']; prior$s2_beta1 = .001
prior$cs_beta0 = .1
prior$cs_beta1 = .1

yy = seq(-7,3,l=100)
mm_prior = sample_from_miss_mech_prior(yy, prior$m_beta0, prior$s2_beta0, 
                                       prior$m_beta1, prior$s2_beta1, 
                                       prior$c0, prior$c1, B=1000)
pdf('../out/miss_mech_prior.pdf')
plot(yy, mm_prior[,1], type='n'); abline(v=0)
for (i in 1:NCOL(mm_prior)) lines(yy, mm_prior[,i], col='grey')
dev.off()

set.seed(1)
init0 = gen_default_init(prior)
set.seed(1)
init = gen_default_init(prior)
init$mus_0 = seq(-5,-1, l=prior$L0)
init$mus_1 = seq(0, 5, l=prior$L1)
init$sig2_0 = matrix(.5, prior$I, prior$L0) # TODO: Did this work?
init$sig2_1 = matrix(.5, prior$I, prior$L1) # TODO: Did this work?
#init$Z = matrix(1, prior$J, prior$K)
#init$H = matrix(-2, prior$J, prior$K)
init$H = matrix(rnorm(prior$J*prior$K, 0, 2), prior$J, prior$K)
init$Z = compute_Z(H=init$H, v=init$v, G=prior$G)


### Fixed parameters ###
locked = gen_default_locked(init)
#locked$beta_0 = TRUE # TODO: Can I make this random?
locked$beta_1 = TRUE # TODO: Can I make this random?

#locked$s = TRUE
#locked$sig2_0 = TRUE # TODO: Can I make this random?
#locked$sig2_1 = TRUE # TODO: Can I make this random?

#locked$mus_0 = TRUE  # TODO: Can I make this random?
#locked$mus_1 = TRUE  # TODO: Can I make this random?


### kmeans
preimpute_y = preimpute(y)
init$missing_y = preimpute_y
Y = do.call(rbind, preimpute_y)
Z_est_kmeans = kmeans(Y, centers=10)
#my.image(unique(Z_est_kmeans$centers > 0))

### Init Z ###
#init$Z = t((Z_est_kmeans$centers > 0) * 1)

st = system.time(
  out <- fit_cytof_cpp(y, B=1000, burn=2000, prior=prior, locked=locked,
                       init=init, print_freq=1, show_timings=FALSE,
                       normalize_loglike=TRUE, joint_update_freq=0, ncore=8)
  #out <- fit_cytof_cpp(y, B=50, burn=0, prior=prior, locked=locked, init=init, print_freq=1, show_timings=FALSE, normalize_loglike=TRUE, joint_update_freq=0)

  #prior$cs_v = .001
  #prior$cs_h = .001
  #out <- fit_cytof_cpp(y, B=50, burn=0, prior=prior, locked=locked, init=last(out), print_freq=1, show_timings=FALSE, normalize_loglike=TRUE, joint_update_freq=0)
)
print(st)
saveRDS(out, '../out/out.rds')

B = length(out)

### loglike 
ll = sapply(out, function(o) o$ll)
pdf('../out/ll.pdf')
plot(ll, type='l')
dev.off()

### Expensive order: lam, H, v, gam, y, beta, mus, sig2, eta, W, alpha, s.

alpha = sapply(out, function(o) o$alpha)
mus_0 = sapply(out, function(o) o$mus_0)
mus_1 = sapply(out, function(o) o$mus_1)

### v ###
v = sapply(out, function(o) o$v)
plotPost(v[1,])
plot(rowMeans(v))

### H ###
H = sapply(out, function(o) c(o$H))
H_mean = matApply(lapply(out, function(o) o$H), mean)
ci_H = apply(H, 1, quantile, c(.025,.975))
plotPost(H[1,])
plot(rowMeans(H), ylim=range(ci_H), pch=20, col='blue')
add.errbar(t(ci_H), col='grey')
my.image(t(H_mean), mn=-3, mx=3, col=blueToRed(), addL=TRUE)

### alpha ###
pdf('../out/alpha.pdf')
plotPost(alpha)
dev.off()


### mus ###
mus = rbind(mus_0, mus_1)
#plotPosts(t(mus[1:4,]))
pdf('../out/mus.pdf')
plot_mus(out)
dev.off()

pdf('../out/sig2.pdf')
### sig2_0 ###
sig2_0 = sapply(out, function(o) o$sig2_0)
ci_sig2_0 = apply(sig2_0, 1, quantile, c(.025,.975))
plot(rowMeans(sig2_0), col=rgb(0,0,1,.5), pch=20, cex=1.5, ylim=range(ci_sig2_0))
abline(h=0, lty=2, col='grey')
add.errbar(t(ci_sig2_0), col='grey')

### sig2_1 ###
sig2_1 = sapply(out, function(o) o$sig2_1)
ci_sig2_1 = apply(sig2_1, 1, quantile, c(.025,.975))
plot(rowMeans(sig2_1), col=rgb(0,0,1,.5), pch=20, cex=1.5, ylim=range(ci_sig2_1))
abline(h=0, lty=2, col='grey')
add.errbar(t(ci_sig2_1), col='grey')
dev.off()

pdf('../out/s.pdf')
s = sapply(out, function(o) o$s)
ci_s = apply(s, 1, quantile, c(.025,.975))
plot(rowMeans(s), col=rgb(0,0,1,.5), pch=20, cex=1.5, ylim=range(ci_s))
abline(h=0, lty=2, col='grey')
add.errbar(t(ci_s), col='grey')
dev.off()

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
beta_0 = t(sapply(out, function(o) o$beta_0))
beta_1 = t(sapply(out, function(o) o$beta_1)) 
#plotPosts(beta_0)
#plotPosts(beta_1)

pdf('../out/miss_mech_posterior.pdf')
mm_post = sapply(1:B, function(b) 
                 prob_miss(yy, beta_0[b,1], beta_1[b,1], prior$c0, prior$c1))

mm_post_mean = rowMeans(mm_post)
mm_post_ci = apply(mm_post, 1, quantile, c(.025,.975))

plot(yy, mm_post_mean, ylim=range(mm_post_ci), type='l',
     bty='n', fg='grey', xlab='density', col='blue')
color.btwn(yy, mm_post_ci[1,], mm_post_ci[2,], from=-10, to=10, col=rgb(0,0,1,.4))

mm_prior_mean = rowMeans(mm_prior)
mm_prior_ci = apply(mm_prior, 1, quantile, c(.025,.975))

lines(yy, mm_prior_mean, col='red')
color.btwn(yy, mm_prior_ci[1,], mm_prior_ci[2,], from=-10, to=10, col=rgb(1,0,0,.2))
abline(v=0)
#for (i in 1:NCOL(bb)) lines(yy, bb[,i], col='grey')
#for (i in 1:NCOL(mm_post)) lines(yy,mm_post[,i], col='blue')
dev.off()


### PP 
W_est = out[[B]]$W; Z_est = out[[B]]$Z

compute_zjk_mean= function(out, i, j) {
  B = length(out)
  #k = sapply(sample(1:prior$K, 1, prob=W_est[i,]))
  zjk = sapply(out, function(o) {
    k = sample(1:prior$K, 1, prob=o$W[i,])
    o$Z[j,k]
  })
  mean(zjk)
}


### Y aggregate last ###
Y_last = do.call(rbind, out[[B]]$missing_y)


source("plot_dat.R")
pdf('../out/y_hist.pdf')
par(mfrow=c(4,2))
for (i in 1:prior$I) for (j in 1:prior$J) {
  zjk_mean = compute_zjk_mean(out, i, j)
  plot_dat(out[[B]]$missing_y_mean, i, j, xlim=c(-8,8), lwd=1, col='red',
           main=paste0('i: ', i,', j: ', j, ' (Z_ij mean: ', zjk_mean, ')'))

  lines(density(out[[B]]$missing_y[[i]][,j]), col='grey')
         
  yij = postpred_yij(out, i, j)
  lines(density(yij), col='darkgrey', lwd=2)

  eta_0ij = sapply(out, function(o) o$eta_0[i,j,])
  eta_1ij = sapply(out, function(o) o$eta_1[i,j,])
  eta_ij = c(rowMeans(eta_0ij), rowMeans(eta_1ij))
  col = c(rep('blue', NROW(eta_0ij)), rep('red', NROW(eta_1ij)))
  points(rowMeans(mus), rep(0,NROW(mus)), pch=4, lwd=2, cex=eta_ij, col=col)
}
par(mfrow=c(1,1))
dev.off()

#for (b in 1:B) {
#  my.image(t(out[[b]]$Z), main=b)
#  Sys.sleep(.1)
#}

png('../out/YZ%03d.png')
y_Z_inspect(out, y, c(-2,2), i=0, thresh=.05)
dev.off()

#my.image(Z[[161]])
#my.image(Z[[77]])
#my.image(Z[[79]])


