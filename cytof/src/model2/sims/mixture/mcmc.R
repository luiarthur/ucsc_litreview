log_det <- function(X) {
  determinant(X, log=TRUE)$mod[1]
}

### Univariate metropolis with Normal proposal ###
mh <- function(x, ll, lp, step_size) {
  cand <- rnorm(1, x, step_size)
  acc <- ll(cand) + lp(cand) - ll(x) - lp(x)
  u <- runif(1)

  ifelse(acc > log(u), cand, x)
}

### Sample from multivariate Normal ###
mvrnorm <- function(m, S) {
  if (all(diag(diag(S)) == S)) {
    rnorm(length(m), m, diag(S))
  } else {
    m + t(chol(S)) %*% rnorm(ncol(S)) ### FIXME
    #MASS::mvrnorm(1, m, S)
  }
}

### Multivariate metropolis with Normal proposal ###
mh_mv <- function(x, ll, lp, step_size) {
  J = length(x)
  cand <- rnorm(J, x, step_size)
  acc <- ll(cand) + lp(cand) - ll(x) - lp(x)
  u <- runif(1)
  if(acc > log(u)) cand else x
}

### Gibbs Sampler (generic) ###
gibbs <- function(init, update, B, burn, print_every=0) {
  out <- as.list(1:B)
  out[[1]] <- init

  for (i in 1:(B+burn)) {
    if (i - burn < 2) {
      out[[1]] <- update(out[[1]])
    } else {
      out[[i-burn]] <- update(out[[i-burn-1]])
    }
    if (print_every > 0 && i %% print_every == 0) {
      cat("\rProgress: ", i, " / ", B+burn)
    }
  }
  cat("\n")

  out
}
#x <- gibbs(1, function(x) {Sys.sleep(.1); x + 1}, 10, 0, 3)

### Transforming parameters ###
logit <- function(p, a=0, b=1) {
  log( (p-a) / (b-p) )
}

inv_logit <- function(x, a=0, b=1) {
  #(b * exp(x) + a) / (1 + exp(x)) 
  (b  + a * exp(-x)) / (exp(-x) + 1) 
}

log_den_logx_2param <- function(log_den) {
  function(logx, a, b) log_den(exp(logx), a, b) + logx
}

log_dgamma <- function(x, a, b) dgamma(x, a, b, log=TRUE)

log_dinvgamma <- function(x, a, b_numer) {
  const <- a * log(b_numer) - lgamma(a)
  -(a + 1) * log(x) - b_numer / x + const
}

lp_log_gamma <- log_den_logx_2param(log_dgamma)
lp_log_invgamma <- log_den_logx_2param(log_dinvgamma)

lp_logit_unif <- function(logit_u) {
  logit_u - 2 * log(1 + exp(logit_u))
}

ldmvnorm <- function(y, m, S) {
  #' Density of multivariate normal up to proportionality constant
  z <- y - m
  out <- -(log_det(S) + t(z) %*% solve(S) %*% z) / 2
  out[1,1]
}


### Adaptive MCMC
# http://www2.warwick.ac.uk/fac/sci/maths/research/miraw/days/montecarlo/abstracts/adaptivemiraw11_roberts.pdf

autotune <- function(x, acc, a, b, i, target=.30, wiggle=.1, 
                     small=.1, big=10) {
  acc_too_small <- acc < target - wiggle
  acc_too_big <- acc > target + wiggle

  new_a <- if (acc_too_small) { 
    a - 1 / i 
  } else if (acc_too_big) {
    a + 1 / i
  } else a

  x_big <- abs(x) > big
  x_small <- abs(x) < small
  new_b <- if (x_big && acc < target) {
    b - 1 / i
  } else if (x_small && acc < target) {
    b + 1 / i
  } else b

  # returning the new candidate sigma
  exp(new_a) * (1 + abs(x))^new_b
}

post_summary <- function(X, alpha=.05, digits=3) {
  post_mean <- colMeans(X)
  post_sd <- apply(X,2,sd)
  post_ci <- t(apply(X,2, quantile, c(alpha/2, 1-alpha/2)))

  post_table <- cbind(post_mean, post_sd, post_ci)
  rownames(post_table) <- colnames(X)
  colnames(post_table) <- c("Mean","SD","CI.lower","CI.upper")

  round(post_table, digits)
}

# For 1-D param.
# See Haario et al., 2001
# and Gelman et al., 1996
autotune2 <- function(x, s_mult = 2.4) {
  s_mult * sqrt(var(x) + 1E-6)
}

### Gibbs Sampler (autotune) ###
gibbs_auto <- function(init, update, B, burn, adapt=NULL, print_every=0) {
  out <- as.list(1:(B+burn))
  out[[1]] <- init

  for (i in 2:(B+burn)) {

    out[[i]] <- update(out[[i-1]], cs)

    # DO Adaptive MCMC
    if (!is.null(adapt)) {
      if (i %% 100 == 0) cs <- adapt(out[(i-99):i])
    }

    if (print_every > 0 && i %% print_every == 0) {
      cat("\rProgress: ", i, " / ", B+burn)
    }
  }
  cat("\n")

  tail(out, B)
}

sigmoid = function(x) 1 / (1 + exp(-x))

rdir = function(a) {
  n = length(a)
  x = rgamma(n, a, 1)
  sum_x = sum(x)
  x / sum_x
}
