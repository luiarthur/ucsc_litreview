source("fit.R", chdir=T)
library(rcommon)
library(cytof2)


N = 500
b_true = c(-3, -2)
mu_true = 0
sig2_true = 10
y = rnorm(N, mu_true, sqrt(sig2_true))
m = (sigmoid(b_true[1] + b_true[2] * y) > runif(N)) * 1
y_dat = ifelse(m == 1, NA, y)
#plot(y, y)
hist(y, col=rgb(0,0,1,.3)); hist(y_dat, add=TRUE, col=rgb(1,0,0,.3))

xx = seq(min(y), max(y), l=100)
plot(xx, sigmoid(b_true[1] + b_true[2]*xx), type='b')

prior = default.prior
prior$cs_b=c(1,1)*1

ab = invgamma_ab(var(y_dat, na.rm=TRUE), .1)
prior$a_sig=ab[1]
prior$b_sig=ab[2]
#init = list(b=c(2,-2), mu=0, sig2=1, y=y)
init = list(b=c(0,0), mu=0, sig2=1, y=y)
out = fit(y_dat, init=init, prior=prior, B=500, burn=5000)

mu = sapply(out, function(o) o$mu)
sig2 = sapply(out, function(o) o$sig2)
yy = t(sapply(out, function(o) o$y))
b = t(sapply(out, function(o) o$b))
ll = sapply(out, function(o) o$ll)

plot(ll, type='l')

idx_y_first_missing = min(which(is.na(y_dat)))
plotPost(yy[,idx_y_first_missing])

plotPosts(cbind(mu, sig2), cname=c(paste0('mu: ',mu_true),
                                   paste0('sig2: ',sig2_true)))

plotPosts(b)

pp = apply(b, 1, function(bb) sigmoid(bb[1] + bb[2] * xx))

bk <- hist(colMeans(yy), plot=FALSE)
hist(y, border='transparent', col=rgb(0,0,0,.3), xlim=c(-10,10))
hist(colMeans(yy)[which(m==0)], add=TRUE, col=rgb(1,0,0,.3), border='transparent')
hist(colMeans(yy)[which(m==1)], add=TRUE, col=rgb(0,1,0,.3), border='transparent')
lines(xx, max(bk$counts) * sigmoid(b_true[1] + b_true[2]*xx), lty=2)
lines(xx, max(bk$counts) * rowMeans(pp), lty=2, col='blue')


### Plot Data and Imputed Data ###
hist(y, border='transparent', col=rgb(0,0,0,.3), xlim=c(-10,10))
hist(y_dat[which(m==0)], add=TRUE, col=rgb(1,0,0,.3), border='transparent')
hist(yy[N,which(m==1)], add=TRUE, col=rgb(0,1,0,.3), border='transparent')
#hist(yy[length(y),], add=TRUE, col=rgb(1,0,0,.3), border='transparent')
#hist(colMeans(yy), add=TRUE, col=rgb(1,0,0,.3), border='transparent')

#plot(xx, sigmoid(b_true[1] + b_true[2]*xx), col='grey', ylim=0:1, pch=20)
#lines(xx, rowMeans(pp))
