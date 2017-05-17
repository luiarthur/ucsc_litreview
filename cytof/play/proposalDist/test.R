source("mcmc.R")
library(rcommon)

n <- 15
y <- rpois(n, 3)

B <- 2000
burn <- 100

update <- function(curr) {
  ll <- function(x) {
    ifelse(x < 0, -Inf, sum(dpois(y, x, log=TRUE)))
  }

  lp <- function(x) {
    ifelse(x < 0, -Inf, dgamma(x, .1, .1, log=TRUE))
  }

  list(lambda=mh(curr$lambda, ll, lp, 2))
}

init <- list(lambda=1)
out <- sapply(gibbs(init=init, update, B=2000, burn=500), function(d)d$lam)

plotPost(out)
length(unique(out)) / length(out)
