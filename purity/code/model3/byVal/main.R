# load rcommon
require('devtools')
if ( !("rcommon" %in% installed.packages()) ) {
  devtools::install_github('luiarthur/rcommon')
}
library(rcommon)

source("gendata.R")

library(Rcpp)
sourceCpp("purity3.cpp")

dat <- genData(phi_mean=0, phi_var=1, mu=.99, sig2=.1,
               meanN0=30, minM=0, maxM=3, c=.5,
               w2=.01, set_v=c(.1,.5,.9), numLoci=100)

obs <- dat$obs
param <- dat$param

# To do: See where the performance bottlenecks are in the cpp version
system.time(out <- fit(obs$n1, obs$N1, obs$N0, obs$M,
            m_phi=0, s2_phi=100, 
            a_sig=2, b_sig=2,
            a_mu=1, b_mu=1, cs_mu=.3,
            a_m=2,b_m=2, cs_m=1,
            a_w=2,b_w=.01,
            alpha=1, a_v=1, b_v=1, cs_v=.4,
            B=2000,burn=10000,printEvery=1000))

# plot

par(mfrow=c(2,3))

plotPost(out$sig2, main=paste0('sig2(truth=',param$sig2,')'),float=TRUE)

muAcc <- round(length(unique(out$mu)) / length(out$mu),2)
plotPost(out$mu,main=paste0('mu',' (truth=',param$mu,')'),
         float=TRUE,xlab=paste0('accRate: ', muAcc))

plotPost(out$w2,main=paste0('w2(truth=',param$w2,')'),float=TRUE)

plot(param$phi,apply(out$phi,1,mean),fg='grey',
     xlim=range(param$phi), ylim=range(param$phi),
     xlab='truth',ylab='prediction',main='phi',col='grey30')
abline(0,1,col='grey30')
add.errbar(t(apply(out$phi,1,quantile,c(.025,.975))),x=param$phi,col=rgb(0,0,1,.2))

ord <- order(param$v)
numClus <- apply(out$v,2,function(x) length(unique(x)))
plot(param$v[ord],pch=20,ylim=c(0,1),main=paste('v\n mean numclus:',mean(numClus)),col='grey30',fg='grey',ylab='')
points(apply(out$v,1,mean)[ord],lwd=2,col='blue')
add.errbar(t(apply(out$v,1,quantile,c(.025,.975)))[ord,],co=rgb(0,0,1,.5))
p <- obs$n1 / obs$N1
points(p[ord],col='red',pch=20)

#plot(v[,ord[ncol(v)]],col=rgb(.5,.5,.5,.3),type='l',ylim=c(0,1),fg='grey',main='trace plot for v_100')

plot(param$m,apply(out$m,1,mean),fg='grey',
     xlab='truth',ylab='prediction',main='m',col='grey30')
abline(0,1,col='grey30')
add.errbar(t(apply(out$m,1,quantile,c(.025,.975))),x=param$m,col=rgb(0,0,1,.2))

par(mfrow=c(1,1))

