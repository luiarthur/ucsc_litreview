library(rcommon)
source('mixture.R')

set.seed(2)

N = 350
mu_true = c(-5,-2, 3,5)
sig2_true = c(.1, .1 ,.3,.6)
w_true = c(.15, .15 ,.5,.2)
b_true = c(-3, -2)

y_true = rnorm(N,
               sample(mu_true,N,replace=TRUE,prob=w_true),
               sample(sig2_true,N,replace=TRUE,prob=w_true))
hist(y_true, prob=TRUE, border='transparent',  col=rgb(1,0,0,.3))

y = ifelse(sigmoid(b_true[1] + b_true[2]*y_true) > runif(N), NA, y_true)
hist(y, add=TRUE, prob=TRUE, col=rgb(0,0,1,.3), border='transparent')


K = 10
prior = gen.prior(K)
prior$b_mean = compute_b(y=c(-4,-2), p=c(.9,.1))
#prior$b_mean = b_true
prior$b_var = c(.05, .05)
prop_missing = mean(is.na(y))
println("Proportion missing: ", prop_missing)

### Plot Prior Missing Mechanism ###
yy = seq(-10, 0, l=100)
pm = sigmoid(prior$b_mean[1] + prior$b_mean[2] * yy)
plot(yy, pm, type='l', lwd=2); abline(v=0); #abline(v=c(-4,-2), h=c(.1,.9), lty=2)
for (i in 1:10) {
  bb = rnorm(2, prior$b_mean, sqrt(prior$b_var))
  pm = sigmoid(bb[1] + bb[2] * yy)
  lines(yy, pm, col=rgb(1,0,0,.5))
}


st = system.time(out <- fit(y, K=K, prior=prior, print_every=10, burn=1000, B=500))
print(st)

#ll = sapply(out, function(o) o$ll)
#plot(ll, type='l')

mu = t(sapply(out, function(o) o$mu))
plotPosts(mu[,1:min(5,K)])
boxplot(mu, main='mu')
abline(h=0, lwd=3)

#ggplot(stack(as.data.frame(mu))) + 
#geom_boxplot(aes(x=ind, y=values)) + 
#geom_hline(yintercept=0)


sig2 = t(sapply(out, function(o) o$sig2))
plotPosts(sig2[,1:min(5,K)])
boxplot(sig2)
#plotPosts(sig2[,1:6])

w = t(sapply(out, function(o) o$w))
colMeans(w)
ci_w = apply(w, 2, quantile, c(.025, .975))
which(apply(ci_w, 2, function(ci) ci[1] > .01))
boxplot(w)

#sapply(out, function(o) c(table(o$g)) / length(yij))

### Posterior of one missing y observations
y_post = sapply(out, function(o) o$y)
miss_idx = which(is.na(y))
plotPost(y_post[miss_idx[21], ])

### Plot Missing Mechanism Prior (red) and posterior (blue) ###
plot(yy, pm, type='l', lwd=2); abline(v=0); #abline(v=c(-4,-2), h=c(.1,.9), lty=2)
for (i in 1:10) {
  bb = rnorm(2, prior$b_mean, sqrt(prior$b_var))
  pm = sigmoid(bb[1] + bb[2] * yy)
  lines(yy, pm, col=rgb(1,0,0,.5))
}
post_pm = sapply(out, function(o) {
  b = o$b
  sigmoid(b[1] + b[2] * yy)
})
pm_ci = apply(post_pm, 1, quantile, c(.025,.975))
color.btwn(yy, pm_ci[1,], pm_ci[2,], from=-10, to=10, col.area=rgb(0,0,1,.4))

### Posterior Predictivice
pp = postpred(out)

par(mfrow=c(2,1))
hist(pp, col=rgb(0,0,1,.5), border='transparent', prob=TRUE, ylim=c(0, .5),
     main='Postpred (blue) and True y (grey)')
hist(y_true, add=TRUE, col=rgb(0,0,0,.5), border='transparent', prob=TRUE)
abline(v=0, lwd=3)
abline(v=colMeans(mu), lty=2)

hist(pp, col=rgb(0,0,1,.5), border='transparent', prob=TRUE, ylim=c(0,.5),
     main='Postpred (blue) and observed y (red)')
hist(y, add=TRUE, col=rgb(1,0,0,.5), border='transparent', prob=TRUE)
abline(v=0, lwd=3)
abline(v=colMeans(mu), lty=2)
par(mfrow=c(1,1))


