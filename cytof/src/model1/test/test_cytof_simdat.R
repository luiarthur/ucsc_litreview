library(rcommon)
source("../cytof.R", chdir=TRUE)
source("../cytof_simdat.R")
source("../../dat/myimage.R")


set.seed(1)
dat <- cytof_simdat(I=3, N=list(2000, 3000, 1000), J=10, K=4, p=.5,
                    psi=rnorm(10, 1, 2), tau2=rep(3,10), sig2=rep(.1,3),
                    W=matrix(c(.3, .4, .2, .1,
                               .1, .7, .1, .1,
                               .2, .3, .3, .2), 3, 4, byrow=TRUE))

### PLOT DATA
my.image(cor(dat$y[[1]]), xaxt='n',yaxt='n',xlab="",ylab="",
         main="y1 Correlation b/w Markers",addLegend=TRUE)
my.image(cor(dat$y[[2]]), xaxt='n',yaxt='n',xlab="",ylab="",
         main="y2 Correlation b/w Markers",addLegend=TRUE)
my.image(cor(dat$y[[3]]), xaxt='n',yaxt='n',xlab="",ylab="",
         main="y3 Correlation b/w Markers",addLegend=TRUE)
my.image(dat$Z)

### Compute
y <- dat$y
I <- dat$I
J <- dat$J

p <- .1
N_i <- sapply(y, nrow)
train_idx <- lapply(N_i, function(N) sample(1:N, round(N*p), repl=FALSE))
y_TE <- lapply(as.list(1:I), function(i) y[[i]][-train_idx[[i]],])
y_TR <- lapply(as.list(1:I), function(i) y[[i]][ train_idx[[i]],])

source("../cytof.R", chdir=TRUE)
out <- cytof(y_TE, y_TR, burn_small=300, K_min=1, K_max=6, a_K=2,
             burn=100, B=200, pr=100, 
             cs_psi=1, cs_sig2=.01, cs_tau2=1)

#out <- cytof(y_TE, y_TR, burn_small=10, K_min=1, K_max=6, a_K=2,
#             burn=100, B=20, pr=100, cs_psi=.05)

### K 
K <- sapply(out, function(o) o$K)
plot(K, type='l')

### psi
psi <- t(sapply(out, function(o) o$psi))
plotPosts(psi[,1:5])
plot(apply(psi, 2, function(pj) length(unique(pj)) / length(out)),
     ylim=0:1, main="Acceptance rate for psi")
abline(h=c(.25, .4), col='grey')
colMeans(psi)
dat$psi

### sig2
sig2 <- t(sapply(out, function(o) o$sig2))
plotPosts(sig2)
plot(apply(sig2, 2, function(sj) length(unique(sj)) / length(out)),
     ylim=0:1, main="Acceptance rate for sig2")
abline(h=c(.25, .4), col='grey')
colMeans(sig2)
dat$sig2

### tau2
tau2 <- t(sapply(out, function(o) o$tau2))
plotPosts(tau2[,1:5])
colMeans(tau2)
dat$tau2
plot(apply(tau2, 2, function(tj) length(unique(tj)) / length(out)),
     ylim=0:1, main="Acceptance rate for tau2")
abline(h=c(.25, .4), col='grey')


#
Z <- lapply(out, function(o) extend_mat(o$Z, 3))
Z_mean <- Reduce("+", Z) / length(Z)
my.image(Z_mean, addLegend=T)
my.image(dat$Z, addLegend=T)

W <- lapply(out, function(o) extend_mat(o$W, 6))
W_mean <- Reduce("+", W) / length(W)
W_mean
dat$W

lam <- lapply(out, function(o) o$lam)
unique(sapply(lam, function(l) sapply(l,length)), MAR=2)

lam1 <- sapply(lam, function(l) l[[1]] + 1)
lam2 <- sapply(lam, function(l) l[[2]] + 1)
lam3 <- sapply(lam, function(l) l[[3]] + 1)

rowMeans(lam1)
dat$lam[[1]]
