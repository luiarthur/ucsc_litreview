library(rstan)
library(rcommon)

### STAN Options
rstan_options(auto_write = TRUE) # save compiled file 
options(mc.cores = parallel::detectCores()) # auto-detect and use number of cores available

mu <- c(-1, 2, 5)
sig2 <- c(1, .2, .5)
K <- length(mu)
N <- 1000
label <- sample(1:K, N, replace=TRUE)
y <- rnorm(N, mu[label], sqrt(sig2[label]))
hist(y)

stan_dat <- list(N=N, K=K, y=y)

out <- stan(file='gaussian_mixture.stan', data=stan_dat,
            iter=2000, chain=1, model_name="gaussian_mixture")

print(out)
plot(out)

