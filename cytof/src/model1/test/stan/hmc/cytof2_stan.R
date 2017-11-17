library(rstan)
### STAN Options
rstan_options(auto_write = TRUE) # save compiled file 
options(mc.cores = parallel::detectCores()) # auto-detect and use number of cores available


library(rcommon)
source("../../cytof_simdat.R")
source("../../../dat/myimage.R")

last <- function(lst) lst[[length(lst)]]

left_order <- function(Z) {
  order(apply(Z, 2, function(z) paste0(as.character(z), collapse='')), decreasing=TRUE)
}

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
dat <- cytof_simdat(I=3, N=list(200, 300, 100), J=12, K=4,
                    pi_a=1, pi_b=9,
                    a=1,#.5,
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
N <- sapply(y, nrow)

### Sensitive priors
#TODO: FIX stan code
#        - mus should be truncated normal
#        - provide starting values
#        - something about the maximum tree depth?
set.seed(2)
Y <- array(dim=c(I, max(N), J))
for (i in 1:I) {
  Y[i, 1:N[i], ] <- y[[i]]
  Y[i, -c(1:N[i]), ] <- Inf
}

init <- list(
  mus=matrix(1, J, K),
  gam=rep(.999, K),
  sig2=rep(1, I)
)

stan_dat <- list(I=I, J=J, K=K, N=N, maxN = max(N), 
                 thresh=log(2), a=rep(1, K), y=Y)

adapt <- list(adapt_delta=.95) # .8 is the Dedault

out <- stan(file='cytof2.stan', data=stan_dat, #init=list(init), control=adapt,
            iter=2000, chain=1, model_name="cytof")

post <- extract(out)
apply(post$gam, 2, mean)
Z_mean <- apply(post$Z, 2:3, mean)
ord <- left_order(Z_mean)
my.image(apply(post$mu, 2:3, mean))
my.image(apply(post$mu, 2:3, mean)[,ord])
my.image(Z_mean[,ord])
plotPosts(post$sig2)

apply(post$W, 2:3, mean)
dat$W

apply(post$Pi, 2:3, mean)
dat$pi





#source("cytof2_stan.R")
