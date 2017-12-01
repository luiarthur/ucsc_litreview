library(cytof2)
library(rcommon)

set.seed(1)

#source("../cytof2/R/readExpression.R")

I = 3
J = 32
K = 4
W <- matrix(c(.3, .4, .2, .1,
              .1, .7, .1, .1,
              .2, .3, .3, .2), nrow=I, byrow=TRUE)

#bdat = get_beta(y=c(-5,-4), p_tar=c(.99,.01), plot=FALSE)

#dat <- simdat(I=I, N=c(2,3,1)*100, J=J, K=K, 
dat <- simdat(I=I, N=c(2,3,1)*1000, J=J, K=K, 
              b0=matrix(-5.7,I,J),
              b1=rep(1.7,J),
              Z=genSimpleZ(J, K),
              #Z=genZ(J, K, c(.4,.6)),
              W=W,
              psi_0=-2, psi_1=2,
              tau2_0=1, tau2_1=1,
              gams_0=matrix(1 / rgamma(I*J, 13.1,12.1), I, J),
              sig2=matrix(1/rgamma(I*J, 3,.2), ncol=J))

missing_count = sapply(dat$y, function(yi)
  apply(yi, 2, function(col) sum(is.na(col)))
)
missing_count

par(mfrow=c(4,2))
for (i in 1:I) for (j in 1:J) {
  plot_dat(dat$y, i, j, xlim=c(-5,5), ylim=c(0,1), xlab=paste0('marker ',j))
  #Sys.sleep(1)
}
par(mfrow=c(1,1))

mus0_est <- matrix(0, I, J)
mus1_est <- matrix(0, I, J)
for (i in 1:I) for (j in 1:J) mus0_est[i,j] <- mean(dat$y[[i]][dat$y[[i]][,j]<0,j], na.rm=T)
for (i in 1:I) for (j in 1:J) mus1_est[i,j] <- mean(dat$y[[i]][dat$y[[i]][,j]>0,j], na.rm=T)

plot(c(c(dat$mus_0),c(dat$mus_1)), c(c(mus0_est),c(mus1_est)),
     xlab="true mu*", ylab="empirical estimate of mu*", main='Data: mu*')
abline(0,1)

plot_simdat <- function(dat,i,j,...) {
  lin <- dat$Z[j, dat$lam[[i]]]
  hist(dat$y[[i]][lin==0,j], border='white', col=rgb(0,0,1,.5),...)
  hist(dat$y[[i]][lin==1,j], border='white', col=rgb(1,0,0,.5),add=TRUE, ...)
}

#par(mfrow=c(4,2))
#for (i in 1:I) for (j in 1:J) {
#  plot_simdat(dat, i,j, xlim=c(-5,5), xlab='bla', prob=TRUE,
#              main=paste0('Truth: Y',i,': Col',j))
#}
#par(mfrow=c(1,1))


plot.histModel2(dat$y, xlim=c(-5,5), main='Histogram of Data')
plot.histModel2(list(dat$y[[1]]), xlim=c(-5,5), main='Histogram of Data')
plot.histModel2(list(dat$y[[2]]), xlim=c(-5,5), main='Histogram of Data')
plot.histModel2(list(dat$y[[3]]), xlim=c(-5,5), main='Histogram of Data')

my.image(dat$Z, xlab='j', ylab='k', main='True Z')
for (i in 1:length(dat$y)) {
  my.image(dat$y[[i]], mn=-5, mx=5, col=blueToRed(), addLegend=TRUE,
           main=paste0('y',i), xlab='j', ylab='n')
}


mus_init <- array(0, c(I,J,2))
mus_init[,,1] <- ifelse(is.na(mus0_est), mean(mus0_est), mus0_est)
mus_init[,,2] <- ifelse(is.na(mus1_est), mean(mus1_est), mus1_est)
warmup_truth <- list(K=10, mus=mus_init)
warmup <- cytof_fix_K_fit(dat$y, truth=warmup_truth, B=300, burn=0, print=1)
ll_warmup <- sapply(warmup, function(o) o$ll); plot(ll_warmup, type='l')
my.image(last(warmup)$Z)

truth=list(K=10)
init=last(warmup)
init$missing_y <- NULL
#system.time(out <- cytof_fix_K_fit(dat$y, truth=truth, B=10, burn=0, thin=1))
system.time(out <- cytof_fix_K_fit(dat$y, truth=truth, init=init, 
                                   B=200, burn=80, thin=5))

ll <- sapply(out, function(o) o$ll)
plot(ll <- sapply(out, function(o) o$ll), type='l',
     main='log-likelihood', xlab='mcmc iteration', ylab='log-likelihood')

# Z
Z <- lapply(out, function(o) o$Z)
Z_mean <- matApply(Z, mean)
Z_sd <- matApply(Z, sd)
ord <- left_order(Z_mean>.5)

#for (i in 1:length(out)) my.image(Z[[i]][,ord], main="posterior", ylab="1:J")

my.image(Z_sd[,ord], main="Posterior SD", ylab="1:J", addL=T)
my.image(Z_mean[,ord], main="Posterior Mean", ylab="1:J", addL=T)
my.image(Z_mean[,ord]>.5, main="Posterior Mean", ylab="1:J", addL=T, rm0=TRUE)
my.image(dat$Z, main="True Z", ylab="1:J", addL=T)

# W
W <- lapply(out, function(o) o$W)
W_mean <- matApply(W, mean)
W_sd <- matApply(W, sd)
my.image(W_sd[,ord][,1:4], mn=0, mx=.1, 
         ylab="I", xlab="K", main="Posterior SD: W", addL=TRUE)
my.image(W_mean[,ord][,1:4], ylab="I", xlab="K", main="Posterior Mean: W", addL=TRUE)
my.image(dat$W, ylab="I", xlab="K", main="W: Truth", addL=TRUE)

W_mean[,ord]
dat$W

# beta

# beta_0
beta_0 = sapply(out, function(o) o$beta_0)
beta_0_mean = rowMeans(beta_0)
beta_0_ci = t(apply(beta_0, 1, quantile, c(.025,.975)))

if (length(unique(c(dat$b0))) > 1) {
  plot(dat$b0, beta_0_mean, main='b0')
  add.errbar(beta_0_ci, x=dat$b1)
  abline(0,1)
} else {
  a = sapply(c(t(missing_count) / 30), function(x) min(x,1))
  plot(beta_0_mean, main='b0', pch=20, cex=2, fg='grey', col=rgb(0,0,1,a))
  add.errbar(beta_0_ci, x=1:(I*J), lty=2, col=rgb(0,0,1,.3))
  abline(h=c(dat$b0[1],0),col='grey')
}

# betaBar_0
betaBar_0 = sapply(out, function(o) o$betaBar_0)
betaBar_0_mean <- rowMeans(betaBar_0)
betaBar_0_ci <- t(apply(betaBar_0, 1, quantile, c(.025,.975)))

# beta_1
beta_1 = sapply(out, function(o) o$beta_1)
beta_1_mean = rowMeans(beta_1)
beta_1_ci = t(apply(beta_1, 1, quantile, c(.025,.975)))
if (length(unique(dat$b1)) > 1) {
  plot(dat$b1, beta_1_mean, main='b1')
  add.errbar(beta_1_ci, x=dat$b1)
  abline(0,1)
} else {
  plot(beta_1_mean, main='b1', pch=20, col=rgb(0,0,1), cex=2, fg='grey')
  add.errbar(beta_1_ci, x=1:J, lty=2, col=rgb(0,0,1,.5))
  abline(h=dat$b1[1],col='grey')
}

# Prob of missing
ys <- seq(-12,12,l=100)
plot(ys, ys, ylim=0:1, type='n', fg='grey', xlab='y', ylab='prob of missing')
title(main='Prob of missing')
for (i in 1:I) for (j in 1:J) {
  r=135/255; g=206/255; b=250/255
  plot_beta(out, i, j, plot_line=FALSE, col.area=rgb(r,g,b,.5), y=ys)
}
for (i in 1:I) for (j in 1:J) {
  plot_beta(out, i, j, addT=TRUE, plot_area=FALSE, y=ys, col.line=j)
}

par(mfrow=c(4,2), mar=mar.ts(), oma=oma.ts())
for (j in 1:J){
  plot(ys, ys, ylim=0:1, type='n', fg='grey', xlab='y',
       xaxt='n',
       ylab=paste0('prob of missing: ', j))
  if (j %% 8 == 0 || j %% 8 == 7) { axis(1, fg='grey') }
  abline(v=c(-5,0,5), col='grey', lty=2)
  for (i in 1:I) {
    plot_beta(out, i, j, addT=TRUE, plot_a=T, y=ys, col.line=i+1, lwd=2)
  }
}
par(mfrow=c(1,1), mar=mar.default(), oma=oma.default())

# mus0
mus0 = sapply(out, function(o) c(o$mus[,,1]))
mus0_mean = rowMeans(mus0)
mus0_ci = t(apply(mus0, 1, quantile, c(.025,.975)))

# mus1
mus1 = sapply(out, function(o) c(o$mus[,,2]))
mus1_mean = rowMeans(mus1)
mus1_ci = t(apply(mus1, 1, quantile, c(.025,.975)))

#mus posterior vs dat
plot(c(c(dat$mus_0),c(dat$mus_1)), c(c(mus0_mean), c(mus1_mean)), pch=20,fg='grey',
     col='blue', main='Posterior mu*', xlab='true mu*', ylab='posterior mean: mu*')
abline(0,1, h=0, v=0, col='grey', lty=2)
add.errbar(rbind(mus0_ci, mus1_ci),
           x=c(c(dat$mus_0), c(dat$mus_1)), col=rgb(0,0,1,.2))

#mus posterior vs empirical est
plot(c(c(mus0_est),c(mus1_est)), c(c(mus0_mean), c(mus1_mean)), pch=20,fg='grey',
     col='blue', main='Posterior mu*', xlab='empirical est of mu*',
     ylab='posterior mean: mu*')
abline(0,1, h=0, v=0, col='grey', lty=2)
add.errbar(rbind(mus0_ci, mus1_ci),
           x=c(c(mus0_est), c(mus1_est)), col=rgb(0,0,1,.2))


# gams_0: TODO
gams_0 = sapply(out, function(o) o$gams_0)
gams_0_mean = rowMeans(gams_0)
gams_0_ci = t(apply(gams_0, 1, quantile, c(.025,.975)))

plot(c(dat$gams_0), c(gams_0_mean), fg='grey',
     xlab='Data: gam0*', ylab='Posterior Mean: gam0*', 
     main=expression('Posterior'~gamma[0]^'*'),
     pch=20, col='blue')
abline(0,1, col='grey')
add.errbar(gams_0_ci, x=dat$gams_0, col=rgb(0,0,1,.2))

# sig2: FIXME! has not moved
sig2 = sapply(out, function(o) o$sig2)
sig2_mean = rowMeans(sig2)
sig2_ci = t(apply(sig2, 1, quantile, c(.025,.975)))

sig2_range = range(sig2_mean, dat$sig2)
plot(c(dat$sig2), c(sig2_mean), xlim=sig2_range, ylim=sig2_range,
     pch=20, col='blue', fg='grey', xlab='truth', ylab='posterior mean',
     main=expression(sigma[ij]^2))
abline(0,1, col='grey')
add.errbar(sig2_ci, x=c(dat$sig2), col=rgb(0,0,1,.3))

# gams and sig2
dat_gs <- c(dat$sig2 * (dat$gams_0 + 1))
gs <- sapply(out, function(o) o$sig2 * (1 + o$gams_0))
gs_mean <- rowMeans(gs)
gs_ci <- t(apply(gs, 1, quantile, c(.025,.975)))

plot(c(dat_gs), rowMeans(gs), pch=20, col='blue', fg='grey',
     xlab='truth', ylab='posterior mean',
     main=expression(sigma[ij]^2~(1+gamma[0][ij])))
abline(0,1, col='grey')
add.errbar(gs_ci, x=c(dat_gs), col=rgb(0,0,1,.3))

# tau2: TODO: Overestimated
tau2 <- t(sapply(out, function(o) o$tau2))
plotPosts(tau2, cnames=paste0('tau2_',0:1,': Truth=', c(dat$tau2_0, dat$tau2_1)))

# psi: FIXME: Has not moved!
psi <- t(sapply(out, function(o) o$psi))
plotPosts(psi, cnames=paste0('psi_',0:1,': Truth=', c(dat$psi_0, dat$psi_1)))

# lam: TODO: HOW???

# missing_y
missing_y <- lapply(as.list(1:I), function(i) lapply(out, function(o) {
  matrix(o$missing_y[[i]], ncol=J)
}))

missing_y_mean <- lapply(missing_y, function(m) Reduce("+", m) / length(m))

i=3
for (i in 1:I) {
  my.image(dat$y[[i]], mn=-5, mx=5, col=blueToRed(), addLegend=TRUE,
           xlab='markers', main=paste0('Data: y',i))
  my.image(missing_y_mean[[i]], mn=-5, mx=5, col=blueToRed(), addLegend=TRUE,
           xlab='markers', main=paste0('Data with imputed missing values: y',i))
}

i=3
for (i in 1:I) {
  my.image(missing_y_mean[[i]] - dat$y_no_missing[[i]], mn=-3, mx=3,
           col=blueToRed(), addLegend=TRUE, xlab='markers',
           main=paste0('Posterior Mean - Full Data',i))
}

