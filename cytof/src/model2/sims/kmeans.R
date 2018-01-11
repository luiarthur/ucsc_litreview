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

