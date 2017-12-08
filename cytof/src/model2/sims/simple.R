#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(cytof2)
library(rcommon)
#source("../cytof2/R/readExpression.R")

if (length(args) < 8) {
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
  SEED <- 1
}
set.seed(SEED)

### GLOBALS
#OUTDIR = 'out/simple/'
fileDest = function(name) paste0(OUTDIR, name)
system(paste0('mkdir -p ', OUTDIR))
system(paste0('cp simple.R ', fileDest('src.R')))


I = 3
#J = 32
K = 4
#DATA_SIZE = 10000
W <- matrix(c(.3, .4, .2, .1,
              .1, .7, .1, .1,
              .2, .3, .3, .2), nrow=I, byrow=TRUE)

#bdat = get_beta(y=c(-5,-4), p_tar=c(.99,.01), plot=FALSE)

dat_lim = c(-10,10)
y_beta = c(-11,-10)
#y_beta = c(-6,-5.5)
#y_beta = c(-5,-4.5)
#y_beta = c(-11,-10)
bdat = get_beta(y=y_beta, p_tar=c(.99,.01), plot=FALSE)

dat <- simdat(I=I, N=c(2,3,1)*DATA_SIZE, J=J, K=K, 
#dat <- simdat(I=I, N=c(2,3,1)*10000, J=J, K=K, 
              b0=matrix(bdat[1],I,J),
              b1=rep(-bdat[2],J),
              #b0=matrix(-50,I,J),
              #b1=rep(15,J),
              Z=if (USE_SIMPLE_Z) genSimpleZ(J, K) else genZ(J,K),
              #Z=genZ(J, K, c(.4,.6)),
              W=W,
              #psi_0=-2, psi_1=1,
              #tau2_0=1, tau2_1=.1,
              #gams_0=matrix(rgamma(I*J, 100000,10000), I, J),
              #gams_0=matrix(rgamma(I*J, 50000,10000), I, J),
              psi_0=-3, psi_1=3,
              tau2_0=.1, tau2_1=.1,
              #gams_0=matrix(1/rgamma(I*J, 10000, 100000), I, J),
              #sig2=matrix(1/rgamma(I*J, 27, 13), ncol=J))
              gams_0=matrix(1/rgamma(I*J, 6, .5), I, J),
              sig2=matrix(1/rgamma(I*J, 27, 13), ncol=J))

pdf(fileDest('data.pdf'))

### Prob Missing (Truth)
missing_count = get_missing_count(dat$y)
sink(fileDest('missing_count.txt'))
cat("Missing count:\n")
print(missing_count)
sink()

missing_prop = get_missing_prop(dat$y)
sink(fileDest('missing_prop.txt'))
cat("Missing proportion:\n")
print(missing_prop)
sink()

y_grid = seq(-10,0,l=100)
plot(y_grid, 1 / (1 + exp(-dat$b0[1] + dat$b1[1]*y_grid)), 
     xlab='y', ylab='prob of missing', fg='grey', type='b',
     main='True Probability of Missing', ylim=0:1)
abline(v=y_beta, col='grey')
#plot.histModel2(dat$y, xlim=c(-5,5), main='Histogram of Data', quant=c(.05,.95))


par(mfrow=c(4,2))
for (i in 1:I) for (j in 1:J) {
  plot_dat(dat$y, i, j, xlim=dat_lim, xlab=paste0('marker ',j))
  #Sys.sleep(1)
}
par(mfrow=c(1,1))

mus_est = get_mus_est(dat$y)

plot(c(c(dat$mus_0),c(dat$mus_1)), c(c(mus_est$mus0),c(mus_est$mus1)),
     xlab="true mu*", ylab="empirical estimate of mu*", main='Data: mu*')
abline(0,1, v=0, h=0, lty=2, col='grey')


#par(mfrow=c(4,2))
#for (i in 1:I) for (j in 1:J) {
#  plot_simdat(dat, i,j, xlim=c(-5,5), xlab='bla', prob=TRUE,
#              main=paste0('Truth: Y',i,': Col',j))
#}
#par(mfrow=c(1,1))

plot.histModel2(dat$y, xlim=dat_lim, main='Histogram of Data', quant=c(.05,.95))
for (i in 1:I) {
  plot.histModel2(list(dat$y[[i]]), xlim=dat_lim,
                  main=paste('Histogram of Data:',i))
}

dev.off()

png(fileDest('rawDat%03d.png'))
my.image(dat$Z, xlab='j', ylab='k', main='True Z')
for (i in 1:length(dat$y)) {
  my.image(dat$y[[i]], mn=dat_lim[1], mx=dat_lim[2], col=blueToRed(),
           addLegend=TRUE, main=paste0('y',i), xlab='j', ylab='n')
}
dev.off()


### Start MCMC ###
### FIXME: Recover gams_0 ###
#true_mus = array(NA,dim=c(I,J,2))
#true_mus[,,1] = dat$mus_0; true_mus[,,2] = dat$mus_1
#truth=list(K=MCMC_K, 
#           sig2=dat$sig2,
#           #gams_0=dat$gams_0,
#           mus=true_mus, Z=dat$Z, W=dat$W,
#           beta_0=dat$b0, beta_1=dat$b1, beta_all=NULL,
#           psi=c(dat$psi_0, dat$psi_1), tau2=c(dat$tau2_0, dat$tau2_1))
#prior = list(cs_v=4, cs_h=3, d_w=1/MCMC_K, a_gam=2, b_gam=1)
### END ###
truth=list(K=MCMC_K)
prior = list(cs_v=4, cs_h=3, d_w=1/MCMC_K)
sim_time <- system.time(
  out <- cytof_fix_K_fit(dat$y, truth=truth, prior=prior,
                         B=B, burn=BURN, thin=THIN, print=1)
)
sink(fileDest('simtime.txt')); print(sim_time); sink()


plot_cytof_posterior(out, dat$y, outdir=OUTDIR, sim=dat, dat_lim=dat_lim)
#plot_cytof_posterior(out, dat$y, outdir=OUTDIR)

