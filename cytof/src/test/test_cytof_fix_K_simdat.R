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
dat <- cytof_simdat(I=3, N=list(200, 300, 100), J=12, K=4,
                    a=1, pi_a=1, pi_b=9,
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
mean(dat$y[[2]] == 0)
mean(dat$y[[3]] == 0)

### Compute
y <- dat$y
I <- dat$I
J <- dat$J
K <- ncol(dat$mus)

### Sensitive priors
### depend on starting values
### Z recovered sometimes
#TODO: Now try AMCMC to recover mus. cand_sig2 = (2.4^2 / d) * cov(X + 1E-6)

### TODO: Changed delta_0 function. See if it works. Need to log?
### TODO: logSumExp?

set.seed(2)
source("../cytof_fixed_K.R", chdir=TRUE)
# Current settings work when delta_0 is defined as: x == 0 ? 1 : 0
# NOW TRYING delta_0 = x == 0 ? 1E6 : 0
system.time(
out <- cytof_fixed_K(y, K=dat$K,
                     #burn=20000, B=2000, pr=100, 
                     burn=10000, B=2000, pr=100, 
                     m_psi=log(2),#mean(dat$mus),
                     cs_psi = .01,
                     cs_tau = .01,
                     cs_sig = .01,
                     cs_mu  = .01,
                     cs_c = .1, cs_d = .1,
                     cs_v = .1, cs_h = .1,
                     # Fix params:
                     #true_psi=rowMeans(dat$mus),
                     #true_Z=dat$Z,
                     #true_tau2=apply(dat$mus, 1, var),#dat$tau2,
                     #true_sig2=dat$sig2,
                     #true_pi=dat$pi,
                     #true_lam=dat$lam_index_0,
                     #true_W=dat$W,
                     #true_mu=dat$mus,
                     #window=300) # do adaptive by making window>0
                     window=0) # do adaptive by making window>0
)
length(out)

ord <- c(4,2,3,1)
### Z
Z <- lapply(out, function(o) o$Z)
Z_mean <- Reduce("+", Z) / length(Z)
pdf("out/Z.pdf")
my.image(Z_mean[,ord], addLegend=T, main="Posterior Mean Z")
my.image(dat$Z, addLegend=T, main="True Z")
dev.off()

### W
W <- lapply(out, function(o) o$W)
W_mean <- Reduce("+", W) / length(W)
sink("out/W.txt")
cat("Posterior Mean W: \n")
W_mean[,ord]
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

my.image(mus_mean[,ord], xlab='', ylab='', mx=1, mn=-1, addLegend=T, main='mu* posterior mean')
my.image(dat$mus,  xlab='', ylab='', mx=1, mn=-1, addLegend=T, main='mu* Truth')
my.image(mus_mean[,ord]-dat$mus, xlab='', ylab='', mx=1, mn=-1, addLegend=T, main='mu* posterior mean')

hist(mus_mean[,ord], xlim=range(c(mus_mean, dat$mus)), prob=TRUE,
     col=rgb(0,0,1,.3), border='white', main='Histogram of mu*')
hist(dat$mus, xlim=range(c(mus_mean, dat$mus)), prob=TRUE, add=TRUE,
     col=rgb(1,0,0,.3), border='white')
legend('topright', col=c('blue','red'), legend=c('mu* (True)','mu* (Post)'), 
       pch=20, cex=2)

dev.off()

dat$mus
mus_mean[,ord]

### Pi
post_pi <- array(unlist(lapply(out, function(o) o$pi)), dim=c(I,J,length(out)))

my.image( apply(post_pi, 1:2, mean), addLegend=TRUE)
my.image( dat$pi_var, addLegend=TRUE )

# Compare Data to Posterior Predictive:
one_post_pred <- function(param) {
  Y <- dat$y
  for (i in 1:I) {
    sig_i <- sqrt(param$sig2[i])
    for (n in 1:dat$N[[i]]) {
      lin <- param$lam[[i]][n] + 1
      for (j in 1:J) {
        Y[[i]][n,j] <- ifelse(param$pi[i,j] > runif(1), 0, rtruncnorm(1, 0, Inf, param$mus[j,lin], sig_i))
      }
    }
  }
  return(Y)
}

join <- function(pp) {
  B <- length(pp)
  out <- as.list(1:I)
  for (i in 1:I) {
    out[[i]] <- Reduce("+", lapply(pp, function(f) f[[i]])) / B
  }
  out
}

system.time(post_pred <- join(lapply(tail(out,1000), one_post_pred)))
#post_pred <- one_post_pred(last(out))

my.image(cor(post_pred[[1]]), xaxt='n',yaxt='n',xlab="",ylab="",
         main="y1 Correlation b/w Markers",addLegend=TRUE)
my.image(cor(post_pred[[2]]), xaxt='n',yaxt='n',xlab="",ylab="",
         main="y2 Correlation b/w Markers",addLegend=TRUE)
my.image(cor(post_pred[[3]]), xaxt='n',yaxt='n',xlab="",ylab="",
         main="y3 Correlation b/w Markers",addLegend=TRUE)
mean(post_pred[[1]] == 0)

#source("test_cytof_fix_K_simdat.R")

par(mfrow=c(3,1))
plot(quantile(dat$y[[1]],seq(0,1,len=10)), quantile(post_pred[[1]],seq(0,1,len=10)), pch=20, col=rgb(0,0,1,.1)); abline(0,1,col='grey') 
plot(quantile(dat$y[[2]],seq(0,1,len=10)), quantile(post_pred[[2]],seq(0,1,len=10)), pch=20, col=rgb(0,0,1,.1)); abline(0,1,col='grey') 
plot(quantile(dat$y[[3]],seq(0,1,len=10)), quantile(post_pred[[3]],seq(0,1,len=10)), pch=20, col=rgb(0,0,1,.1)); abline(0,1,col='grey') 
par(mfrow=c(1,1))
