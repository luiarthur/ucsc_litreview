#library(session)
library(rcommon)
library(cytof3)
source("getOpts.R")
set.seed(3)

### GLOBALS (SET IN R) ###
#
#
#N_degree=100
#OUTDIR = '../out/sim_locked_beta1_K20_N100/'
#NCORES=1
#B=2000
#BURN=1000
#
##########
### OR ###
##########
#
### Get Commandline Args ###
opt_parser = getOpts()
opt = parse_args(opt_parser)
### Globals ###
OUTDIR = getOrFail(paste0(opt$outdir,'/'), opt_parser)
N_degree = getOrFail(opt$N, opt_parser)
NCORES = getOrFail(opt$ncores, opt_parser)
B = getOrFail(opt$B, opt_parser)
BURN = getOrFail(opt$burn, opt_parser)
USE_REPULSIVE = getOrFail(opt$use_repulsive, opt_parser)
println("Use repulsive: ", USE_REPULSIVE)
### END OF GLOBALS ###


system(paste0('mkdir -p ', OUTDIR))
system(paste0('cp sim.R ', OUTDIR))

fileDest = function(filename) paste0(OUTDIR, filename)

dat_lim=c(-3,3)
I=3; J=32; N=c(3,2,1)*N_degree; K=10

dat = sim_dat(I=I, J=J, N=N, K=K, L0=3, L1=4, Z=genZ(J,K,.6),
              miss_mech_params(c(-7, -3, -1), c(.1, .99, .001)))
y = dat$y


pdf(fileDest('Z_true.pdf'))
my.image(t(dat$Z), xlab='markers', ylab='cell-types', xaxt='n', yaxt='n')
axis(1, at=1:J, fg='grey', las=2, cex.axis=.8)
axis(2, at=1:K, fg='grey', las=2, cex.axis=1)
abline(h=1:K+.5, v=1:J+.5, col='grey')
dev.off()

pdf(fileDest('Z_true_all.pdf'))
mar = par("mar")
par(mfrow=c(I,1), mar=c(5.1, 4.1, 2.1, 4.1)) # b,l,t,r
for (i in 1:I) {
  Wi = dat$W[i,]
  ord = order(Wi, decreasing=TRUE)
  my.image(t(dat$Z[,ord]), xlab='markers', ylab='cell-types', xaxt='n', yaxt='n',
           main=paste('Sample',i))
  axis(1, at=1:J, fg='grey', las=2, cex.axis=.8)
  axis(2, at=1:K, label=ord ,fg='grey', las=2, cex.axis=1)
  axis(4, at=1:K, paste0(round(Wi[ord]*100, 1),'%') ,fg='grey', las=2, cex.axis=1)
  abline(h=1:K+.5, v=1:J+.5, col='grey')
}
par(mfrow=c(1,1), mar=mar)
dev.off()


png(fileDest('Y%03d.png'))
for (i in 1:I) {
  my.image(y[[i]], col=blueToRed(), addL=TRUE, zlim=dat_lim, na.color='black')
}
dev.off()

png(fileDest('Ysorted%03d.png'))
for (i in 1:I) {
  my.image(y[[i]][order(dat$lam[[i]]), ], col=blueToRed(), addL=TRUE,
           zlim=dat_lim, na.color='black')
}
dev.off()

prior = gen_default_prior(y, K=12, L0=5, L1=5)

# Are these good priors?
prior$psi_0 = -2
prior$psi_1 = 2
prior$tau2_0 = .3^2
prior$tau2_1 = .3^2

#prior$cs_v = .01 # I think this should be better
#prior$cs_h = 1 # I think this should be better
# 1,1 -> great changes
prior$cs_v = 1
prior$cs_h = 1
prior$a_Z = 1/J
prior$nu = 1.0

#prior$a_sig=3; prior$a_s=.04; prior$b_s=2
# sig2 ~ IG(mean=.1, sd=.01)
sig2_ab = invgamma_params(m=.2, sig=.01)
prior$a_sig=sig2_ab[1]
s_ab = gamma_params(m=sig2_ab[2], v=1)
prior$a_s=s_ab[1]; prior$b_s=s_ab[2]
#prior$sig2_max = Inf # .8

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
pdf(fileDest('miss_mech_prior.pdf'))
plot(yy, mm_prior[,1], type='n', ylim=0:1, bty='n',
     fg='grey', xlab='y', ylab='probability of missing')
abline(v=0)
for (i in 1:NCOL(mm_prior)) lines(yy, mm_prior[,i], col=rgb(1,0,0,.3))
dev.off()

set.seed(1)
init0 = gen_default_init(prior)
set.seed(1)
init = gen_default_init(prior)
init$mus_0 = seq(-6,-.5, l=prior$L0)
init$mus_1 = seq(.5, 6,  l=prior$L1)
init$sig2_0 = matrix(.5, prior$I, prior$L0) # TODO: Did this work?
init$sig2_1 = matrix(.5, prior$I, prior$L1) # TODO: Did this work?
#init$Z = matrix(1, prior$J, prior$K)
#init$H = matrix(-2, prior$J, prior$K)
init$H = matrix(rnorm(prior$J*prior$K, 0, 2), prior$J, prior$K)
init$Z = compute_Z(H=init$H, v=init$v, G=prior$G)


### Fixed parameters ###
locked = gen_default_locked(init)
#locked$beta_0 = TRUE # TODO: Can I make this random?
#locked$beta_1 = TRUE # TODO: Can I make this random?

#locked$s = TRUE
#locked$sig2_0 = TRUE # TODO: Can I make this random?
#locked$sig2_1 = TRUE # TODO: Can I make this random?

#locked$mus_0 = TRUE  # TODO: Can I make this random?
#locked$mus_1 = TRUE  # TODO: Can I make this random?

### preimpute y for initialization
#preimpute_y = preimpute(y)
#init$missing_y = preimpute_y
init$missing_y = y
for (i in 1:I) init$missing_y[[i]][is.na(y[[i]])] = prior$c0

### Save Checkpoint###
#save(prior, init, locked, dat, file=fileDest('dat.rda'))
save.image(file=fileDest('checkpoint.rda'))

### Start MCMC ###
st = system.time(
  out <- fit_cytof_cpp(y, B=B, burn=BURN, prior=prior, locked=locked,
                       init=init, print_freq=1, show_timings=FALSE,
                       normalize_loglike=TRUE, joint_update_freq=0,
                       ncores=NCORES, print_new_line=TRUE,
                       use_repulsive=USE_REPULSIVE)
)
print(st)
#saveRDS(out, fileDest('out.rds'))
#save.session(file=fileDest('checkpoint.rda'))
save.image(file=fileDest('checkpoint.rda'))

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

### mus vs sig2 ###
pdf(fileDest('mus_vs_sig2.pdf'))
sig2_0i = sapply(out, function(o) o$sig2_0[1,])
plot(rowMeans(sig2_0i), rowMeans(mus_0), pch=as.character(1:prior$L0),
     main=paste0('Red: i=1, Green: i=2, Blue: i=3'),
     type='n', xlim=range(sig2_0), ylim=range(mus_0))
for (i in 1:I) {
  sig2_0i = sapply(out, function(o) o$sig2_0[i,])
  points(rowMeans(sig2_0i), rowMeans(mus_0), pch=as.character(1:last(out)$prior$L0),
       main=paste0('i=',i), col=i+1)
}

sig2_1i = sapply(out, function(o) o$sig2_1[1,])
plot(rowMeans(sig2_1i), rowMeans(mus_1), pch=as.character(1:prior$L1),
     main=paste0('Red: i=1, Green: i=2, Blue: i=3'),
     type='n', xlim=range(sig2_1), ylim=range(mus_1))
for (i in 1:I) {
  sig2_1i = sapply(out, function(o) o$sig2_1[i,])
  points(rowMeans(sig2_1i), rowMeans(mus_1), pch=as.character(1:last(out)$prior$L1),
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


pdf(fileDest('Z_best_byW.pdf'))
for (i in 1:I) {
  mar = par("mar")
  par(mar=c(5.1, 4.1, 4.1, 4.1))
  Zi = out[[idx_best[i]]]$Z
  Wi = out[[idx_best[i]]]$W[i,]
  ord = order(Wi, decreasing=TRUE)
  my.image(t(Zi[,ord]), xlab='markers', ylab='cell-types', xaxt='n', yaxt='n')
  axis(1, at=1:J, fg='grey', las=2, cex.axis=.8)
  axis(2, at=1:length(ord), label=ord ,fg='grey', las=2, cex.axis=1)
  axis(4, at=1:length(ord), paste0(round(Wi[ord]*100, 1),'%') ,fg='grey', las=2, cex.axis=1)
  abline(h=1:length(ord)+.5, v=1:J+.5, col='grey')
  par(mar=mar)
}
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
plot(0, 0, ylim=0:1, xlim=range(yy), type='n', ylab='Probability of missing',
     bty='n', fg='grey', xlab='density', col='blue')
for (i in 1:I) {
  mm_post = sapply(1:B, function(b) 
                   prob_miss(yy, beta_0[b,i], beta_1[b,i], prior$c0, prior$c1))
  mm_post_mean = rowMeans(mm_post)
  mm_post_ci = apply(mm_post, 1, quantile, c(.025,.975))
  lines(yy, mm_post_mean, col=i+1, lwd=2)
  color.btwn(yy, mm_post_ci[1,], mm_post_ci[2,], from=-10, to=10, col=rgb(0,0,0,.2))
}

mm_prior_mean = rowMeans(mm_prior)
mm_prior_ci = apply(mm_prior, 1, quantile, c(.01,.99))

lines(yy, mm_prior_mean, col='black')
color.btwn(yy, mm_prior_ci[1,], mm_prior_ci[2,], from=-10, to=10, col=rgb(0,0,0,.2))
abline(v=0)
#for (i in 1:NCOL(bb)) lines(yy, bb[,i], col='grey')
#for (i in 1:NCOL(mm_post)) lines(yy,mm_post[,i], col='blue')
dev.off()


### PP 
compute_zjk_mean= function(out, i, j) {
  B = length(out)
  zjk = sapply(out, function(o) {
    k = sample(1:prior$K, 1, prob=o$W[i,])
    o$Z[j,k]
  })
  mean(zjk)
}


### Y aggregate last ###
Y_last = do.call(rbind, out[[B]]$missing_y)


pdf(fileDest('y_hist.pdf'))
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

# TODO: Test this with simulation data
png(fileDest('YZ%03d.png'), height=500, width=500)
#png('YZ%03d.png', height=500, width=500)
fy = function(lami) {
  abline(h=cumsum(table(lami))+.5, lwd=3, col='yellow', lty=1)
  axis(4, at=cumsum(table(lami))+.5, col=NA, col.ticks=1, cex.axis=.0001)
}
for (i in 1:I) {
  yZ_inspect(out, y, dat_lim=dat_lim, i=i, thresh=.9, na.color='black', fy=fy)
  #yZ_inspect(out, last(out)$missing_y_mean, dat_lim=dat_lim, i=i, thresh=.9)
  #yZ_inspect_old(out, y, dat_lim=dat_lim, i=i, thresh=.05)
}
dev.off()


#my.image(last(out)$Z)
#round(last(out)$W[i,] * 100, 2)

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
thresh = -0
for (i in 1:I) for (j in 1:J) {
  yij = postpred_yij(out, i, j)
  while (length(which(yij > thresh)) < 3) {
    yij = postpred_yij(out, i, j)
  }

  pp_den = density(yij[yij > thresh])
  dat_den = density(y[[i]][which(y[[i]][,j] > thresh) ,j])
  h = max(pp_den$y, dat_den$y)

  plot(dat_den, bty='n', col='grey', lwd=2, ylim=c(0,h), fg='grey',
       main=paste0('positive y: i=',i,', j=',j), xlim=c(thresh,7*1.2))
  lines(pp_den, col='blue', lwd=2)

  msg = paste0('P(Z=0) for missing y: ', round(pz0_missy[i,j],2))
  x_pos = 7 * .8
  y_pos = h / 2
  text(x_pos, y_pos, msg)
}
par(mfrow=c(1,1))
dev.off()
