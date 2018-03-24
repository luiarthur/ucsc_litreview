library(rcommon)
library(cytof2)
source('mixture_fit.R')

load("../dat/cytof_cb.RData")

yij = y[[1]][,3]
yij = Filter(function(x) !is.na(x), yij)
yij = sample(yij, 1000)
#yij = rgamma(1000, 4, 6)

hist(yij)

st = system.time(out <- mixture_fit(yij, K=5, print_every=10, burn=1000, B=500))
print(st)

ll = sapply(out, function(o) o$ll)
plot(ll, type='l')

mu = t(sapply(out, function(o) o$mu))
plotPosts(mu[,1:5])
#plotPosts(mu[,6:10])
colMeans(mu)

sig2 = t(sapply(out, function(o) o$sig2))
plotPosts(sig2[,1:5])
#plotPosts(sig2[,1:6])

w = t(sapply(out, function(o) o$w))
colMeans(w)
ci_w = apply(w, 2, quantile, c(.025, .975))
which(apply(ci_w, 2, function(ci) ci[1] > .01))

#sapply(out, function(o) c(table(o$g)) / length(yij))

pp = postpred(out)
hist(yij, col=rgb(0,0,1,.5), border='transparent', prob=TRUE)
hist(pp, add=T, col=rgb(1,0,0,.5), border='transparent', prob=TRUE)

