langevinMC = function(curr, grad_log_fc, eps) {
  #noise = rnorm(length(curr), 0, sqrt(2*eps))
  #curr + eps * grad_log_fc(curr) + noise
  rnorm(length(curr), curr + eps * grad_log_fc(curr), sqrt(2*eps))
}

# Metropolis-adjusted Langevin algorithm
mala = function(curr, log_fc, grad_log_fc, eps) {
  logQ = function(to, from) { #FIXME
#    -sum((to - from - eps * grad_log_fc(from))^2 / (4*eps)) # WIKIPEDIA
#    -sum((from - to - eps * grad_log_fc(to))^2 / (4*eps))   # WORKS
    sum(dnorm(to, from + eps*grad_log_fc(from), sqrt(2*eps), log=TRUE)) # WIKI
#    sum(dnorm(from, to + eps*grad_log_fc(to), sqrt(2*eps), log=TRUE))   # WORKS???
  }

  cand = langevinMC(curr, grad_log_fc, eps)

  acc = log_fc(cand) + logQ(to=curr,from=cand) -
        log_fc(curr) - logQ(to=cand,from=curr)
  logU = log(runif(1))

  if (acc > logU) {
    #print(acc)
    #print("moved")
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
