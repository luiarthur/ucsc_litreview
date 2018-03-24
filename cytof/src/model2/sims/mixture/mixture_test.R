library(rcommon)
library(cytof2)
source('mixture_fit.R')

load("../dat/cytof_cb.RData")

#y11 = y[[1]][,1]
#y11 = Filter(function(x) !is.na(x), y11)
y11 = rgamma(1000, 4, 6)

hist(y11)

out = mixture_fit(y11, print_every=10, burn=2000, B=500)
ll = sapply(out, function(o) o$ll)
plot(ll, type='l')

mu = t(sapply(out, function(o) o$mu))
plotPosts(mu[,1:5])

sig2 = t(sapply(out, function(o) o$sig2))
plotPosts(sig2[,1:5])


pp = postpred(out)
hist(pp, col=rgb(0,0,1,.5), border='transparent')
hist(y11, add=T, col=rgb(1,0,0,.5), border='transparent')
