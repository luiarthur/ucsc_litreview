library(cytof2)

load("dat/cytof_cb.RData")
Y = do.call(rbind, y)
Y = ifelse(is.na(Y), -6, Y)

### COMMENT THIS TO SEE EFFECT ###
#Y = ifelse(Y < -.5, -3, ifelse(Y < .5, 0, 3))

my.image(Y, col=blueToRed(), mn=-4, mx=4, xlab='markers', ylab='obs', addL=T)

K = 10
out = kmeans(Y, K, alg='Lloyd', iter.max=100)
plot(table(out$clus))
my.image(Y[order(out$clus),],
         col=blueToRed(), mn=-3, mx=3, xlab='markers', ylab='obs', addL=T)

Ymiss = ifelse(Y==-6, NA, Y)
my.image(Ymiss[out$clus==1,], col=blueToRed(), mn=-3, mx=3, addL=T)

### Image of Y1 by clutsers ###
my.image(Ymiss[out$clus[1:nrow(y[[1]])]==1,], col=blueToRed(), mn=-3, mx=3, addL=T)

### Z ###
Z = sapply(1:K, function(k) 1 * (colMeans(Y[out$clus==k,]) > 0))
Z = unique(Z,MARGIN=2)
my.image(Z)


K = 10; J=5
out = as.list(1:((K-1) * J))
km = as.list(1:((K-1) * J))
i = 1
for (k in 2:K) {
  for (j in 1:J) {
    print(i)
    tmp = kmeans(Y,k,alg='Lloyd', iter.max=500)
    #tmp = kmeans((Y>0)*1,k,alg='Lloyd', iter.max=500)
    #Z = sapply(1:k, function(l) 1 * (colMeans(Y[tmp$clus==l,]) > 0))
    Z = t((tmp$centers>0) * 1)
    #Z = t((tmp$centers>.5) * 1)
    out[[i]] = unique(Z,MARGIN=2)
    km[[i]] = tmp
    i = i + 1 
  }
}

bad_idx = which(sapply(out, function(x) is.na(sum(x))))
Z.est = if(length(bad_idx)) estimate_Z(out[-bad_idx]) else estimate_Z(out)
ind.est = if(length(bad_idx)) estimate_Z(out[-bad_idx],ret=T) else estimate_Z(out, ret=T)
my.image(Z.est[,left_order(Z.est)])
my.image(t(Z.est[,left_order(Z.est)]))

### Image of Y by clusters ###
layout(matrix(c(1,1,1,1,1,1,2,2,2), 3, 3, byrow = TRUE))
my.image(Y[km[[ind.est]]$clus,], mn=-4, mx=4, col=blueToRed())
my.image(t(Z.est))
par(mfrow=c(1,1))
#my.image(km[[ind.est]]$centers, mn=-4, mx=4, col=blueToRed())
#my.image(t(Z.est[,left_order(Z.est)]))
#my.image(km[[ind.est]]$centers>0)
#par(mfrow=c(1,1))
#my.image(dat$Z[,left_order(dat$Z)])

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

