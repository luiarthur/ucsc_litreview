library(cytof2)
library(rcommon)

set.seed(1)

#source("../cytof2/R/readExpression.R")

I = 3
J = 32
K = 4
W <- matrix(c(.3, .4, .2, .1,
              .1, .7, .1, .1,
              .2, .3, .3, .2), nrow=I, byrow=TRUE)

redToBlue <- colorRampPalette(c('red','grey90','blue'))(12)
blueToRed <- rev(redToBlue)

dat <- simdat(I=3, N=c(200,300,100), J=J, K=K, Z=genZ(J, K, c(.4,.6)), W=W,
              thresh=-4)


plot.histModel2(dat$y, xlim=c(-5,5))
my.image(dat$Z)
my.image(dat$y[[1]], mn=-5, mx=5, col=redToBlue, addLegend=TRUE)

out <- cytof_fix_K_fit(dat$y,
                       init=NULL,
                       prior=NULL,
                       truth=list(K=4), 
                       thin=0, B=200, burn=300,
                       compute_loglike=1, print_freq=100)



ll <- sapply(out, function(o) o$ll)
plot(ll <- sapply(out, function(o) o$ll), type='l')


# beta
beta_0 = sapply(out, function(o) o$beta_0)
plotPosts(t(beta_0[1:4,]))
plotPosts(t(beta_0[5:8,]))
plotPosts(t(beta_0[9:12,]))

betaBar_0 = sapply(out, function(o) o$betaBar_0)
rowMeans(betaBar_0)

beta_1 = sapply(out, function(o) o$beta_1)
rowMeans(beta_1)
plotPosts(t(beta_1[1:4,]))
plotPosts(t(beta_1[5:8,]))
plotPosts(t(beta_1[9:12,]))


# mus0
mus0_ls = lapply(out, function(o) o$mus[,,1])
mus0 = array(unlist(mus0_ls), dim = c(nrow(mus0_ls[[1]]), ncol(mus0_ls[[1]]), length(mus0_ls)))
mus0_mean = apply(mus0, 1:2, mean)

my.image(mus0_mean, mn=-4, mx=0, col=blueToRed, addLegend=TRUE)
my.image(dat$mus_0, mn=-4, mx=0, col=blueToRed, addLegend=TRUE)
my.image(mus0_mean-dat$mus_0, mn=-3, mx=3, col=blueToRed, addLegend=TRUE)

# mus1
mus1_ls = lapply(out, function(o) o$mus[,,2])
mus1 = array(unlist(mus1_ls), dim = c(nrow(mus1_ls[[1]]), ncol(mus1_ls[[1]]), length(mus1_ls)))
mus1_mean = apply(mus1, 1:2, mean)

my.image(mus1_mean, mn=0, mx=4, col=blueToRed, addLegend=TRUE)
my.image(dat$mus_1, mn=0, mx=4, col=blueToRed, addLegend=TRUE)
my.image(mus1_mean-dat$mus_1, mn=-1, mx=1, col=blueToRed, addLegend=TRUE)

# sig2

# Z
Z <- lapply(out, function(o) o$Z)
Z_mean <- Reduce("+", Z) / length(Z)
ord <- left_order(Z_mean)
my.image(Z_mean[,ord], main="posterior")
my.image(dat$Z, main="data")


