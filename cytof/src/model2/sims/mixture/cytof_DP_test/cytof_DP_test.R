library(rstan)
options(mc.cores = parallel::detectCores()) # auto-detect and use number of cores available
library(rcommon)
library(cytof2)
load("../../dat/cytof_cb.RData")

### Define the data ###
Y = cytof2::preimpute(y, .01)
YY = do.call(rbind, Y)
markers = colnames(YY)
data = list(YY=YY)
K = 10
J = NCOL(Y[[1]])
I = length(Y)
N = sapply(Y, NROW)
stan_dat = list(N=NROW(YY), K=K, y=YY, J=J, R=diag(J))

### Model
out <- stan(file='cytof_DP_test.stan', data=stan_dat,
            iter=2000, chain=1, model_name="gaussian_mixture")


print(out)
plot(out)

eo = extract(out)
plotPosts(eo$mu[,1:5,1])

j = 32
for (k in 1:32) {
  boxplot(eo$mu[,,j], main=paste0('mu for marker ',j))
}
boxplot(eo$sig2)

plot(eo$lp, type='l')
