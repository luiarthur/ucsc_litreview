library(rcommon)
library(cytof3)
set.seed(42)

### GLOBALS ###
args = commandArgs(trailingOnly=TRUE)
OUTDIR   = ifelse(length(args) < 1, '../out/cb_randBeta_K20/', args[1]) %+% '/'
PROP     = ifelse(length(args) < 2,    1, as.numeric(args[2]))
B        = ifelse(length(args) < 3, 2000, as.numeric(args[3]))
burn     = ifelse(length(args) < 4, 1000, as.numeric(args[4]))
K_MCMC   = ifelse(length(args) < 5,   20, as.numeric(args[5]))
L0       = ifelse(length(args) < 6,    5, as.numeric(args[6]))
L1       = ifelse(length(args) < 7,    5, as.numeric(args[7]))
println("L0: ", L0)
println("L1: ", L1)
### END OF GLOBALS ###

system(paste0('mkdir -p ', OUTDIR))
system(paste0('cp cb.R ', OUTDIR))
dat_lim=c(-8,8)

fileDest = function(filename) paste0(OUTDIR, filename)

#saveRDS(y, '../data/cytof_cb.rds')
y_orig = readRDS('../data/cytof_cb.rds')
set.seed(42)
y = if (0 < PROP && PROP < 1) resample(y_orig, prop=PROP) else y_orig
missing_prop = round(get_missing_prop(y),4)
sink(fileDest('missing_prop.txt'))
print(missing_prop)
print(sapply(y, NROW))
sink()
#y = preimpute(y_orig, .01)
#y = y_orig

### TODO: add def for miss-mech in gen_default prior ###
prior = gen_default_prior(y, K=K_MCMC, L0=L0, L1=L1)
I = prior$I
N = prior$N
J = prior$J

png(fileDest('Y%03d.png'))
for (i in 1:I) {
  my.image(y[[i]], col=blueToRed(), addL=TRUE, zlim=dat_lim, na.color='black')
}
dev.off()

#prior$cs_v = .01 # I think this should be better
#prior$cs_h = 1 # I think this should be better
# 1,1 -> great changes
prior$cs_v = .01
prior$cs_h = 1

sig2_ab = invgamma_params(m=.2, sig=.05) # Inv-Gamma(mean=.2, sig=.05) is great.
#sig2_ab = invgamma_params(m=.05, sig=.05)
prior$a_sig = sig2_ab[1]
s_ab = gamma_params(m=sig2_ab[2], v=1)
prior$a_s=s_ab[1]; prior$b_s=s_ab[2]

sig2_prior_samps = rinvgamma(1000, sig2_ab[1], sig2_ab[2])
#hist(sig2_prior_samps)
prior$sig2_max = qinvgamma(.99, sig2_ab[1], sig2_ab[2])
println("sig2_max: ", prior$sig2_max)

### Missing Mechanism Prior ###

# Missing Mechanism params
#mmp = miss_mech_params(y=c(-6, -2.5, -1.0), p=c(.1, .99, .01))
Y = c(Reduce(rbind, y))
Y = Y[which(!is.na(Y))]
Y_neg = Y[which(Y<0)]
Y_pos = Y[which(Y>0)]
yq = quantile(Y_neg, c(.05, .15))
mmp = miss_mech_params(y=as.numeric(yq), p=c(.01, .0001))

prior$m_beta0 = mmp['b0']; prior$s2_beta0 = 1
prior$m_beta1 = mmp['b1']; prior$s2_beta1 = .001
prior$cs_beta0 = 1 # needs to be big enough to escape local mode
prior$cs_beta1 = 1 # needs to be big enough to escape local mode

yy = seq(yq[1]-1,3,l=100)
mm_prior = sample_from_miss_mech_prior(yy, prior$m_beta0, prior$s2_beta0, 
                                       prior$m_beta1, prior$s2_beta1, 
                                       B=50)
pdf(fileDest('miss_mech_prior.pdf'))
plot(yy, mm_prior[,1], type='n', ylim=0:1, fg='grey', cex.axis=1.5,
     xlab='y', ylab='Pr(y missing)', cex.lab=1.4)
abline(v=0, lty=2)
for (i in 1:NCOL(mm_prior)) lines(yy, mm_prior[,i], col='grey30')
dev.off()

set.seed(1)
init0 = gen_default_init(prior)
set.seed(1)
init = gen_default_init(prior)
init$mus_0 = quantile(Y_neg, prob=seq(0,1,l=prior$L0))
init$mus_1 = quantile(Y_pos, prob=seq(0,1,l=prior$L1))
println("init$mus_0: ", init$mus_0)
println("init$mus_1: ", init$mus_1)
init$sig2_0 = matrix(mean(sig2_prior_samps), prior$I, prior$L0)
init$sig2_1 = matrix(mean(sig2_prior_samps), prior$I, prior$L1)
#init$Z = matrix(1, prior$J, prior$K)
#init$H = matrix(-2, prior$J, prior$K)
init$H = matrix(rnorm(prior$J*prior$K, 0, 2), prior$J, prior$K)
init$Z = compute_Z(H=init$H, v=init$v, G=prior$G)
init$missing_y = y
for (i in 1:prior$I) {
  miss_idx = which(is.na(init$missing_y[[i]]))
  init$missing_y[[i]][miss_idx] = runif(length(miss_idx), yq[1], yq[3])
}

# Are these good priors?
prior$psi_0 = mean(Y_neg)
prior$psi_1 = mean(Y_pos)
prior$tau2_0 = var(Y_neg)
prior$tau2_1 = var(Y_pos)
println("psi_0: ", prior$psi_0)
println("psi_1: ", prior$psi_1)
println("tau2_0: ", prior$tau2_0)
println("tau2_1: ", prior$tau2_1)



### Fixed parameters ###
locked = gen_default_locked(init)
#locked$beta_0 = TRUE # TODO: Can I make this random? Yes.
#locked$beta_1 = TRUE # TODO: Can I make this random? No?

#locked$s = TRUE
#locked$sig2_0 = TRUE # TODO: Can I make this random?
#locked$sig2_1 = TRUE # TODO: Can I make this random?

#locked$mus_0 = TRUE  # TODO: Can I make this random?
#locked$mus_1 = TRUE  # TODO: Can I make this random?


### kmeans
#preimpute_y = preimpute(y)
#init$missing_y = preimpute_y
#Y = do.call(rbind, preimpute_y)
#Z_est_kmeans = kmeans(Y, centers=10)
#my.image(unique(Z_est_kmeans$centers > 0))

### Init Z ###
#init$Z = t((Z_est_kmeans$centers > 0) * 1)
rm(Y, Y_neg, Y_pos)
println("")

st = system.time({
  locked$beta_1 = TRUE
  out = fit_cytof_cpp(y, B=B, burn=burn, prior=prior, locked=locked,
                        init=init, print_freq=1, show_timings=FALSE,
                        normalize_loglike=TRUE, joint_update_freq=0,
                        use_repulsive=FALSE)
})
print(st)
out = shrinkOut(out)
saveRDS(out, fileDest('out.rds'))
out = unshrinkOut(out)

B = length(out)

### loglike 
ll = last(out)$ll
pdf(fileDest('ll.pdf'))
plot(ll, type='l', ylab='log-likelihood', xlab='MCMC iteration')
dev.off()

pdf(fileDest('ll_post_burn.pdf'))
plot(tail(ll, B), type='l', ylab='log-likelihood', xlab='MCMC iteration (after burn-in)')
dev.off()


### Expensive order: lam, H, v, gam, y, beta, mus, sig2, eta, W, alpha, s.

alpha = sapply(out, function(o) o$alpha)
mus_0 = sapply(out, function(o) o$mus_0)
mus_1 = sapply(out, function(o) o$mus_1)

### v ###
v = sapply(out, function(o) o$v)
ci_v = apply(v, 1, quantile, c(.025,.975))
pdf(fileDest('v.pdf'))
plotPost(v[1,])
plot(rowMeans(v), ylim=0:1)
add.errbar(t(ci_v), col='grey')
dev.off()

### H ###
H = sapply(out, function(o) c(o$H))
H_mean = matApply(lapply(out, function(o) o$H), mean)
ci_H = apply(H, 1, quantile, c(.025,.975))
pdf(fileDest('H.pdf'))
plotPost(H[1,])
plot(rowMeans(H), ylim=range(ci_H), pch=20, col='blue')
add.errbar(t(ci_H), col='grey')
my.image(t(H_mean), zlim=c(-3,3), col=blueToRed(), addL=TRUE)
dev.off()


### alpha ###
pdf(fileDest('alpha.pdf'))
plotPost(alpha)
dev.off()


### mus ###
mus = rbind(mus_0, mus_1)
#plotPosts(t(mus[1:4,]))
pdf(fileDest('mus.pdf'))
plot_mus(out)
dev.off()

pdf(fileDest('sig2.pdf'))
### sig2_1 ###
sig2_1 = sapply(out, function(o) o$sig2_1)
ci_sig2_1 = apply(sig2_1, 1, quantile, c(.025,.975))
plot(rowMeans(sig2_1), col=rgb(0,0,1,.5), pch=20, cex=1.5, ylim=range(ci_sig2_1))
abline(h=0, lty=2, col='grey')
add.errbar(t(ci_sig2_1), col='grey')

### sig2_0 ###
sig2_0 = sapply(out, function(o) o$sig2_0)
ci_sig2_0 = apply(sig2_0, 1, quantile, c(.025,.975))
plot(rowMeans(sig2_0), col=rgb(0,0,1,.5), pch=20, cex=1.5, ylim=range(ci_sig2_0))
abline(h=0, lty=2, col='grey')
add.errbar(t(ci_sig2_0), col='grey')

dev.off()

### mus vs sig2 ###
pdf(fileDest('mus_vs_sig2.pdf'))
### sig2_1i ###
sig2_1i = sapply(out, function(o) o$sig2_1[1,])
plot(rowMeans(sig2_1i), rowMeans(mus_1), pch=as.character(1:prior$L1),
     main=paste0('Red: i=1, Green: i=2, Blue: i=3'),
     type='n', xlim=range(sig2_1), ylim=range(mus_1))
for (i in 1:I) {
  sig2_1i = sapply(out, function(o) o$sig2_1[i,])
  points(rowMeans(sig2_1i), rowMeans(mus_1), pch=as.character(1:last(out)$prior$L1),
         main=paste0('i=',i), col=i+1)
}

### sig2_0i ###
sig2_0i = sapply(out, function(o) o$sig2_0[1,])
plot(rowMeans(sig2_0i), rowMeans(mus_0), pch=as.character(1:prior$L0),
     main=paste0('Red: i=1, Green: i=2, Blue: i=3'),
     type='n', xlim=range(sig2_0), ylim=range(mus_0))
for (i in 1:I) {
  sig2_0i = sapply(out, function(o) o$sig2_0[i,])
  points(rowMeans(sig2_0i), rowMeans(mus_0), pch=as.character(1:last(out)$prior$L0),
       main=paste0('i=',i), col=i+1)
}

dev.off()

pdf(fileDest('s.pdf'))
s = sapply(out, function(o) o$s)
ci_s = apply(s, 1, quantile, c(.025,.975))
plot(rowMeans(s), col=rgb(0,0,1,.5), pch=20, cex=1.5, ylim=range(ci_s))
abline(h=0, lty=2, col='grey')
add.errbar(t(ci_s), col='grey')
dev.off()

N = prior$N
K = prior$K

### Z ###
#my.image(t(out[[B]]$Z)[out[[B]]$W[1,]>.1,])
#table(out[[B]]$lam[[1]])
idx_best = sapply(1:I, function(i) estimate_ZWi_index(out,i))
pdf(fileDest('Z_best_new.pdf'))
par(mar=c(5.1, 4, 2.1, 4))
for (i in 1:I) {
  Zi = out[[idx_best[i]]]$Z
  Wi = out[[idx_best[i]]]$W[i,]
  K = prior$K
  my.image(t(Zi), main=paste0('best Z_',i), ylab='cell-types', xlab='markers')
  axis(4, at=1:K, labels=paste0(round(Wi,3)*100,'%'), las=2, cex.axis=.8)
}
par(mar=c(5,4,4,2)+.1)
dev.off()

Zs = lapply(out, function(o) o$Z)
idx_best_old = estimate_Z_old(Zs, returnIndex=TRUE)
pdf(fileDest('Z_best_old.pdf'))
par(mar=c(5.1, 4, 2.1, 4))
for (i in 1:I) {
  Z_best = Zs[[idx_best_old]]
  Wi = out[[idx_best_old]]$W[i,]
  K = prior$K
  my.image(t(Zi), main=paste0('best Z_',i), ylab='cell-types', xlab='markers')
  axis(4, at=1:K, labels=paste0(round(Wi,3)*100,'%'), las=2, cex.axis=.8)
}
par(mar=c(5,4,4,2)+.1)
dev.off()



### Force a copy by doing this:
### update_missing_y
### state.missing_y[i] = state.missing_y[i] + 0
### similar for gam, lam


### post miss mech
beta_0 = t(sapply(out, function(o) o$beta_0))
beta_1 = t(sapply(out, function(o) o$beta_1)) 
#plotPosts(beta_0)
#plotPosts(beta_1)

pdf(fileDest('miss_mech_posterior.pdf'))
### Prior missing mechanism ###
mm_prior_mean = rowMeans(mm_prior)
mm_prior_ci = apply(mm_prior, 1, quantile, c(.025,.975))
plot(yy, mm_prior_mean, ylim=0:1, type='l', bty='n', fg='grey', xlab='y',
     col='grey30', cex.lab=1.4, cex.axis=1.5, ylab='Pr(y missing)')
color.btwn(yy, mm_prior_ci[1,], mm_prior_ci[2,], from=-10, to=10, col=rgb(0,0,0,.2))

for (i in 1:prior$I) {
  mm_post = sapply(1:B, function(b) prob_miss(yy, beta_0[b,i], beta_1[b,i]))

  mm_post_mean = rowMeans(mm_post)
  mm_post_ci = apply(mm_post, 1, quantile, c(.025,.975))

  lines(yy, mm_post_mean, ylim=0:1, type='l', bty='n', fg='grey', xlab='y',
       col=i+1, cex.lab=1.4, cex.axis=1.5, ylab='Pr(y missing)')
  color.btwn(yy, mm_post_ci[1,], mm_post_ci[2,], from=-10, to=10, col=rgba(i+1,.4))
}


abline(v=0, lty=2)
#for (i in 1:NCOL(bb)) lines(yy, bb[,i], col='grey')
#for (i in 1:NCOL(mm_post)) lines(yy,mm_post[,i], col='blue')
dev.off()


### PP 
#compute_zjk_mean= function(out, i, j) {
#  B = length(out)
#  zjk = sapply(out, function(o) {
#    k = sample(1:prior$K, 1, prob=o$W[i,])
#    o$Z[j,k]
#  })
#  mean(zjk)
#}


### Y aggregate last ###
Y_last = do.call(rbind, out[[B]]$missing_y)

pdf(fileDest('y_hist.pdf'))
par(mfrow=c(4,2))
for (i in 1:prior$I) for (j in 1:prior$J) {
  zjk_mean = compute_zjk_mean(out, i, j)
  yij = postpred_yij(out, i, j)

  den_mean = density(last(out)$missing_y_mean[[i]][,j])
  den_pp = density(yij)
  den_one_samp = density(last(out)$missing_y[[i]][,j])
  h = max(den_mean$y, den_pp$y, den_one_samp$y)

  plot_dat(out[[B]]$missing_y_mean, i, j, xlim=dat_lim, lwd=1, col='red',
           ylim = c(0, h),
           main=paste0('i: ', i,', j: ', j, ' (Z_ij mean: ', round(zjk_mean,4), ')'))

  lines(den_one_samp, col='grey')
  lines(den_pp, col='darkgrey', lwd=2)

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

#fy = function(lami) {
#  abline(h=cumsum(table(lami))+.5, lwd=1, col='white', lty=2)
#  axis(4, at=cumsum(table(lami))+.5, col=NA, col.ticks=1, cex.axis=.0001)
#}
#source('../../cytof3/R/myimage.R')
#source('../../cytof3/R/yZ.R')
#source('../../cytof3/R/yZ_inspect.R')
mult=1; png(fileDest('YZ%03d.png'), height=600*mult, width=500*mult)
            #type='Xlib')#, family=X11Fonts()$Arial)
for (i in 1:I) {
  #yZ_inspect(out, y, zlim=dat_lim, i=i, thresh=.9, fy=fy)
  yZ_inspect(out, y, zlim=c(-2,2), i=i, thresh=.9, na.color='black',
             cex.z.b=1.5, cex.z.lab=1.5, cex.z.l=1.5, cex.z.r=1.5,
             cex.y.ylab=1.5, cex.y.xaxs=1.4, cex.y.yaxs=1.4, cex.y.leg=1.5,
             prop_lower_panel=.3)
}
dev.off()

### Probability of non-expression for missing y
pz0_missy = matrix(NA, I, J)
f = function(i,j,b) {
  lami = out[[b]]$lam[[i]] + 1
  lami = lami[which(is.na(y[[i]][,j]))]
  mean(out[[b]]$Z[j,lami] == 0)
}
for (i in 1:I) for (j in 1:J) {
  pz0_missy_ij = sapply(1:B, function(b) f(i,j,b))
  pz0_missy_ij_mean = mean(pz0_missy_ij)
  pz0_missy[i,j] = pz0_missy_ij_mean
}
sink(fileDest('pz0_missing_y.txt'))
print(round(t(pz0_missy),2))
sink()

### Density of positive data and posterior predictive ###
pdf(fileDest('pp_obs.pdf'))
par(mfrow=c(4,2))
for (i in 1:I) for (j in 1:J) {
  yij = postpred_yij_obs(out, i, j)

  pp_den = density(yij)
  dat_den = density(y[[i]][which(!is.na(y[[i]][,j])) ,j])
  h = max(pp_den$y, dat_den$y)

  xmag = 7
  plot(dat_den, bty='n', col='grey', lwd=2, ylim=c(0,h*1.5), fg='grey',
       main=paste0('Observed y: i=',i,', j=',j), xlim=c(-xmag,xmag) * 1.2)
  lines(pp_den, col='blue', lwd=2)

  msg = paste0('P(Z=0) for missing y: ', round(pz0_missy[i,j],2))
  x_pos = xmag * .6
  y_pos = h * 1.3
  text(x_pos, y_pos, msg)
}
par(mfrow=c(1,1))
dev.off()

### Q hist (Histogram of P(Z=0) for missing y) ###
pdf(fileDest('pz0_missy.pdf'))
hist(pz0_missy, main='', xlim=0:1,
     xlab='Histogram: Posterior Probability of Z=0 for missing y',
     col='grey', border='white', prob=FALSE)
dev.off()
