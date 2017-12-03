#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(cytof2)
library(rcommon)
set.seed(1)
#source("../cytof2/R/readExpression.R")

if (length(args) < 5) {
  stop('usage: Rscript simple.R J MCMC_K DATA_SIZE USE_SIMPLE_Z OUTDIR B BURN THIN')
} else {
  J <- as.integer(args[1])
  MCMC_K <- as.integer(args[2])
  DATA_SIZE <- as.integer(args[3])
  USE_SIMPLE_Z <- as.integer(args[4])
  OUTDIR <- args[5]
  B <- as.integer(args[6])
  BURN <- as.integer(args[7])
  THIN <- as.integer(args[8])
}

### GLOBALS
#OUTDIR = 'out/simple/'
fileDest = function(name) paste0(OUTDIR, name)
system(paste0('mkdir -p ', OUTDIR))


I = 3
#J = 32
K = 4
#DATA_SIZE = 10000
W <- matrix(c(.3, .4, .2, .1,
              .1, .7, .1, .1,
              .2, .3, .3, .2), nrow=I, byrow=TRUE)

#bdat = get_beta(y=c(-5,-4), p_tar=c(.99,.01), plot=FALSE)

dat <- simdat(I=I, N=c(2,3,1)*DATA_SIZE, J=J, K=K, 
#dat <- simdat(I=I, N=c(2,3,1)*10000, J=J, K=K, 
              b0=matrix(-50,I,J),
              b1=rep(15,J),
              Z=if (USE_SIMPLE_Z) genSimpleZ(J, K) else genZ(J,K),
              #Z=genZ(J, K, c(.4,.6)),
              W=W,
              psi_0=-2, psi_1=1,
              tau2_0=1, tau2_1=.1,
#              gams_0=matrix(rgamma(I*J, 100000,10000), I, J),
              gams_0=matrix(rgamma(I*J, 50000,10000), I, J),
              sig2=matrix(rgamma(I*J, 1000, 10000), ncol=J))

pdf(fileDest('data.pdf'))

### Prob Missing (Truth)
missing_count = get_missing_count(dat$y)
sink(fileDest('missing_count.txt'))
print(missing_count)
sink()

y_grid = seq(-6,0,l=100)
plot(y_grid, 1 / (1 + exp(-dat$b0[1] + dat$b1[1]*y_grid)), 
     xlab='y', ylab='prob of missing', fg='grey', type='b',
     main='True Probability of Missing')
abline(v=-4:-3, col='grey')
#plot.histModel2(dat$y, xlim=c(-5,5), main='Histogram of Data', quant=c(.05,.95))


par(mfrow=c(4,2))
for (i in 1:I) for (j in 1:J) {
  plot_dat(dat$y, i, j, xlim=c(-5,5), ylim=c(0,1), xlab=paste0('marker ',j))
  #Sys.sleep(1)
}
par(mfrow=c(1,1))

mus_est = get_mus_est(dat$y)

plot(c(c(dat$mus_0),c(dat$mus_1)), c(c(mus_est$mus0),c(mus_est$mus1)),
     xlab="true mu*", ylab="empirical estimate of mu*", main='Data: mu*')
abline(0,1)


#par(mfrow=c(4,2))
#for (i in 1:I) for (j in 1:J) {
#  plot_simdat(dat, i,j, xlim=c(-5,5), xlab='bla', prob=TRUE,
#              main=paste0('Truth: Y',i,': Col',j))
#}
#par(mfrow=c(1,1))

plot.histModel2(dat$y, xlim=c(-5,5), main='Histogram of Data', quant=c(.05,.95))
plot.histModel2(list(dat$y[[1]]), xlim=c(-5,5), main='Histogram of Data')
plot.histModel2(list(dat$y[[2]]), xlim=c(-5,5), main='Histogram of Data')
plot.histModel2(list(dat$y[[3]]), xlim=c(-5,5), main='Histogram of Data')

dev.off()

png(fileDest('rawDat%03d.png'))
my.image(dat$Z, xlab='j', ylab='k', main='True Z')
for (i in 1:length(dat$y)) {
  my.image(dat$y[[i]], mn=-5, mx=5, col=blueToRed(), addLegend=TRUE,
           main=paste0('y',i), xlab='j', ylab='n')
}
dev.off()


#mus_init <- array(0, c(I,J,2))
#mus_init[,,1] <- ifelse(is.na(mus0_est), mean(mus0_est), mus0_est)
#mus_init[,,2] <- ifelse(is.na(mus1_est), mean(mus1_est), mus1_est)
#warmup_truth <- list(K=10, mus=mus_init)
##prior <- list(cs_v=4, cs_h=3)
#prior = list(cs_v=4, cs_h=3, a_beta=500000, b_beta=100000)
#init = list(beta_1=rep(5,J))
#warmup <- cytof_fix_K_fit(dat$y, B=100, burn=0, print=1,
#                          truth=warmup_truth, prior=prior, init=init)
#ll_warmup <- sapply(warmup, function(o) o$ll); plot(ll_warmup, type='l')
#my.image(last(warmup)$Z)
#Z_warm <- lapply(warmup, function(o) o$Z)
#for (i in 1:length(Z_warm)) {
#  my.image(Z_warm[[i]], main=paste0('iteration ',i))
#  Sys.sleep(.1)
#}
#my.image(matApply(Z_warm,mean), addL=T)
#
#### v ###
#v <- sapply(warmup, function(w) w$v)
#plot(rowMeans(v), pch=20, cex=2)
#par(mfrow=c(5,2))
#for (i in 1:nrow(v)) plot(v[i,], type='l')
#par(mfrow=c(1,1))
#
#### H ###
#H <- sapply(warmup, function(w) w$H)
#plot(rowMeans(H), col=last(Z_warm)+3, pch=20)
#par(mfrow=c(4,2))
#for (i in 1:nrow(H)) {plot(H[i,], type='l'); abline(h=0, col='grey')}
#par(mfrow=c(1,1))
#
#truth=list(K=10)#, Z=extendZ(dat$Z, 10))
#init=last(warmup)
#init$missing_y <- NULL
#system.time(out <- cytof_fix_K_fit(dat$y, B=200, burn=80, thin=5, print=1,
#                                   truth=truth, init=init))


truth=list(K=MCMC_K)
prior = list(cs_v=4, cs_h=3)
#system.time(out <- cytof_fix_K_fit(dat$y, truth=truth, prior=prior,
#                                   B=100, burn=200, thin=2, print=1))
system.time(out <- cytof_fix_K_fit(dat$y, truth=truth, prior=prior,
                                   B=B, burn=BURN, thin=THIN, print=1))


plot_cytof_posterior(out, dat$y, outdir=OUTDIR, sim=dat)
#plot_cytof_posterior(out, dat$y, outdir=OUTDIR)

