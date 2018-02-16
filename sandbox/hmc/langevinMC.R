langevinMC = function(curr, grad_log_fc, eps) {
  noise = rnorm(length(curr), 0, sqrt(2*eps))
  curr + eps * grad_log_fc(curr) + noise
}

# Metropolis-adjusted Langevin algorithm
mala = function(curr, log_fc, grad_log_fc, eps) {
  logQ = function(x_to, x_from) {
    #-sum((x_to - x_from - eps * grad_log_fc(x_from))^2) / (4*eps)
    -sum((x_from - x_to - eps * grad_log_fc(x_to))^2) / (4*eps)
  }

  cand = langevinMC(curr, grad_log_fc, eps)

  acc = exp(log_fc(cand) + logQ(curr,cand) - log_fc(curr) - logQ(cand,curr))
  #print(acc)
  if (acc > runif(1)) {
    #print("moved")
    cand
  } else {
    curr
  }
}
