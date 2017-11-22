library(cytof2)

set.seed(1)

#source("../cytof2/R/readExpression.R")

I = 3
J = 10
K = 4
W <- matrix(c(.3, .4, .2, .1,
              .1, .7, .1, .1,
              .2, .3, .3, .2), nrow=I, byrow=TRUE)
dat <- simdat(I=3, N=c(200,300,100), J=J, K=K, Z=genZ(J, K, c(.4,.6)), W=W,
              thresh=-4)


idx_missing = lapply(dat$y, function(yi) which(is.na(yi), arr.ind=TRUE))
missing_R(dat$y, 3, 96, 9)

plot.histModel2(dat$y, xlim=c(-5,5))
my.image(dat$Z)

out <- cytof_fix_K_fit(dat$y,
                       init=NULL,
                       prior=NULL,
                       truth=list(K=4), 
                       thin=0, B=2000, burn=100,
                       compute_loglike=1, print_freq=100)

out[[1]]$beta_0
out[[1]]$beta_1
out[[1]]$betaBar_0
out[[1]]
min(out[[1]]$missing_y[[1]])


idx_missing_post = lapply(last(out)$missing_y, function(yi) 
                          which(is.na(matrix(yi,ncol=J)), arr.ind=TRUE))

# Check if missing idx the same
#all(sapply(as.list(1:I), function(i) all(idx_missing_post[[i]] == idx_missing[[i]])))



ll <- sapply(out, function(o) o$ll)
plot(ll <- sapply(out, function(o) o$ll), type='l')

beta_0 = sapply(out, function(o) o$beta_0)
apply(beta_0, 1, function(b) length(unique(b)))

plot(beta_0[1,], type='l')

ord <- left_order(last(out)$Z)
my.image(last(out)$Z[,ord], main="posterior")
my.image(dat$Z)
