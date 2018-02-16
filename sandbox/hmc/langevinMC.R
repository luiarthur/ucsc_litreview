# Langevin Monte Carlo
langevinMC = function(curr, grad_log_fc, eps) {
  rnorm(length(curr), curr + eps * grad_log_fc(curr), sqrt(2*eps))
}

# Metropolis-adjusted Langevin algorithm
mala = function(curr, log_fc, grad_log_fc, eps) {
  # Note: For high dims, use langevin MC to warm up.

  ### Log proposal density
  log_q = function(to, from) {
    #-sum((to - from - eps * grad_log_fc(from))^2 / (4*eps))
    sum(dnorm(to, from + eps*grad_log_fc(from), sqrt(2*eps), log=TRUE))
  }

  ### Proposed value
  cand = langevinMC(curr, grad_log_fc, eps)

  ### Compute acceptance rate
  acc = exp(log_fc(cand) + log_q(to=curr,from=cand) -
            log_fc(curr) - log_q(to=cand,from=curr))

  ### Accept with probability min{1, acc}
  if (acc > runif(1)) {
    cand
  } else {
    curr
  }
}

#################################################################################
# TODO: Make a more general MALA, for anisotropic case (i.e. it varies much
#       more quickly in some directions than others).  
#
# See Wikipedia: 
# https://en.wikipedia.org/wiki/Metropolis-adjusted_Langevin_algorithm#cite_ref-1
#################################################################################
