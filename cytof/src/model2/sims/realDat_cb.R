library(cytof2)
library(rcommon)

#transform_data <- function(dat, co) {
#  y <- as.matrix(t(log(t(dat) / co)))
#  ifelse(y == -Inf, NA, y)
#}
#
#PATH <- "../../../dat/cytof_data_lili/cytof_data_lili/"
#
#cbs <- read.expression.in.dir(paste0(PATH,"cb/"))
#cbs_cutoff <- read.cutoff.in.dir(paste0(PATH,"cb/"))
#
#J <- NCOL(cbs[[1]])
#I <- length(cbs)
#
#y <- lapply(as.list(1:I), function(i) transform_data(cbs[[i]], cbs_cutoff[[i]]))

### GLOBAL VARS ###
DATDIR <- "dat/"
OUTDIR <- "out/"
pdf(paste0(OUTDIR, "sim_realdat.pdf"))
###################

set.seed(1)

### Read in y
load(paste0(DATDIR, "cytof_cb.RData"))
I <- length(y)
J <- ncol(y[[1]])

missing_count = sapply(y, function(yi)
  #apply(yi, 2, function(col) sum(col==-Inf))
  apply(yi, 2, function(col) sum(is.na(col)))
)

plot.histModel2(y, xlim=c(-6,6))
for (i in 1:I) {
  my.image(y[[i]], mn=-3, mx=3, col=blueToRed(), addLegend=TRUE, 
           main=paste0("Data: y", i), ylab="N", xlab="", xaxt="n",
           useRaster=TRUE,
           f=label_markers)
}


truth = list(K=10)
system.time(out <- cytof_fix_K_fit(y, truth=truth, B=200, burn=1000, thin=5))
#system.time(out <- cytof_fix_K_fit(y, truth=truth, B=5, burn=0, thin=1))

### Loglike
ll <- sapply(out, function(o) o$ll)
plot(ll <- sapply(out, function(o) o$ll), type='l',
     main='log-likelihood', xlab='mcmc iteration', ylab='log-likelihood')


### Z
Z <- lapply(out, function(o) o$Z)
Z_mean <- matApply(Z, mean)
Z_sd <- matApply(Z, sd)
my.image(Z_sd, main="Z: posterior sd")
my.image(Z_mean, main="Z: posterior mean")
my.image(Z_mean>.5, main="Z: posterior mean (>.5)")

### W
W <- lapply(out, function(o) o$W)
W_mean <- matApply(W, mean)
W_sd <- matApply(W, sd)
my.image(W_sd, mn=0, mx=.1, 
         ylab="I", xlab="K", main="Posterior SD: W", addL=TRUE)
my.image(W_mean, ylab="I", xlab="K", main="Posterior Mean: W", addL=TRUE)
sink(paste0(OUTDIR, "W.txt"))
print(W_mean)
sink()

### beta_0
beta_0 = sapply(out, function(o) o$beta_0)
beta_0_mean = rowMeans(beta_0)
beta_0_ci = t(apply(beta_0, 1, quantile, c(.025,.975)))

a = sapply(c(t(missing_count) / 30), function(x) min(x,1))
plot(beta_0_mean, main='b0', pch=20, cex=2, fg='grey', col=rgb(0,0,1,a))
add.errbar(beta_0_ci, x=1:(I*J), lty=2, col=rgb(0,0,1,.3))

### betaBar_0
betaBar_0 = sapply(out, function(o) o$betaBar_0)
betaBar_0_mean <- rowMeans(betaBar_0)
betaBar_0_ci <- t(apply(betaBar_0, 1, quantile, c(.025,.975)))

### beta_1
beta_1 = sapply(out, function(o) o$beta_1)
beta_1_mean = rowMeans(beta_1)
beta_1_ci = t(apply(beta_1, 1, quantile, c(.025,.975)))

plot(beta_1_mean, main='b1', pch=20, col=rgb(0,0,1), cex=2, fg='grey')
add.errbar(beta_1_ci, x=1:(I*J), lty=2, col=rgb(0,0,1,.5))

### Prob of missing
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

for (j in c(1, 12)){
  plot(ys, ys, ylim=0:1, type='n', fg='grey', xlab='y', ylab='prob of missing')
  title(main=paste0('Prob of missing: marker ',j))
  for (i in 1:I) {
    plot_beta(out, i, j, addT=TRUE, plot_a=T, y=ys, col.line='steelblue', lwd=2)
  }
}

### mus0
mus0 = sapply(out, function(o) c(o$mus[,,1]))
mus0_mean = rowMeans(mus0)
mus0_ci = t(apply(mus0, 1, quantile, c(.025,.975)))

### mus1
mus1 = sapply(out, function(o) c(o$mus[,,2]))
mus1_mean = rowMeans(mus1)
mus1_ci = t(apply(mus1, 1, quantile, c(.025,.975)))

### mus
plot(c(c(mus0_mean), c(mus1_mean)), pch=20,fg='grey',
     col='blue', main='Posterior mu*', xlab='', ylab='mu*')
abline(h=0, col='grey', lty=2)
add.errbar(rbind(mus0_ci, mus1_ci), col=rgb(0,0,1,.2))


### gams_0: TODO
gams_0 = sapply(out, function(o) o$gams_0)
gams_0_mean = rowMeans(gams_0)
gams_0_ci = t(apply(gams_0, 1, quantile, c(.025,.975)))

plot(c(gams_0_mean), fg='grey',
     ylab='Posterior Mean: gam0*', 
     main=expression('Posterior'~gamma[0]^'*'),
     pch=20, col='blue')
add.errbar(gams_0_ci, col=rgb(0,0,1,.3))

# sig2: FIXME! has not moved
sig2 = sapply(out, function(o) o$sig2)
sig2_mean = rowMeans(sig2)
sig2_ci = t(apply(sig2, 1, quantile, c(.025,.975)))

plot(c(sig2_mean), ylim=range(sig2),
     pch=20, col='blue', fg='grey', xlab='', ylab='posterior mean',
     main=expression(sigma[ij]^2))
add.errbar(sig2_ci, col=rgb(0,0,1,.3))

# gams and sig2
gs <- sapply(out, function(o) o$sig2 * (1 + o$gams_0))
gs_mean <- rowMeans(gs)
gs_ci <- t(apply(gs, 1, quantile, c(.025,.975)))

plot(c(gs_mean), pch=20, col='blue', fg='grey',
     xlab='', ylab='posterior mean',
     main=expression(sigma[ij]^2~(1+gamma[0][ij])))
add.errbar(gs_ci, col=rgb(0,0,1,.3))

# tau2: TODO: Overestimated
tau2 <- t(sapply(out, function(o) o$tau2))
plotPosts(tau2, cnames=paste0('tau2_',0:1,')'))

# psi: FIXME: Has not moved!
psi <- t(sapply(out, function(o) o$psi))
plotPosts(psi, cnames=paste0('psi_',0:1,')'))

# lam: TODO: HOW???

# missing_y
missing_y <- lapply(as.list(1:I), function(i) lapply(out, function(o) {
  matrix(o$missing_y[[i]], ncol=J)
}))

missing_y_mean <- lapply(missing_y, function(m) Reduce("+", m) / length(m))

i=3
for (i in 1:I) {
  my.image(y[[i]], mn=-5, mx=5, col=blueToRed(), addLegend=TRUE,
           xlab='markers', main=paste0('Data: y',i), useRaster=TRUE)
  my.image(missing_y_mean[[i]], mn=-5, mx=5, col=blueToRed(), addLegend=TRUE,
           xlab='markers', useRaster=TRUE,
           main=paste0('Data with imputed missing values: y',i))
}

dev.off()
save.image()

