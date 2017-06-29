library(rcommon)
source("../cytof_fixed_K.R", chdir=TRUE)
source("../cytof_simdat.R")
source("../../dat/myimage.R")

last <- function(lst) lst[[length(lst)]]

#  psi    tau    sig
#    0  small  small  bad
#    0    big  small  bad
#    0  small    big  recovers W, but not Z
#    0    big    big  bad
#    5     .1    big  Recovers Z and W, but not anything else
#    2     .1     .1  bad
#    2     .1     .1  bad
#    5     .1      1  bad

set.seed(1)
#dat <- cytof_simdat(I=3, N=list(200, 300, 100), J=12, K=4,
#                    tau2=rep(.1,12),
#                    sig2=rep(1,3),
#                    W=matrix(c(.3, .4, .2, .1,
#                               .1, .7, .1, .1,
#                               .2, .3, .3, .2), 3, 4, byrow=TRUE))
dat <- cytof_simdat(I=3, N=list(2000, 3000, 1000), J=12, K=4,
                    a=.5,
                    tau2=rep(.1,12),
                    sig2=rep(1,3),
                    W=matrix(c(.3, .4, .2, .1,
                               .1, .7, .1, .1,
                               .2, .3, .3, .2), 3, 4, byrow=TRUE))

### PLOT DATA
pdf("out/data.pdf")
hist(dat$mus)
my.image(cor(dat$y[[1]]), xaxt='n',yaxt='n',xlab="",ylab="",
         main="y1 Correlation b/w Markers",addLegend=TRUE)
my.image(cor(dat$y[[2]]), xaxt='n',yaxt='n',xlab="",ylab="",
         main="y2 Correlation b/w Markers",addLegend=TRUE)
my.image(cor(dat$y[[3]]), xaxt='n',yaxt='n',xlab="",ylab="",
         main="y3 Correlation b/w Markers",addLegend=TRUE)
my.image(dat$Z)
dev.off()
mean(dat$y[[1]] == 0)

### Compute
y <- dat$y
I <- dat$I
J <- dat$J
K <- ncol(dat$mus)

### Sensitive priors
### depend on starting values
### Z recovered sometimes
#TODO: Now try AMCMC to recover mus
set.seed(2)
source("../cytof_fixed_K.R", chdir=TRUE)
out <- cytof_fixed_K(y, K=dat$K,
                     burn=20000, B=2000, pr=100, 
                     m_psi=log(2),#mean(dat$mus),
                     cs_tau = .01,
                     cs_psi = .01,
                     cs_sig = .01,
                     cs_mu  = .01,
                     # Fix params:
                     #true_psi=rowMeans(dat$mus),
                     #true_Z=dat$Z,
                     #true_tau2=apply(dat$mus, 1, var),#dat$tau2,
                     #true_sig2=dat$sig2,
                     #true_pi=dat$pi,
                     #true_lam=dat$lam_index_0,
                     #true_W=dat$W,
                     #true_mu=dat$mus,
                     window=300) # do adaptive by making window>0
length(out)

### Z
Z <- lapply(out, function(o) o$Z)
Z_mean <- Reduce("+", Z) / length(Z)
pdf("out/Z.pdf")
my.image(Z_mean, addLegend=T, main="Posterior Mean Z")
my.image(dat$Z, addLegend=T, main="True Z")
dev.off()

### W
W <- lapply(out, function(o) o$W)
W_mean <- Reduce("+", W) / length(W)
sink("out/W.txt")
cat("Posterior Mean W: \n")
W_mean
cat("\nTrue W: \n")
dat$W
sink()

### v 
v <- t(apply(t(sapply(out, function(o) o$v)), 1, cumprod))
colMeans(v)

### psi
psi <- t(sapply(out, function(o) o$psi))
my.pairs(psi[,1:5])
#plotPosts(psi[,1:5])

plot(apply(psi, 2, function(pj) length(unique(pj)) / length(out)),
     ylim=0:1, main="Acceptance rate for psi")
abline(h=c(.25, .4), col='grey')

sink("out/psi.txt")
cat("psi: Posterior Mean, True\n")
cbind(colMeans(psi), rowMeans(dat$mus))
sink()

### sig2
sig2 <- t(sapply(out, function(o) o$sig2))
plotPosts(sig2)
plot(apply(sig2, 2, function(sj) length(unique(sj)) / length(out)),
     ylim=0:1, main="Acceptance rate for sig2")
abline(h=c(.25, .4), col='grey')
sink("out/sig2.txt")
cat("sig2: Posterior Mean, True\n")
cbind( colMeans(sig2), dat$sig2 )
sink()

### tau2
tau2 <- t(sapply(out, function(o) o$tau2))
plotPosts(tau2[,1:5])
my.pairs(tau2[,1:5])
plot(apply(tau2, 2, function(tj) length(unique(tj)) / length(out)),
     ylim=0:1, main="Acceptance rate for tau2")
abline(h=c(.15, .45), col='grey')
cbind(colMeans(tau2), dat$tau2, apply(dat$mus,1,var))

sink("out/tau2.txt")
cat("tau2: Posterior Mean, True\n")
cbind(colMeans(tau2), dat$tau2)
sink()

### lambda
lam <- lapply(out, function(o) o$lam)
unique(sapply(lam, function(l) sapply(l,length)), MAR=2)

lam1 <- sapply(lam, function(l) l[[1]] + 1)
lam2 <- sapply(lam, function(l) l[[2]] + 1)
lam3 <- sapply(lam, function(l) l[[3]] + 1)

rowMeans(lam1) 
dat$lam_index_0[[1]]


### mus
pdf("out/postmus.pdf")
dat$mus
mus_ls <- lapply(out, function(o) o$mus)
mus <- array(unlist(mus_ls), dim=c(J, K, length(out)))
mus_mean <- apply(mus, 1:2, mean)
#exp(dat$mus - mus_mean)
#my.image( exp(dat$mus - mus_mean), addLegend=T)
#my.image(dat$mus - mus_mean, addLegend=T)
## QQ
plot(c(dat$mus), c(mus_mean), col=c(dat$Z) + 3, pch=20, cex=2,
     xlab="mu*_true", ylab="mu* posterior mean", fg='grey',
     main="mu* posterior mean vs truth")
abline(0,1, col='grey')
mus_ci <- apply(mus, 1:2, quantile, c(.025,.975))

### Acceptance Rates
apply(mus, 1:2, function(x) length(unique(x)) / length(out))

plot_mus_post <- function(i,j, main=paste0("mu*[",i,",",j,"]"), ...) {
  MAIN <- main
  plotPost(apply(mus, 3, function(m) m[i,j]), float=TRUE,
           main=MAIN, ...)
  abline(v=dat$mus[i,j], col='grey')
}

plot_mus_post(1,1)
plot_mus_post(1,2)
plot_mus_post(1,3)
plot_mus_post(1,4)
plot_mus_post(2,1)
plot_mus_post(2,2)
plot_mus_post(9,2)

my.image(mus_mean, xlab='', ylab='', mx=1, mn=-1, addLegend=T, main='mu* posterior mean')
my.image(dat$mus,  xlab='', ylab='', mx=1, mn=-1, addLegend=T, main='mu* Truth')
my.image(mus_mean-dat$mus, xlab='', ylab='', mx=1, mn=-1, addLegend=T, main='mu* posterior mean')

hist(mus_mean)
hist(dat$mus)
dev.off()

dat$mus
mus_mean
