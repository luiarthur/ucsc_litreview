args <- commandArgs(trailingOnly=TRUE)
SIM_NUM <- NA
SIM_K_OFFSET <- 0
#SIM_a = 0.5 # doable
SIM_a = .2
SIM_sig2 = .2

largs <- length(args)

fquit <- function(e) {
    cat("Wrong Input")
    q()
}

if (largs < 1 || largs > 2) {
  cat("Usage: Rscript test_cytof_fix_K_simdat.R <sim number [1,2,3]> [SIM_K_OFFSET=0] \n")
  q()
} else if (largs == 1) {
  SIM_NUM <- as.numeric(args[1])
} else if (largs == 2) {
  tryCatch({
    SIM_NUM <- as.numeric(args[1])
    SIM_K_OFFSET <- as.numeric(args[2])
  }, error=fquit, warning=fquit)
}


#ROOT_DIR <- "out/sim"
#ROOT_DIR <- "out/sim_bigBurn"
#ROOT_DIR <- "out/sim_fixedPsi"
#ROOT_DIR <- paste0("out/fixedPsi_WrongK", SIM_K_OFFSET, "_sim")
#ROOT_DIR <- paste0("out/a0.5_newProposal_fixedZ_fixedPsi_WrongK", SIM_K_OFFSET, "_sim")
ROOT_DIR <- paste0("out/a1_newProposal_fixedPsi_WrongK", SIM_K_OFFSET, "_sim")

OUTDIR <- paste0(ROOT_DIR, SIM_NUM,"/")
system(paste0("mkdir -p ", OUTDIR))
system(paste0("cp test_cytof_fix_K_simdat.R ", OUTDIR, "src.R"))

library(rcommon)
source("../../cytof_fixed_K.R", chdir=TRUE)
source("../../cytof_simdat.R")
source("../../../dat/myimage.R")
source("est_Z.R")

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

dat0 <- function() {
  cytof_simdat(I=I1, N=list(200, 300, 100), J=J1, K=K1,
               #a=-1, pi_a=1, pi_b=9,
               #mus_lo=0,
               a=SIM_a,
               mus_lo=0,
               mus_hi=Inf,
               pi_a=1, pi_b=9,
               tau2=rep(.1,J1),
               sig2=rep(SIM_sig2,I1),
               Z=Z1,
               W=matrix(c(.3, .4, .2, .1,
                          .1, .7, .1, .1,
                          .2, .3, .3, .2), I1, K1, byrow=TRUE))
}

dat1 <- function() {
  cytof_simdat(I=I1, N=list(2000, 3000, 1000), J=J1, K=K1,
               #a=-1, pi_a=1, pi_b=9,
               #mus_lo=0,
               a=SIM_a,
               mus_lo=0,
               mus_hi=Inf,
               pi_a=1, pi_b=9,
               tau2=rep(.1,J1),
               sig2=rep(SIM_sig2,I1),
               Z=Z1,
               W=matrix(c(.3, .4, .2, .1,
                          .1, .7, .1, .1,
                          .2, .3, .3, .2), I1, K1, byrow=TRUE))
}

# Increase N_i
dat2 <- function() {
  cytof_simdat(I=I1, N=list(20000, 30000, 10000), J=J1, K=K1,
               #a=-1, pi_a=1, pi_b=9,
               #mus_lo=0,
               a=SIM_a,
               mus_lo=0,
               mus_hi=Inf,
               pi_a=1, pi_b=9,
               tau2=rep(.1,J1),
               sig2=rep(SIM_sig2,I1),
               Z=Z1,
               W=matrix(c(.3, .4, .2, .1,
                          .1, .7, .1, .1,
                          .2, .3, .3, .2), I1, K1, byrow=TRUE))
}

# Increase J from 12 to 16
# J <- 16 (works)
I3 <- 3
J3 <- 32
K3 <- 4 #(works)
Z3 <- genZ(J3,K3,c(.6,.4))

dat3 <- function() {
  cytof_simdat(I=I3, N=list(20000, 30000, 10000), J=J3, K=K3,
               #a=-1, pi_a=1, pi_b=9,
               #mus_lo=0,
               a=SIM_a,
               mus_lo=0,
               mus_hi=Inf,
               pi_a=1, pi_b=9,
               tau2=rep(.1,J3),
               sig2=rep(SIM_sig2,I3),
               Z=Z3,
               W=matrix(c(.3, .4, .2, .1,
                          .1, .7, .1, .1,
                          .2, .3, .3, .2), I3, K3, byrow=TRUE))
}

I4 <- 3
J4 <- 40
K4 <- 4 #(works)
Z4 <- genZ(J4,K4,c(.6,.4))

dat4 <- function() {
  cytof_simdat(I=I4, N=list(20000, 30000, 10000), J=J4, K=K4,
               #a=-1, pi_a=1, pi_b=9,
               #mus_lo=0,
               a=SIM_a,
               mus_lo=0,
               mus_hi=Inf,
               pi_a=1, pi_b=9,
               tau2=rep(.1,J4),
               sig2=rep(SIM_sig2,I4),
               Z=Z4,
               W=matrix(c(.3, .4, .2, .1,
                          .1, .7, .1, .1,
                          .2, .3, .3, .2), I4, K4, byrow=TRUE))

}

K5 <- 6
Z5 <- genZ(J4,K5,c(.6,.4))
dat5 <- function() {
  cytof_simdat(I=I4, N=list(20000, 30000, 10000), J=J4, K=K5,
               #a=-1, pi_a=1, pi_b=9,
               #mus_lo=0,
               a=SIM_a,
               mus_lo=0,
               mus_hi=Inf,
               pi_a=1, pi_b=9,
               tau2=rep(.1,J4),
               sig2=rep(SIM_sig2,I4),
               Z=Z5,
               W=matrix(c(.3, .3, .1, .1, .1, .1,
                          .1, .4, .1, .1, .2, .1,
                          .2, .1, .3, .2, .1, .1), I4, K5, byrow=TRUE))

}


### END DATA GEN ### 
dat <- if(SIM_NUM==3) {
  dat3()
} else if(SIM_NUM==2) {
  dat2()
} else if(SIM_NUM==1) {
  dat1()
} else if(SIM_NUM==4) {
  dat4()
} else if(SIM_NUM==5) {
  dat5()
} else if(SIM_NUM==0) {
  dat0()
} else {
  stop("SIM_NUM not in range!")
}
#print(SIM_NUM)
#print(dat)

rgba <- function(x, alpha=1) {
  if (x==1) {
    rgb(1,0,0,alpha)
  } else if (x==2) {
    rgb(0,1,0,alpha)
  } else {
    rgb(0,0,1,alpha)
  }
}

### PLOT DATA
pdf(paste0(OUTDIR, "data.pdf"))
hist(dat$mus)

### Plot Y
par(mfrow=c(3,2))
for (i in 1:dat$I) {
  yi <- dat$y[[i]]
  k <- dat$lam[[i]]
  z <- dat$Z
  for (j in 1:dat$J) {
    # y such that z = 0
    n0 <- which(z[j,k]==0)
    y0 <- yi[n0, j]
    # y such that z = 1
    n1 <- which(z[j,k]==1)
    y1 <- yi[which(z[j,k]==1), j]
    hist(yi[,j], prob=FALSE, xlab=paste0("Y (i=",i,",j=",j,")"),
         main=paste0("Histogram of Y (i=",i,",j=",j,")"), border='white',
         col=rgba(3, .2))
    if (length(n0) > 0) {
      hist(y0, prob=FALSE, border='white', col=rgba(1, .4), add=TRUE)
    } else print("n0 == 0")
    if (length(n1) > 0) {
      hist(y1, prob=FALSE, border='white', col=rgba(2, .5), add=TRUE)
    } else print("n1 == 0")
    legend('topright', text.col=c('blue', 'red','chartreuse3'), 
           legend=c('all', 'z=0','z=1'), bty='n', text.font=2, cex=2)
  }
}
par(mfrow=c(1,1))



par(mfrow=c(3,1))
for (i in 1:3) {
  hist(colMeans(dat$y[[i]]), col=rgba(i, .4), prob=TRUE, xlim=c(0, 3), 
       border='white')
}
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
dev.off()

### Plot Data Directly
png(paste0(OUTDIR, "dataY%03d.png"))
my.image(dat$y[[1]], addLegend=T, mn=0, mx=6, xlab="markers", ylab="samples", main="y1")
my.image(dat$y[[2]], addLegend=T, mn=0, mx=6, xlab="markers", ylab="samples", main="y2")
my.image(dat$y[[3]], addLegend=T, mn=0, mx=6, xlab="markers", ylab="samples", main="y3")
dev.off()

### Percentage of zeros (sparsity)
#mean(dat$y[[1]] == 0)
#mean(dat$y[[2]] == 0)
#mean(dat$y[[3]] == 0)

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

### Print simulation info
sink(paste0(OUTDIR, "info.txt"))
  cat("I: ", dat$I, "\n")
  cat("J: ", dat$J, "\n")
  cat("K: ", dat$K, "\n")
  cat("N: ", paste0("(",paste(unlist(dat$N),collapse=', '),")"), "\n")
  cat("K in simulation: ", dat$K+SIM_K_OFFSET, "\n")
sink()

sim_time <- system.time(
out <- cytof_fixed_K(y, K=dat$K+SIM_K_OFFSET,
                     #burn=20000, B=2000, pr=100, 
                     burn=10000, B=2000, pr=100, 
                     #burn=1000, B=1000, pr=100, 
                     m_psi=log(2),
                     true_psi=rep(log(2),J),
                     #true_Z=extend_Z(dat$Z, dat$K+SIM_K_OFFSET),
                     cs_tau = .01,
                     cs_sig = .01,
                     cs_mu  = .01,
                     cs_c = .01, cs_d = .01,
                     #cs_v = 1, cs_h = 1, cs_hj = 0.1, # this is always bad
                     cs_v = .1, cs_h = .1, cs_hj = .01,
                     compute_loglike_every=100,
                     window=0) # do adaptive by making window>0
)
save.image(paste0(OUTDIR, "results.RData"))

### Print Timings
sink(paste0(OUTDIR, "timing.txt"))
  print(sim_time)
sink()


### loglike
ll <- sapply(out, function(o) o$ll)
pdf(paste0(OUTDIR, "ll.pdf"))
  plot(ll, main='log-likelihood', 
       xlab='mcmc iteration', ylab='log-likelihood', type='l')
dev.off()

### Z
Z <- lapply(out, function(o) o$Z)
Z_mean <- Reduce("+", Z) / length(Z)
ord <- left_order(round(Z_mean))
pdf(paste0(OUTDIR, "Z.pdf"))
my.image(Z_mean[,ord], addLegend=T, main="Posterior Mean Z")
my.image(dat$Z, addLegend=T, main="True Z")
## Takes too long... Implement in C?
#Z_est <- est_Z(Z)
#my.image(Z_est, addLegend=T, main="Point Est. for Z")
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
sink(paste0(OUTDIR, "v.txt"))
cat("v: posterior column means:\n")
print(colMeans(v))
cat("v: posterior column means (left-ordered):\n")
print(colMeans(v)[ord])
sink()

### H
#H_ls <- lapply(out, function(o) o$H)
#H_post <- array(unlist(H_ls), dim=c(J, NCOL(Z_mean), length(out)))
#H_mean <- apply(H_post, 1:2, mean)
#H_ci_lo <- apply(H_post, 1:2, quantile, .025)
#H_ci_up <- apply(H_post, 1:2, quantile, .975)
#H_ci <- cbind(c(H_ci_lo), c(H_ci_up))
#pdf(paste0(OUTDIR, "v.pdf"))
#my.image(H_mean, xlab='', ylab='', mx=max(H_ci), mn=min(H_ci), addLegend=T, main='H posterior mean', col=redToBlue)
#dev.off()


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
#cbind(colMeans(tau2), dat$tau2, apply(dat$mus,1,var))

sink(paste0(OUTDIR, "tau2.txt"))
  cat("tau2: Posterior Mean, True\n")
  print(cbind(colMeans(tau2), dat$tau2))
sink()

### lambda
lam <- lapply(out, function(o) o$lam)
#unique(sapply(lam, function(l) sapply(l,length)), MAR=2)

lam1 <- sapply(lam, function(l) l[[1]] + 1)
lam2 <- sapply(lam, function(l) l[[2]] + 1)
lam3 <- sapply(lam, function(l) l[[3]] + 1)

#rowMeans(lam1) 
#dat$lam_index_0[[1]]


### mus
pdf(paste0(OUTDIR, "postmus.pdf"))
#dat$mus
mus_ls <- lapply(out, function(o) o$mus)
mus <- array(unlist(mus_ls), dim=c(J, NCOL(Z_mean), length(out)))

### Correlation of mus
#cor(t(apply(mus, 3, c)))

mus_mean <- apply(mus, 1:2, mean)
#exp(dat$mus - mus_mean)
#my.image( exp(dat$mus - mus_mean), addLegend=T)
#my.image(dat$mus - mus_mean, addLegend=T)

## Post pred mean vs Truth
#print(dim(mus_mean))
#print(dim(Z_mean))
#print(length(ord))
#cat("\n")

mus_ci_lo <- apply(mus, 1:2, quantile, .025)[,ord]
mus_ci_up <- apply(mus, 1:2, quantile, .975)[,ord]
mus_ci <- cbind(c(mus_ci_lo), c(mus_ci_up))

### Plot only if same dimensions
#cat("K: ", dat$K, "; ", "NCOL(Z_mean): ", NCOL(Z_mean), "\n")
if (dat$K == NCOL(Z_mean)) {
  plot(c(dat$mus), c(mus_mean[,ord]), col=c(dat$Z) + 3, pch=20, cex=2,
       xlab="mu*_true", ylab="mu* posterior mean", fg='grey',
       ylim=range(mus_ci),
       main="mu* posterior mean vs truth")
  abline(0,1, col='grey')
  add.errbar(mus_ci, x=c(dat$mus), col=c(dat$Z) + 3, lty=2, lwd=.5)
}

### Acceptance Rates
#apply(mus, 1:2, function(x) length(unique(x)) / length(out))

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

if (NCOL(mus_mean) == NCOL(dat$mus)) {
  my.image(mus_mean[,ord]-dat$mus, xlab='', ylab='', mx=2, mn=-2, addLegend=T, main='mu* posterior mean resids', col=redToBlue)
}

hist(mus_mean[,ord], xlim=range(c(mus_mean, dat$mus)), prob=TRUE,
     col=rgb(0,0,1,.3), border='white', main='Histogram of mu*')
hist(dat$mus, xlim=range(c(mus_mean, dat$mus)), prob=TRUE, add=TRUE,
     col=rgb(1,0,0,.3), border='white')
legend('topright', col=c('blue','red'), legend=c('mu* (Post)','mu* (True)'), 
       pch=20, cex=2)

dev.off()

#dat$mus
#mus_mean[,ord]

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
  K <- NCOL(Z_mean)

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
#mean(post_pred[[1]] == 0); mean(dat$y[[1]] == 0); 
#mean(post_pred[[2]] == 0); mean(dat$y[[2]] == 0); 
#mean(post_pred[[3]] == 0); mean(dat$y[[3]] == 0); 

#source("test_cytof_fix_K_simdat.R")

### QQ Plot
par(mfrow=c(3,1))
plot(quantile(dat$y[[1]],seq(0,1,len=100)), quantile(post_pred[[1]],seq(0,1,len=100)), pch=20, col='red', ylab='post quantile 1'); abline(0,1,col='grey')
plot(quantile(dat$y[[2]],seq(0,1,len=100)), quantile(post_pred[[2]],seq(0,1,len=100)), pch=20, col='red', ylab='post quantile 2'); abline(0,1,col='grey')
plot(quantile(dat$y[[3]],seq(0,1,len=100)), quantile(post_pred[[3]],seq(0,1,len=100)), pch=20, col='red', ylab='post quantile 3'); abline(0,1,col='grey')
par(mfrow=c(1,1))

save.image(paste0(OUTDIR, "results.RData"))
