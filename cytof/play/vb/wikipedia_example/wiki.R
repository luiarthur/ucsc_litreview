# See: https://en.wikipedia.org/wiki/Variational_Bayesian_methods
# Model: 
# x_i | mu, tau ~ N(mu, 1 / tau), i = 1, ..., N. (tau is precision)
#  mu | tau     ~ N(m, 1 / (g tau))
#       tau     ~ G(a, b)
# (m, g, a, b) are fixed

vb <- function(y, m=0, a0=.001, b0=.001, g=1, prec_init=1, eps=1E-3) {
  param <- list(prec=prec_init, bN=NA)
  N <- length(y)
  aN <- a0 + (N + 1) / 2
  mu <- ((g * m) + N * mean(y)) / (g + N)
  sum_y2 <- sum(y^2)
  sum_y <- sum(y)

  converged <- FALSE
  its <- 0

  while (!converged) {
    its <- its + 1
    bN_new <- b0 + .5 * ((g+N) * (1/param$prec + mu^2) - 2 * (g*m + sum_y) * mu + sum_y2 + g * m^2)
    prec_new <- (g + N) * aN / bN_new
    new_param <- list(bN=bN_new, prec=prec_new)
    converged <- all(abs(c(new_param$prec - param$prec, 
                           new_param$bN - param$bN)) < eps)
    param <- new_param
  }

  list(mu_mean=mu, mu_prec=param$prec, tau_a=aN, tau_b=param$bN, its=its)
}

### MAIN ###

B <- 30000
y <- rnorm(B,5,3)

out <- vb(y, eps=1E-10)

out$mu_mean
sqrt(out$tau_b / out$tau_a)
out$its
