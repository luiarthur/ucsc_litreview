library(cytof2)

set.seed(1)

#source("../cytof2/R/readExpression.R")

W <- matrix(c(.3, .4, .2, .1,
              .1, .7, .1, .1,
              .2, .3, .3, .2), nrow=3, byrow=TRUE)
dat <- simdat(I=3, N=c(200,300,100), J=12, K=4, Z=genZ(12, 4, c(.4,.6)), W=W,
              thresh=-5)

plot.histModel2(dat$y, xlim=c(-5,5))
my.image(dat$Z)

out <- cytof_fix_K_fit(dat$y,
                       init=NULL,
                       prior=NULL,
                       truth=list(K=4), 
                       thin=0, B=2000, burn=100,
                       compute_loglike=1, print_freq=100)

out[[100]]$beta_0
out[[100]]$beta_1
out[[100]]$betaBar_0


out[[1]]

plot(sapply(out, function(o) o$ll), type='l')

beta_0 = sapply(out, function(o) o$beta_0)
apply(beta_0, 1, function(b) length(unique(b)))

plot(beta_0[12,], type='l')

my.image(last(out)$Z)
