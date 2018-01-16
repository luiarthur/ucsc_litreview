#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(cytof2)
library(rcommon)
library(xtable) # print_bmat

print_bmat = function(X, file) {
  # Prints a matrix to tex file
  # requires xtable
  sink(file)
  xtab = xtable(X, align=rep("", ncol(X)+1))
  print(xtab, floating=FALSE, tabular.environment="bmatrix", 
        hline.after=NULL, include.rownames=FALSE, include.colnames=FALSE)
  sink()
}

#source("../cytof2/R/readExpression.R")

if (length(args) < 8) {
  stop('usage: Rscript simple.R J MCMC_K_INIT DATA_SIZE USE_SIMPLE_Z OUTDIR B BURN THIN [SEED_DATA] [SEED_MCMC]')
} else {
  J <- as.integer(args[1])
  MCMC_K_INIT <- as.integer(args[2])
  DATA_SIZE <- as.integer(args[3])
  USE_SIMPLE_Z <- as.integer(args[4])
  OUTDIR <- paste0(args[5],'/')
  B <- as.integer(args[6])
  BURN <- as.integer(args[7])
  THIN <- as.integer(args[8])
  SEED_DATA <- ifelse(length(args)>=9,  as.integer(args[9]),  1)
  SEED_MCMC <- ifelse(length(args)>=10, as.integer(args[10]), 1)
}
set.seed(SEED_DATA)

### GLOBALS
#OUTDIR = 'out/simple/'
fileDest = function(name) paste0(OUTDIR, name)
system(paste0('mkdir -p ', OUTDIR))
system(paste0('cp simRandomK.R ', fileDest('src.R')))


I = 3
#J = 32
K = 4
#DATA_SIZE = 10000
W <- matrix(c(.3, .4, .2, .1,
              .1, .7, .1, .1,
              .2, .3, .3, .2), nrow=I, byrow=TRUE)

#bdat = get_beta(y=c(-5,-4), p_tar=c(.99,.01), plot=FALSE)

dat_lim = c(-10,10)
#y_beta = c(-11,-10)
#y_beta = c(-6,-5.5)
#y_beta = c(-5,-2)
y_beta = c(-5,-4.5)
bdat = get_beta(y=y_beta, p_tar=c(.99,.01), plot=FALSE)

dat <- simdat(I=I, N=c(2,3,1)*DATA_SIZE, J=J, K=K, 
#dat <- simdat(I=I, N=c(2,3,1)*10000, J=J, K=K, 
              b0=matrix(bdat[1],I,J),
              b1=rep(-bdat[2],J),
              #b0=matrix(-50,I,J),
              #b1=rep(15,J),
              Z=if (USE_SIMPLE_Z) genSimpleZ(J, K) else genZ(J,K),
              #Z=genZ(J, K, c(.4,.6)),
              #psi_0=-5, psi_1=5,
              psi_0=-3, psi_1=3,
              tau2_0=.1, tau2_1=.1,
              gams_0=matrix(rnorm(I*J,1,.1),I,J),
              sig2=matrix(rnorm(I*J,1,.1),I,J),
              W=W)

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
  plot_dat(dat$y, i, j, xlim=dat_lim, xlab=paste0('marker ',j),breaks=10)
  hist(dat$y_no_missing[[i]][,j], border='grey', add=TRUE, breaks=10)
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

my.image(dat$Z, xlab='j', ylab='k', main='True Z')
dev.off()

png(fileDest('rawDat%03d.png'))
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
#           #sig2=dat$sig2,
#           #gams_0=dat$gams_0,
#           mus=true_mus, Z=dat$Z, W=dat$W,
#           beta_0=dat$b0, beta_1=dat$b1, beta_all=NULL,
#           psi=c(dat$psi_0, dat$psi_1), tau2=c(dat$tau2_0, dat$tau2_1))
#prior = list(cs_v=4, cs_h=3, d_w=1/MCMC_K)
### END ###

dat$y <- lapply(dat$y, shuffle_mat)
set.seed(SEED_MCMC)
prior = list(cs_v=4, cs_h=3, d_w=1/MCMC_K_INIT,
             a_beta=90, b_beta=30,
             m_betaBar=-11, s2_betaBar=.1, 
             s2_beta0=.1,
             K_min=1, K_max=10, a_K=2)

pdf(fileDest('prior_prob_miss.pdf'))
yy = seq(-15,15,l=100)
plot(yy, 1 / (1 + exp(-dat$b0[1] + dat$b1[1]*yy)), 
     xlab='y', ylab='prob of missing', fg='grey', type='l', lwd=2,
     ylim=0:1, xlim=range(yy))
#abline(v=y_beta, col='grey')

prob_miss_prior = {
  SS = 1000
  bb_samps = rnorm(SS,prior$m_betaBar,sqrt(prior$s2_betaBar))
  b0_samps = rnorm(SS, bb_samps, sqrt(prior$s2_beta0))
  b1_samps = rgamma(SS, prior$a_beta, prior$b_beta)
  p_samps = sapply(1:SS, function(s) 1 / (1 + exp(-b0_samps[s] + b1_samps[s]*yy)))
  p_lo = apply(p_samps, 1, quantile, .025)
  p_hi = apply(p_samps, 1, quantile, .975)
  p_med = apply(p_samps, 1, quantile, .5)
  p_mean = rowMeans(p_samps)
  color.btwn(yy, p_lo, p_hi, from=yy[1], to=yy[length(yy)],
             col.area=rgb(1,0,0,.2))
  lines(yy,p_mean,col='red', lwd=1, lty=2)
  lines(yy,p_med,col='red', lwd=3, lty=2)
}
dev.off()

#truth=list(K=MCMC_K)
truth=list()
init=list(K=MCMC_K_INIT)
sim_time <- system.time(
  out <- cytof_fix_K_fit(dat$y, truth=truth, prior=prior, init=init, thin_K=5,
                         warmup=1000, B=B, burn=BURN, thin=THIN, print=1,
                         ncores=8, prop=.1, show_timings=FALSE)
)
sink(fileDest('simtime.txt')); print(sim_time); sink()
save(dat, out, file=fileDest('sim_result.RData'))


plot_cytof_posterior(out, dat$y, outdir=OUTDIR, sim=dat, dat_lim=dat_lim)

### TMP ###
#maxK = max(sapply(out, function(o) NCOL(o$Z)))
#for(k in 2:maxK) {
#  out_k = Filter(function(o) NCOL(o$Z) == k, out)
#  plot_cytof_posterior(out_k, dat$y, outdir=paste0(OUTDIR,'_out',k,'_'),
#                       sim=dat, dat_lim=dat_lim, supress=c('beta'))
#}
#### TMP ###

#plot_cytof_posterior(out, dat$y, outdir=OUTDIR, dat_lim=dat_lim)

png(fileDest('Y%03dsortedByLambda.png'))
for (i in 1:I) {
  lami_ord = order(last(out)$lam[[i]])
  my.image(dat$y[[i]][lami_ord,], mn=-10, mx=10, ylab='obs', xlab='markers',
           col=blueToRed(),addL=TRUE)
}
dev.off()

print_bmat(dat$W, fileDest("W_truth.tex"))
#print_bmat(matApply(lapply(out, function(o) o$W), mean), fileDest("W_mean.tex"))
maxK = max(sapply(out, function(o) NCOL(o$Z)))
print_bmat(matApply(lapply(out, function(o) extendZ(o$W, maxK)), mean), fileDest("W_mean.tex"))

pdf(fileDest('post_beta.pdf'))
plot_beta(out, missing_count, dat, prior)
dev.off()

### Plots of missing values posterior ###
#idx_miss = last(out)$idx + 1
#y_miss = sapply(out, function(o) o$missing_y_only)

#pdf(fileDest('missing_y.pdf'))
#for (i in 1:nrow(idx_miss)) {
#  plotPost(y_miss[i,], main='',
#           xlab=paste0('(i,n,j): ', paste0(idx_miss[i,], collapse=',')))
#}
#
#hist(c(y_miss), xlab='Missing values')
#dev.off()

### K posterior ###
pdf(fileDest('K.pdf'))
K_post = sapply(out, function(o) NCOL(o$Z))
plot(K_post, type='b', ylab='K', xlab='iteration')
plot(table(K_post) / length(K_post), xlab='K', ylab='proportion')
dev.off()
