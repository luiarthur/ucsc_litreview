source("fit.R")
library(rcommon)
last = function(x) x[[length(x)]]

K = 100
N = 1000
X = matrix(rnorm(N*K), N, K); X[,1] = 1
b_true = rnorm(K)
sig2_true = .01

y = X%*%b_true + rnorm(N, 0, sqrt(sig2_true))
#my.pairs(cbind(y,X))

prior = gen.default.prior(X); prior$cs=rep(.001,K)
out = fit(y, X, B=200, burn=1000, print=100, prior=prior)

prior$cs = prior$cs / 100
out = fit(y, X, B=200, burn=1000, print=100, prior=prior, init=last(out))

b = t(sapply(out, function(o) o$b))
ci_b = t(apply(b, 2, quantile, c(.025,.975)))

plot(b_true, colMeans(b))
add.errbar(ci_b, x=b_true)
abline(0, 1, v=0, h=0, lty=2, col='grey')
plotPosts(b[,1:5])
plotPost(b[,1])

sig2 = sapply(out, function(o) o$sig2)
plotPost(sig2, main=paste0('sig2: ', sig2_true), trace=FALSE)

ll = sapply(out, function(o) o$ll)
plot(ll, type='b')
