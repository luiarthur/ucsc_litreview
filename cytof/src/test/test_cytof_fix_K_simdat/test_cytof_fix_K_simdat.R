args <- commandArgs(trailingOnly=TRUE)
SIM_NUM <- NA

if (length(args) != 1) {
  cat("Usage: Rscript test_cytof_fix_K_simdat.R <sim number [1,2,3]>\n")
  q()
} else {
  SIM_NUM <- as.numeric(args[1])
}

OUTDIR <- paste0("out/sim",SIM_NUM,"/")
system(paste0("mkdir -p ", OUTDIR))
system(paste0("cp test_cytof_fix_K_simdat.R ", OUTDIR, "src.R"))

library(rcommon)
source("../../cytof_fixed_K.R", chdir=TRUE)
source("../../cytof_simdat.R")
source("../../../dat/myimage.R")

last <- function(lst) lst[[length(lst)]]
left_order <- function(Z) {
  order(apply(Z, 2, function(z) paste0(as.character(z), collapse='')), decreasing=TRUE)
}

rowSort <- function(arr) {
  arr[do.call(order, lapply(1:NCOL(arr), function(i) arr[, i])), ]
}

genZ <- function(J,K,prob) {
  Z <- sample(0:1, J*K, replace=TRUE, prob=prob)
  Z <- matrix(Z, J, K, byrow=TRUE)
  Z <- rowSort(Z)
  Z <- Z[, left_order(Z)]

  if (all(rowSums(Z) > 0)) Z else genZ(J,K,prob)
}

set.seed(1) # data gen seed
### DATA GEN ### 
# Baseline data (works)

J1 <- 12
K1 <- 4
I1 <- 3
Z1 <- genZ(J1,K1,c(.6,.4))

dat1 <- cytof_simdat(I=I1, N=list(2000, 3000, 1000), J=J1, K=K1,
                     #a=-1, pi_a=1, pi_b=9,
                     pi_a=1, pi_b=9,
                     tau2=rep(.1,J1),
                     sig2=rep(1,I1),
                     W=matrix(c(.3, .4, .2, .1,
                                .1, .7, .1, .1,
                                .2, .3, .3, .2), I1, K1, byrow=TRUE))

# Increase N_i
dat2 <- cytof_simdat(I=I1, N=list(20000, 30000, 10000), J=J1, K=K1,
                     #a=-1, pi_a=1, pi_b=9,
                     pi_a=1, pi_b=9,
                     tau2=rep(.1,J1),
                     sig2=rep(1,I1),
                     W=matrix(c(.3, .4, .2, .1,
                                .1, .7, .1, .1,
                                .2, .3, .3, .2), I1, K1, byrow=TRUE))

# Increase J from 12 to 16
# J <- 16 (works)
I3 <- 3
J3 <- 32
K3 <- 4 #(works)
Z3 <- genZ(J3,K3,c(.6,.4))

dat3 <- cytof_simdat(I=I, N=list(20000, 30000, 10000), J=J, K=4,
                     #a=-1, pi_a=1, pi_b=9,
                     pi_a=1, pi_b=9,
                     tau2=rep(.1,J),
                     sig2=rep(1,I),
                     W=matrix(c(.3, .4, .2, .1,
                                .1, .7, .1, .1,
                                .2, .3, .3, .2), I, K, byrow=TRUE))

### END DATA GEN ### 
dat <- if(SIM_NUM==3) {
  dat3 
} else if(SIM_NUM==2) {
  dat2
} else if(SIM_NUM==1) {
  dat1
} else {
  stop("SIM_NUM not in range!")
}
#print(SIM_NUM)
#print(dat)


### PLOT DATA
pdf(paste0(OUTDIR, "data.pdf"))
hist(dat$mus)

hist(dat$y[[1]][,1])
hist(dat$y[[2]][,2])
hist(dat$y[[1]][,3])
hist(dat$y[[1]][,7])

par(mfrow=c(3,1))
hist(colMeans(dat$y[[1]]), col=rgb(1,0,0, .4), prob=TRUE, xlim=c(0, 3), border='white')
hist(colMeans(dat$y[[2]]), col=rgb(0,1,0, .4), prob=TRUE, xlim=c(0, 3), border='white')
hist(colMeans(dat$y[[3]]), col=rgb(0,0,1, .4), prob=TRUE, xlim=c(0, 3), border='white')
par(mfrow=c(1,1))

yj_mean <- rbind(apply(dat$y[[1]], 2, mean),
                 apply(dat$y[[2]], 2, mean),
                 apply(dat$y[[3]], 2, mean))

redToBlue <- colorRampPalette(c('red','grey90','blue'))(12)
my.image(cor(dat$y[[1]]), xaxt='n',yaxt='n',xlab="",ylab="", col=redToBlue,
         main="y1 Correlation b/w Markers",addLegend=TRUE, mn=-1,mx=1)
my.image(cor(dat$y[[2]]), xaxt='n',yaxt='n',xlab="",ylab="", col=redToBlue,
         main="y2 Correlation b/w Markers",addLegend=TRUE, mn=-1,mx=1)
my.image(cor(dat$y[[3]]), xaxt='n',yaxt='n',xlab="",ylab="", col=redToBlue,
         main="y3 Correlation b/w Markers",addLegend=TRUE, mn=-1,mx=1)
my.image(dat$Z, ylab="markers", xlab="latent features", main="Z Truth")

### Plot Data Directly
my.image(dat$y[[1]], addLegend=T, mn=0, mx=6, xlab="markers", ylab="samples", main="y1")
my.image(dat$y[[2]], addLegend=T, mn=0, mx=6, xlab="markers", ylab="samples", main="y2")
my.image(dat$y[[3]], addLegend=T, mn=0, mx=6, xlab="markers", ylab="samples", main="y3")
dev.off()

### Percentage of zeros (sparsity)
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
### TODO: Compute loglike every 100 iterations?
### TODO: Joint update mus (it's a big parameter)
#         use this as covariance matrix after burn: cov(t(apply(mus, 3, c)))
#         (2.4^2 / d) * (cov + eps*I_d), where d = 48 = J x K

set.seed(1) # posterior sim seed. good: 1,2. ok: 10, 100,. Bad:
source("../../cytof_fixed_K.R", chdir=TRUE)
#sim_time <- system.time(
##out <- cytof_fixed_K(y, K=5,#dat$K,
#out <- cytof_fixed_K(y, K=dat$K,
#                     burn=1000000, B=2000, pr=100, 
#                     #burn=0, B=100, pr=100, 
#                     #burn=10000, B=2000, pr=100, 
#                     m_psi=log(2),#mean(dat$mus),
#                     #cs_psi = .01, #ok
#                     #cs_tau = .01, #ok
#                     #cs_psi = 1,   bad 
#                     #cs_tau = 1,   bad
#                     cs_psi = .01, #better
#                     cs_tau = .01, #better
#                     cs_sig = .1,
#                     cs_mu  = .1,
#                     cs_c = .1, cs_d = .1,
#                     cs_v = .1, cs_h = .1,
#                     # Fix params:
#                     #true_psi=apply(yj_mean, 2, mean), # doesn't work when n large
#                     #true_psi=rep(log(2), J),
#                     #true_tau2=rep(2, J),
#                     #true_psi=rowMeans(dat$mus),
#                     #true_tau2=apply(dat$mus, 1, var),#dat$tau2,
#                     #
#                     #true_Z=dat$Z,
#                     #true_sig2=dat$sig2,
#                     #true_pi=dat$pi,
#                     #true_lam=dat$lam_index_0,
#                     #true_W=dat$W,
#                     #true_mu=dat$mus,
#                     #
#                     #G=cov(dat$y[[2]]),
#                     #window=300) # do adaptive by making window>0. Broken right now.
#                     window=0) # do adaptive by making window>0
#)
sim_time <- system.time(
out <- cytof_fixed_K(y, K=dat$K,
                     burn=500000, B=2000, pr=100, 
                     m_psi=log(2),
                     cs_psi = .01,
                     #cs_psi = 1,
                     cs_tau = .01,
                     cs_sig = .01,
                     cs_mu  = .01,
                     cs_c = .01, cs_d = .01,
                     #cs_v = .01, cs_h = .01,
                     cs_v = 1, cs_h = 1,
                     window=0) # do adaptive by making window>0
)
length(out)

print(sim_time) # per 100 iterations: 1 thread: 18s, 3 threads: 11s 

### Z
Z <- lapply(out, function(o) o$Z)
Z_mean <- Reduce("+", Z) / length(Z)
ord <- left_order(round(Z_mean))
pdf(paste0(OUTDIR, "Z.pdf"))
my.image(Z_mean[,ord], addLegend=T, main="Posterior Mean Z")
my.image(dat$Z, addLegend=T, main="True Z")
dev.off()

### W
W <- lapply(out, function(o) o$W)
W_mean <- Reduce("+", W) / length(W)
sink(paste0(OUTDIR, "W.txt"))
cat("Posterior Mean W: \n")
print(W_mean[,ord])
cat("\nTrue W: \n")
print(dat$W)
sink()

### v 
v <- t(apply(t(sapply(out, function(o) o$v)), 1, cumprod))
colMeans(v)

### sig2
sig2 <- t(sapply(out, function(o) o$sig2))
#plotPosts(sig2)
#plot(apply(sig2, 2, function(sj) length(unique(sj)) / length(out)),
#     ylim=0:1, main="Acceptance rate for sig2")
#abline(h=c(.25, .4), col='grey')
sink(paste0(OUTDIR, "sig2.txt"))
cat("sig2: Posterior Mean, True\n")
print(cbind( colMeans(sig2), dat$sig2 ))
sink()

### psi
psi <- t(sapply(out, function(o) o$psi))
#my.pairs(psi[,1:5])
#plotPosts(psi[,1:5])
#
#plot(apply(psi, 2, function(pj) length(unique(pj)) / length(out)),
#     ylim=0:1, main="Acceptance rate for psi")
#abline(h=c(.25, .4), col='grey')

sink(paste0(OUTDIR, "psi.txt"))
cat("psi: Posterior Mean, True\n")
print(cbind(colMeans(psi), rowMeans(dat$mus)))
sink()

### tau2
tau2 <- t(sapply(out, function(o) o$tau2))
#plotPosts(tau2[,1:5])
#my.pairs(tau2[,1:5])
#plot(apply(tau2, 2, function(tj) length(unique(tj)) / length(out)),
#     ylim=0:1, main="Acceptance rate for tau2")
#abline(h=c(.15, .45), col='grey')
cbind(colMeans(tau2), dat$tau2, apply(dat$mus,1,var))

sink(paste0(OUTDIR, "tau2.txt"))
cat("tau2: Posterior Mean, True\n")
print(cbind(colMeans(tau2), dat$tau2))
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
pdf(paste0(OUTDIR, "postmus.pdf"))
dat$mus
mus_ls <- lapply(out, function(o) o$mus)
mus <- array(unlist(mus_ls), dim=c(J, K, length(out)))

### Correlation of mus
cor(t(apply(mus, 3, c)))

mus_mean <- apply(mus, 1:2, mean)
#exp(dat$mus - mus_mean)
#my.image( exp(dat$mus - mus_mean), addLegend=T)
#my.image(dat$mus - mus_mean, addLegend=T)

## Post pred mean vs Truth
mus_ci_lo <- apply(mus, 1:2, quantile, .025)[,ord]
mus_ci_up <- apply(mus, 1:2, quantile, .975)[,ord]
mus_ci <- cbind(c(mus_ci_lo), c(mus_ci_up))
plot(c(dat$mus), c(mus_mean[,ord]), col=c(dat$Z) + 3, pch=20, cex=2,
     xlab="mu*_true", ylab="mu* posterior mean", fg='grey',
     ylim=range(mus_ci),
     main="mu* posterior mean vs truth")
abline(0,1, col='grey')
add.errbar(mus_ci, x=c(dat$mus), col=c(dat$Z) + 3, lty=2, lwd=.5)

### Acceptance Rates
apply(mus, 1:2, function(x) length(unique(x)) / length(out))

plot_mus_post <- function(i,j, main=paste0("mu*[",i,",",j,"]"), ...) {
  MAIN <- main
  plotPost(apply(mus, 3, function(m) m[i,ord[j]]), float=TRUE,
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

mx = round(log(2) + 2,2)
mn = round(log(2) - 2,2)
my.image(mus_mean[,ord], xlab='', ylab='', mx=mx, mn=mn, addLegend=T, main='mu* posterior mean', col=redToBlue)
my.image(dat$mus,  xlab='', ylab='', mx=mx, mn=mn, addLegend=T, main='mu* Truth', col=redToBlue)
my.image(mus_mean[,ord]-dat$mus, xlab='', ylab='', mx=2, mn=-2, addLegend=T, main='mu* posterior mean resids', col=redToBlue)

hist(mus_mean[,ord], xlim=range(c(mus_mean, dat$mus)), prob=TRUE,
     col=rgb(0,0,1,.3), border='white', main='Histogram of mu*')
hist(dat$mus, xlim=range(c(mus_mean, dat$mus)), prob=TRUE, add=TRUE,
     col=rgb(1,0,0,.3), border='white')
legend('topright', col=c('blue','red'), legend=c('mu* (Post)','mu* (True)'), 
       pch=20, cex=2)

dev.off()

dat$mus
mus_mean[,ord]

### Pi
post_pi <- array(unlist(lapply(out, function(o) o$pi)), dim=c(I,J,length(out)))

my.image( pi_mean <- apply(post_pi, 1:2, mean), addLegend=TRUE)
my.image( dat$pi_var, addLegend=TRUE )

sink(paste0(OUTDIR, "pi.txt"))
cat("Posterior Mean pi: \n")
print(pi_mean)
cat("\nTrue pi: \n")
print(dat$pi_var)
sink()

# Compare Data to Posterior Predictive:
sim_post_pred <- function(post) {
  B <- length(post)
  Y <- rep(list(matrix(NA, B, J)), I)

  for (n in 1:B) {
    for (i in 1:I) {
      sig_i <- sqrt(post[[n]]$sig2[i])
      lin <- sample(1:K, 1, prob=post[[n]]$W[i,])
      for (j in 1:J) {
        if (post[[n]]$Z[j,lin] == 1) {
          Y[[i]][n,j] <- rtruncnorm(1, 0, Inf, post[[n]]$mus[j,lin], sig_i)
        } else {
          Y[[i]][n,j] <- ifelse(post[[n]]$pi[i,j] > runif(1), 0, rtruncnorm(1, 0, Inf, post[[n]]$mus[j,lin], sig_i))
        }
      }
    }
  }

  return(Y)
}

post_pred <- sim_post_pred(out)

### Posterior Predictive Correlations
my.image(cor(post_pred[[1]]), xaxt='n',yaxt='n',xlab="",ylab="",col=redToBlue,
         main="y1 Correlation b/w Markers",addLegend=TRUE, mn=-1,mx=1)
my.image(cor(dat$y[[1]]), xaxt='n',yaxt='n',xlab="",ylab="", col=redToBlue,
         main="y1 Correlation b/w Markers",addLegend=TRUE, mn=-1,mx=1)

my.image(cor(post_pred[[2]]), xaxt='n',yaxt='n',xlab="",ylab="", col=redToBlue,
         main="y2 Correlation b/w Markers",addLegend=TRUE, mn=-1,mx=1)
my.image(cor(dat$y[[2]]), xaxt='n',yaxt='n',xlab="",ylab="",col=redToBlue,
         main="y1 Correlation b/w Markers",addLegend=TRUE,mn=-1,mx=1)

my.image(cor(post_pred[[3]]), xaxt='n',yaxt='n',xlab="",ylab="", col=redToBlue,
         main="y3 Correlation b/w Markers",addLegend=TRUE,mn=-1,mx=1)
my.image(cor(dat$y[[3]]), xaxt='n',yaxt='n',xlab="",ylab="", col=redToBlue,
         main="y1 Correlation b/w Markers",addLegend=TRUE,mn=-1,mx=1)

### Hist of post pred

par(mfrow=c(3,1))
hist(post_pred[[1]], prob=TRUE, col=rgb(0,0,1,.3), border='white')
hist(dat$y[[1]], prob=TRUE, add=TRUE, col=rgb(1,0,0,.3), border='white')

hist(post_pred[[2]], prob=TRUE, col=rgb(0,0,1,.3), border='white')
hist(dat$y[[2]], prob=TRUE, add=TRUE, col=rgb(1,0,0,.3), border='white')

hist(post_pred[[3]], prob=TRUE, col=rgb(0,0,1,.3), border='white')
hist(dat$y[[3]], prob=TRUE, add=TRUE, col=rgb(1,0,0,.3), border='white')
par(mfrow=c(1,1))


### Residual of Correlations
my.image(cor(post_pred[[3]]) - cor(dat$y[[3]]), xaxt='n',yaxt='n',xlab="",ylab="",
         main="y3 Correlation b/w Markers",addLegend=TRUE, mn=-1,mx=1, col=redToBlue)

### Posterior Predictive Proportion of 0's
mean(post_pred[[1]] == 0); mean(dat$y[[1]] == 0); 
mean(post_pred[[2]] == 0); mean(dat$y[[2]] == 0); 
mean(post_pred[[3]] == 0); mean(dat$y[[3]] == 0); 

#source("test_cytof_fix_K_simdat.R")

### QQ Plot
par(mfrow=c(3,1))
plot(quantile(dat$y[[1]],seq(0,1,len=100)), quantile(post_pred[[1]],seq(0,1,len=100)), pch=20, col='red', ylab='post quantile 1'); abline(0,1,col='grey')
plot(quantile(dat$y[[2]],seq(0,1,len=100)), quantile(post_pred[[2]],seq(0,1,len=100)), pch=20, col='red', ylab='post quantile 2'); abline(0,1,col='grey')
plot(quantile(dat$y[[3]],seq(0,1,len=100)), quantile(post_pred[[3]],seq(0,1,len=100)), pch=20, col='red', ylab='post quantile 3'); abline(0,1,col='grey')
par(mfrow=c(1,1))

save.image(paste0(OUTDIR, "results.RData"))
