library(rcommon)
source("../cytof.R", chdir=TRUE)
source("../cytof_simdat.R")
source("../../dat/myimage.R")


set.seed(1)
dat <- cytof_simdat(I=3, N=list(300, 500, 400), J=10, K=4, p=.3,
                    psi=rgamma(10, 2, .5), tau2=rgamma(10, 1, 1),
                    sig2=rgamma(3, 1, 1),
                    W=matrix(c(.3, .4, .2, .1,
                               .1, .4, .1, .4,
                               .2, .3, .3, .2), 3, 4, byrow=TRUE))
### PLOT DATA
#my.image(cor(dat$y[[1]]), xaxt='n',yaxt='n',xlab="",ylab="",
#         main="y1 Correlation b/w Markers",addLegend=TRUE)
#my.image(cor(dat$y[[2]]), xaxt='n',yaxt='n',xlab="",ylab="",
#         main="y2 Correlation b/w Markers",addLegend=TRUE)
#my.image(cor(dat$y[[3]]), xaxt='n',yaxt='n',xlab="",ylab="",
#         main="y3 Correlation b/w Markers",addLegend=TRUE)

### Compute
y <- dat$y
I <- dat$I
J <- dat$J

p <- .05
N_i <- sapply(y, nrow)
train_idx <- sapply(N_i, function(N) sample(1:N, round(N*p)))
y_TE <- lapply(as.list(1:I), function(i) y[[i]][-train_idx[[i]],])
y_TR <- lapply(as.list(1:I), function(i) y[[i]][ train_idx[[i]],])

source("../cytof.R", chdir=TRUE)
out <- cytof(y_TE, y_TR, burn_small=3000, K_min=1, K_max=5, a_K=2,
             burn=1000, B=2000, pr=100)

#out <- cytof(y_TE, y_TR, burn_small=30, K_min=1, K_max=5, a_K=2,
#             burn=10, B=20, pr=100)

psi <- t(sapply(out, function(o) o$psi))
plotPosts(psi[,1:5])
#plot(apply(psi, 2, function(pj) length(unique(pj)) / length(out)),
#     ylim=0:1, main="Acceptance rate for psi")
#abline(h=c(.25, .4), col='grey')
#
#Z <- lapply(out, function(o) o$Z)
#Z_mean <- Reduce("+", Z) / length(Z)
#my.image(Z_mean >= .4)
#my.image(Z_mean)

log_dtnorm
log_dtnorm(-1, 3,4,0,lt=TRUE)
log(dtruncnorm(-1,-Inf,0,3,4))
