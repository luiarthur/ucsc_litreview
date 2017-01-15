"%btwn%" <- function(elem, rng) {
  sapply(1:length(elem), function(i) {
    rng[i,1] <= elem[i] && elem[i] <=rng[i,2]
  })
}

plotPurity <- function(out,dat) {
  obs <- dat$obs
  param <- dat$param

  par(mfrow=c(2,3))

  plotPost(out$sig2, main=paste0('sig2(truth=',param$sig2,')'),float=TRUE)

  muAcc <- round(length(unique(out$mu)) / length(out$mu),2)
  plotPost(out$mu,main=paste0('mu',' (truth=',param$mu,')'),
           float=TRUE,xlab=paste0('accRate: ', muAcc))

  plotPost(out$w2,main=paste0('w2(truth=',param$w2,')'),float=TRUE)

  phiCoverage <- 
    mean( param$phi %btwn% t(apply(out$phi,1,quantile,c(.025,.975))) )

  plot(param$phi,apply(out$phi,1,mean),fg='grey',
       xlim=range(param$phi), ylim=range(param$phi),
       xlab='truth',ylab='prediction',
       main=paste('phi','(Coverage =',phiCoverage,')'),
       col='grey30')
  abline(0,1,col='grey30')
  add.errbar(t(apply(out$phi,1,quantile,c(.025,.975))),x=param$phi,col=rgb(0,0,1,.2))

  ord <- order(param$v)
  numClus <- apply(out$v,2,function(x) length(unique(x)))
  plot(param$v[ord],pch=20,ylim=c(0,1),main=paste('v\n mean numclus:',mean(numClus)),col='grey30',fg='grey',ylab='')
  points(apply(out$v,1,mean)[ord],lwd=2,col='blue')
  add.errbar(t(apply(out$v,1,quantile,c(.025,.975)))[ord,],co=rgb(0,0,1,.2))
  p <- obs$n1 / obs$N1
  points(p[ord],col='red',pch=20)

  #plot(v[,ord[ncol(v)]],col=rgb(.5,.5,.5,.3),type='l',ylim=c(0,1),fg='grey',main='trace plot for v_100')

  mCoverage <- 
    mean( param$m %btwn% t(apply(out$m,1,quantile,c(.025,.975))) )

  plot(param$m,apply(out$m,1,mean),fg='grey',
       xlab='truth',ylab='prediction',
       main=paste('m','(Coverage =',mCoverage,')'),
       col='grey30')
  abline(0,1,col='grey30')
  add.errbar(t(apply(out$m,1,quantile,c(.025,.975))),x=param$m,col=rgb(0,0,1,.2))

  par(mfrow=c(1,1))
}
