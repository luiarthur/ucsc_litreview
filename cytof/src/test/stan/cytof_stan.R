library(rstan)
library(rcommon)
source("../../cytof_simdat.R")
source("../../../dat/myimage.R")

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
N <- sapply(y, length)

### Sensitive priors
### depend on starting values
### Z recovered sometimes
#TODO: Now try AMCMC to recover mus
set.seed(2)
Y <- array(dim=c(I, max(N), J))
for (i in 1:I) {
  Y[i, 1:N[i], ] <- y[[i]]
  #Y[i, -c(1:N[i]), ] <- Inf
}
stan_dat <- list(I=I, J=J, K=K, N=sapply(y, length), maxN = max(N), 
                 h_mean=rep(0,J), G=diag(J), thresh=log(2),
                 alpha=1, a=rep(1, K), y=Y)

out <- stan(file='cytof.stan', data=stan_dat, 
            iter=2000, chain=4, model_name="cytof")


