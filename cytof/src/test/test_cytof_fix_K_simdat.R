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

set.seed(3)
dat <- cytof_simdat(I=3, N=list(200, 300, 100), J=12, K=4,
                    psi=rnorm(12, 5, 1),
                    tau2=rep(.1,12), sig2=rep(1,3),
                    W=matrix(c(.3, .4, .2, .1,
                               .1, .7, .1, .1,
                               .2, .3, .3, .2), 3, 4, byrow=TRUE))

### PLOT DATA
pdf("out/data.pdf")
my.image(cor(dat$y[[1]]), xaxt='n',yaxt='n',xlab="",ylab="",
         main="y1 Correlation b/w Markers",addLegend=TRUE)
my.image(cor(dat$y[[2]]), xaxt='n',yaxt='n',xlab="",ylab="",
         main="y2 Correlation b/w Markers",addLegend=TRUE)
my.image(cor(dat$y[[3]]), xaxt='n',yaxt='n',xlab="",ylab="",
         main="y3 Correlation b/w Markers",addLegend=TRUE)
dev.off()
my.image(dat$Z)
mean(dat$y[[1]] == 0)

### Compute
y <- dat$y
I <- dat$I
J <- dat$J


source("../cytof_fixed_K.R", chdir=TRUE)
set.seed(2)

### Sensitive priors
### depend on starting values
### Z recovered sometimes
burn <- cytof_fixed_K(y, K=dat$K,
                      burn=1000, B=1000, pr=10, 
                      b_sig=dat$sig2[1], b_tau=dat$tau2[1],
                      cs_psi=1,
                      cs_sig2=1,
                      cs_tau2=1,
                      window=1000)
out <- tail(burn, 1000)

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
v <- t(sapply(out, function(o) o$v))
colMeans(v)

### psi
psi <- t(sapply(out, function(o) o$psi))
my.pairs(psi[,1:5])
plotPosts(psi[,1:5])

plot(apply(psi, 2, function(pj) length(unique(pj)) / length(out)),
     ylim=0:1, main="Acceptance rate for psi")
abline(h=c(.25, .4), col='grey')

sink("out/phi.txt")
cat("phi: Posterior Mean, True\n")
cbind(colMeans(psi), dat$psi)
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
abline(h=c(.25, .4), col='grey')
cbind(colMeans(tau2), dat$tau2)

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
dat$lam[[1]]


### mus
dat$mus
mus <- lapply(out, function(o) o$mus)
mus_mean <- Reduce("+", mus) / length(mus)

plotPost(sapply(mus, function(m) m[1,1]))
plotPost(sapply(mus, function(m) m[1,2]))
plotPost(sapply(mus, function(m) m[1,3]))
plotPost(sapply(mus, function(m) m[1,4]))
