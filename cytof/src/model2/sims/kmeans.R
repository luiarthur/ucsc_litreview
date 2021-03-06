library(cytof2)
source("adhoc.R")

load("dat/cytof_cb.RData")
y_orig = y
for (i in 1:length(y)) {
  for (j in 1:NCOL(y[[i]])) {
    miss_idx = which(is.na(y[[i]][,j]))

    neg_yj = which(y[[i]][,j] < 0)
    y[[i]][miss_idx,j] = sample(y[[i]][neg_yj,j], size=length(miss_idx), replace=TRUE)

    #y[[i]][miss_idx,j] = sample(y[[i]][-miss_idx,j], size=length(miss_idx), replace=TRUE)
  }
}
Y = do.call(rbind, y)
#Y = ifelse(is.na(Y), -3, Y)

my.image(Y, col=blueToRed(), mn=-4, mx=4, xlab='markers', ylab='obs', addL=T)
#out = adhoc(Y, K_min=10, K_max=15, reps=4, lam=1, alg='Lloyd', iter.max=500)
out = adhoc(Y, K_min=16, K_max=16, reps=1, lam=1, alg='Lloyd', iter.max=500)

Z = lapply(out, function(o) o$Z)
Z.est = estimate_Z(Z)
ind.est = estimate_Z(Z, ret=T)

### Image of Y by clusters ###
layout(matrix(c(1,1,1,1,1,1,2,2,2), 3, 3, byrow = TRUE))
#my.image(unique(Y[order(out[[ind.est]]$km$clus),]>0,MARGIN=1))
#my.image(Y[order(out[[ind.est]]$km$clus[1:NROW(y[[1]])]),], col=blueToRed(), mn=-2,mx=2,xlab='',ylab='obs')
my.image(Y[order(out[[ind.est]]$km$clus),], col=blueToRed(), mn=-2,mx=2,xlab='',ylab='obs')
my.image(t(Z.est), xlab='markers', ylab='cell-types')
par(mfrow=c(1,1))

#### PCA VERSION ###
##pY = prcomp(Y,scale=T)
##plot(cumsum(pY$sd^2 / sum(pY$sd^2)), type='b')
#
#pY = prcomp(Y,scale=T)$x[,1:5]
#outPy = adhoc(pY, 10, 15, 8, lam=1, alg='Lloyd', iter.max=500)
#pZ = lapply(outPy, function(o) o$Z)
#pZ.est = estimate_Z(pZ)
#ind.est = estimate_Z(pZ, ret=T)
#
#### Image of Y by clusters ###
#layout(matrix(c(1,1,1,1,1,1,2,2,2), 3, 3, byrow = TRUE))
#my.image(unique(pY[order(out[[ind.est]]$km$clus),]>0,MARGIN=1))
#my.image(t(pZ.est[, left_order(pZ.est)]))
#par(mfrow=c(1,1))
#
##outPy = kmeans(pY, 7, iter=1000)
##plot(table(outPy$cluster) / sum(table(outPy$cluster)))
##my.image(Y[outPy$cluster,], mn=-4, mx=4, col=blueToRed())

### Simdat $$$

I = 3
J = 32
K = 4
DATA_SIZE = 10000
USE_SIMPLE_Z = 0
W <- matrix(c(.3, .4, .2, .1,
              .1, .7, .1, .1,
              .2, .3, .3, .2), nrow=I, byrow=TRUE)

dat_lim = c(-10,10)
y_beta = c(-5,-4.5)
bdat = get_beta(y=y_beta, p_tar=c(.99,.01), plot=FALSE)

dat <- simdat(I=I, N=c(2,3,1)*DATA_SIZE, J=J, K=K, 
              b0=matrix(bdat[1],I,J),
              b1=rep(-bdat[2],J),
              Z=if (USE_SIMPLE_Z) genSimpleZ(J, K) else genZ(J,K),
              psi_0=-3, psi_1=3,
              tau2_0=.1, tau2_1=.1,
              gams_0=matrix(rnorm(I*J,1,.1),I,J),
              sig2=matrix(rnorm(I*J,1,.1),I,J),
              W=W)

Y = do.call(rbind, dat$y)
Y = ifelse(is.na(Y), -6, Y)

K.hat = 10
out = kmeans(Y, K.hat)
plot(table(out$clus))
my.image(Y[order(out$clus),],
         col=blueToRed(), mn=-3, mx=3, xlab='markers', ylab='obs', addL=T)

### Z ###
Z = sapply(1:K.hat, function(k) 1 * (colMeans(Y[out$clus==k,]) > 0))
Z = unique(Z,MARGIN=2)
my.image(Z[,left_order(Z)])
my.image(dat$Z)

