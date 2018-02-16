langevinMC = function(curr, grad_log_fc, eps) {
  curr + eps * grad_log_fc(curr) + rnorm(length(curr), 0, sqrt(2*eps))
}
