source("fit.R")
library(rcommon)
last = function(x) x[[length(x)]]
diff_mat = function(Z) sapply(2:nrow(Z), function(i) all(Z[i,] == Z[i-1,]))

K = 50
N = 1000
X = matrix(rnorm(N*K), N, K); X[,1] = 1
b_true = rnorm(K); b_true[1] = 1
sig2_true = .5

y = rnorm(N, X%*%b_true, sqrt(sig2_true))
#my.pairs(cbind(y,X))

prior = gen.default.prior(X); prior$cs=rep(.001,K)
out = fit(y, X, B=200, burn=1000, print=100, prior=prior, method='lmc')

prior$cs = prior$cs / 1000
out = fit(y, X, B=200, burn=2000, print=100, prior=prior, init=last(out))

b = t(sapply(out, function(o) o$b))
ci_b = t(apply(b, 2, quantile, c(.025,.975)))

plot(b_true, colMeans(b))
add.errbar(ci_b, x=b_true)
abline(0, 1, v=0, h=0, lty=2, col='grey')
#plotPosts(b[,1:5])
#plotPost(b[,1])

sig2 = sapply(out, function(o) o$sig2)
#plotPost(sig2, main=paste0('sig2: ', sig2_true))
hist(sig2, border='transparent', col='grey', prob=TRUE, xlim=range(sig2,sig2_true))
abline(v=c(mean(sig2), quantile(sig2, c(.025,.975))), lty=2)
abline(v=sig2_true, lwd=2, col='red')

ll = sapply(out, function(o) o$ll)
ll_truth = sum(dnorm(y, X%*%b_true, sig2_true, log=TRUE))
plot(ll, type='l', ylim=range(ll_truth,ll), col=c(0,diff_mat(b))+3, pch=20)
abline(h=ll_truth, lty=2)

### Predictions ###
N_test = 100
X_test = matrix(rnorm(N_test*K), N_test, K); X[,1] = 1
y_test = X_test %*% b_true + rnorm(N_test, 0, sqrt(sig2_true))
Y_pred = t(t(X_test %*% t(b)) + rnorm(length(sig2), 0, sqrt(sig2)))

plot(y_test, rowMeans(Y_pred), col='blue', pch=20, ylab='Predictions')
abline(0,1, lty=2, col='grey')
add.errbar(t(apply(Y_pred, 1, quantile, c(.025,.975))), x=y_test, col='blue')
