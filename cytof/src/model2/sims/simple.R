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

dat <- simdat(I=3, N=c(200,300,100), J=J, K=K, Z=genZ(J, K, c(.4,.6)), W=W,
              thresh=-4)

# TODO: Add to package
extendZ <- function(Z,K) {
  if (NCOL(Z) > K) {
    Z[,1:K]
  } else if (NCOL(Z) < K) {
    extendZ(cbind(Z,0), K)
  } else {
    Z
  }
}

plot.histModel2(dat$y, xlim=c(-5,5))
my.image(dat$Z)
my.image(dat$y[[1]], mn=-5, mx=5, col=blueToRed(), addLegend=TRUE)

#system.time(out <- cytof_fix_K_fit(dat$y, truth=list(K=10), B=200, burn=400, init=list(Z=extendZ(dat$Z, 10))))
#system.time(out <- cytof_fix_K_fit(dat$y, truth=list(K=10), B=2, burn=0))
system.time(out <- cytof_fix_K_fit(dat$y, truth=list(K=10), B=200, burn=400)

ll <- sapply(out, function(o) o$ll)
plot(ll <- sapply(out, function(o) o$ll), type='l')

# Z
Z <- lapply(out, function(o) o$Z)
Z_mean <- matApply(Z, mean)
Z_sd <- matApply(Z, sd)
ord <- left_order(Z_mean>.5)

for (i in 1:length(out)) my.image(Z[[i]][,ord], main="posterior", ylab="1:J")

my.image(Z_sd[,ord], main="Posterior SD", ylab="1:J", addL=T)
my.image(Z_mean[,ord], main="Posterior Mean", ylab="1:J", addL=T)
my.image(Z_mean[,ord]>.5, main="Posterior Mean", ylab="1:J", addL=T, rm0=TRUE)
my.image(dat$Z, main="True Z", ylab="1:J", addL=T)

# W
W <- lapply(out, function(o) o$W)
W_mean <- matApply(W, mean)
W_sd <- matApply(W, sd)
my.image(W_sd[,ord][,1:4], mn=0, mx=.05, 
         ylab="I", xlab="K", main="Posterior SD: W", addL=TRUE)
my.image(W_mean[,ord][,1:4], ylab="I", xlab="K", main="Posterior Mean: W", addL=TRUE)
my.image(dat$W, ylab="I", xlab="K", main="Data: W", addL=TRUE)

W_mean[,ord]
dat$W

# beta

# beta_0
beta_0 = lapply(out, function(o) matrix(o$beta_0, ncol=J))
beta_0_mean = matApply(beta_0, mean)
beta_0_sd = matApply(beta_0, sd)
my.image(beta_0_mean, mn=-10, mx=-.5, addL=TRUE, xlab='J', ylab='I')
my.image(beta_0_sd, mn=0, mx=5, addL=TRUE, xlab='J', ylab='I', col=blueToRed())

# betaBar_0
betaBar_0 = sapply(out, function(o) o$betaBar_0)
betaBar_0_mean <- rowMeans(betaBar_0)
betaBar_0_ci <- t(apply(betaBar_0, 1, quantile, c(.025,.975)))
plot(betaBar_0_mean, xlab="Markers", ylim=range(betaBar_0_ci), 
     fg='grey', pch=20, col='steelblue', cex=2)
add.errbar(betaBar_0_ci, lty=2, col='steelblue')

# beta_1
beta_1 = sapply(out, function(o) o$beta_1)
beta_1_mean = rowMeans(beta_1)
beta_1_ci <- t(apply(beta_1, 1, quantile, c(.025,.975)))
plot(beta_1_mean, xlab="Markers", ylim=range(beta_1_ci), 
     fg='grey', pch=20, col='steelblue', cex=2)
add.errbar(beta_1_ci, lty=2, col='steelblue')

# Prob of missing
p <- function(o, i, j, y) {
  b0ij <- matrix(o$beta_0, ncol=J)[i,j]
  b1j <- o$beta_1[j]
  1 / (1 + exp(-b0ij + b1j * y))
}

plot_beta <- function(mcmc, i, j, q=c(.025,.975), y_grid=seq(-12,12,len=50), 
                      plot_line=TRUE, plot_area=TRUE, addToExistingPlot=FALSE, 
                      col.line='blue',col.area=rgb(0,0,1,.1), ...) {

  p_curve_ij = sapply(mcmc, p, i, j, y_grid)
  p_curve_ij_mean = rowMeans(p_curve_ij)
  p_curve_ij_ci = apply(p_curve_ij, 1, quantile, q)
  if(plot_line && addToExistingPlot) {
    lines(y_grid, p_curve_ij_mean, ylim=0:1, type='l', col=col.line, ...)
  } else if (plot_line && !addToExistingPlot) {
    plot(y_grid, p_curve_ij_mean, ylim=0:1, type='l', col=col.line, ...)
  } 
  if (plot_area) color.btwn(y_grid, ylo=p_curve_ij_ci[1,], yhi=p_curve_ij_ci[2,], 
                            from=min(y_grid), to=max(y_grid), col=col.area)
}

ys <- seq(-12,12,l=100)
plot(ys, ys, ylim=0:1, type='n')
for (i in 1:I) for (j in 1:J) {
  r=135/255; g=206/255; b=250/255
  plot_beta(out, i, j, plot_line=FALSE, col.area=rgb(r,g,b,.05), y=ys)
}
for (i in 1:I) for (j in 1:J) {
  plot_beta(out, i, j, addT=TRUE, plot_area=FALSE, y=ys, col.line=j)
}

plot(ys, ys, ylim=0:1, type='n', fg='grey')
j = 14
for (i in 1:I) {
  plot_beta(out, i, j, addT=TRUE, plot_a=T, y=ys, col.line='steelblue', lwd=2)
}

# mus0
mus0 = sapply(out, function(o) c(o$mus[,,1]))
mus0_mean = rowMeans(mus0)
mus0_ci = t(apply(mus0, 1, quantile, c(.025,.975)))
plot(c(dat$mus_0), mus0_mean, col='blue', pch=20)
abline(0,1)
add.errbar(mus0_ci, x=dat$mus_0, col=rgb(0,0,1,.2))

# mus1
mus1 = sapply(out, function(o) c(o$mus[,,2]))
mus1_mean = rowMeans(mus1)
mus1_ci = t(apply(mus1, 1, quantile, c(.025,.975)))
plot(c(dat$mus_1), mus1_mean, col='blue', pch=20)
abline(0,1)
add.errbar(mus1_ci, x=dat$mus_1, col=rgb(0,0,1,.2))

#mus
plot(c(c(dat$mus_0),c(dat$mus_1)), c(c(mus0_mean), c(mus1_mean)), pch=20, col='blue')
abline(0,1, h=0, v=0, col='grey', lty=2)
add.errbar(rbind(mus0_ci, mus1_ci),
           x=c(c(dat$mus_0), c(dat$mus_1)), col=rgb(0,0,1,.2))


#mus0_ls = lapply(out, function(o) o$mus[,,1])
#mus0 = array(unlist(mus0_ls), dim = c(nrow(mus0_ls[[1]]), ncol(mus0_ls[[1]]), length(mus0_ls)))
#mus0_mean = apply(mus0, 1:2, mean)
#
#my.image(mus0_mean, mn=-4, mx=0, col=blueToRed(), addLegend=TRUE)
#my.image(dat$mus_0, mn=-4, mx=0, col=blueToRed(), addLegend=TRUE)
#my.image(mus0_mean-dat$mus_0, mn=-3, mx=3, col=blueToRed(), addLegend=TRUE)
#
## mus1
#mus1_ls = lapply(out, function(o) o$mus[,,2])
#mus1 = array(unlist(mus1_ls), dim = c(nrow(mus1_ls[[1]]), ncol(mus1_ls[[1]]), length(mus1_ls)))
#mus1_mean = apply(mus1, 1:2, mean)
#
#my.image(mus1_mean, mn=0, mx=4, col=blueToRed(), addLegend=TRUE)
#my.image(dat$mus_1, mn=0, mx=4, col=blueToRed(), addLegend=TRUE)
#my.image(mus1_mean-dat$mus_1, mn=-1, mx=1, col=blueToRed(), addLegend=TRUE)

# gams_0: TODO
gams_0 = sapply(out, function(o) o$gams_0)
gams_0_mean = rowMeans(gams_0)
gams_0_ci = t(apply(gams_0, 1, quantile, c(.025,.975)))

plot(c(dat$gams_0), c(gams_0_mean),
     xlim=c(0,.1), ylim=c(0,30), pch=20, col='blue')
abline(0,1, col='grey')
add.errbar(gams_0_ci, x=dat$gams_0, col=rgb(0,0,1,.2))

#my.image(dat$gams_0, mn=0, mx=1, col=blueToRed(), addL=T)
#my.image(gams_0_mean, mn=0, mx=1, col=blueToRed(), addL=T)
#my.image(gams_0_mean - dat$gams_0, mn=-.5, mx=.5, col=blueToRed(), addL=T)


# sig2: FIXME! has not moved
sig2 = sapply(out, function(o) o$sig2)
sig2_mean = rowMeans(sig2)
sig2_ci = t(apply(sig2, 1, quantile, c(.025,.975)))

plot(c(dat$sig2), c(sig2_mean), xlim=c(0,2), ylim=c(0,2), pch=20, col='blue',
     fg='grey', xlab='truth', ylab='posterior mean', main='sig2')
abline(0,1, col='grey')
add.errbar(sig2_ci, x=c(dat$sig2), col=rgb(0,0,1,.3))

# gams and sig2
dat_gs <- c(dat$sig2 * (dat$gams_0 + 1))
gs <- sapply(out, function(o) o$sig2 * (1 + o$gams_0))
gs_mean <- rowMeans(gs)
gs_ci <- t(apply(gs, 1, quantile, c(.025,.975)))

plot(c(dat_gs), rowMeans(gs), pch=20, col='blue', fg='grey')
abline(0,1)
add.errbar(gs_ci, x=c(dat_gs), col=rgb(0,0,1,.3))

# tau2: TODO: Overestimated
tau2 <- t(sapply(out, function(o) o$tau2))
plotPosts(tau2, cnames=paste0('Truth=', c(dat$tau2_0, dat$tau2_1)))

# psi: FIXME: Has not moved!
#psi <- t(sapply(out, function(o) o$psi))
#plotPosts(psi, cnames=paste0('Truth=', c(dat$psi_0, dat$psi_1)))

# lam: TODO: HOW???

# missing_y
missing_y <- lapply(as.list(1:I), function(i) lapply(out, function(o) {
  matrix(o$missing_y[[i]], ncol=J)
}))

missing_y_mean <- lapply(missing_y, function(m) Reduce("+", m) / length(m))

i=3
for (i in 1:I) {
  my.image(dat$y[[i]], mn=-5, mx=5, col=blueToRed(), addLegend=TRUE)
  my.image(missing_y_mean[[i]], mn=-5, mx=5, col=blueToRed(), addLegend=TRUE)
}

