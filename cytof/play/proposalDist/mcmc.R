gibbs <- function(init, update, B, burn) {
  out <- as.list(1:(B+burn))
  out[[1]] <- init

  for (i in 2:(B+burn)) {
    out[[i]] <- update(out[[i-1]])
  }

  tail(out, B)
}

### Univariate Metropolis Step
mh <- function(x, ll, lp, cs) {
  cand <- rnorm(1, x, cs)
  u <- runif(1)
  r <- lp(cand) + ll(cand) - (lp(x) + ll(x))

  new_x <- ifelse(r > log(u), cand, x)
  new_x
}


