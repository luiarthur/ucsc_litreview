#' Compute missing-mechanism parameters
#' @param y: (y_lo, y_center, y_hi)
#' @param prob: (p_lo, p_center, p_hi)
#' @export
miss_mech_params = function(y, prob) {
  logit = function(p) log(p / (1-p))

  stopifnot(length(y) == 2)
  stopifnot(y[1] < y[2])
  stopifnot(length(prob) == 2)
  stopifnot(prob[1] > prob[2])
  
  b1 = -(log(1/prob[1] - 1) - log(1/prob[2] - 1)) / (y[1] - y[2]) # should be negative
  b0 = -(log(1/prob[1] - 1) + b1 * y[1])

  c(b0=b0, b1=b1)
}

#' Compute probability of missing using missing mechanism
#' @param y, b0, b1
#' @export
prob_miss = function(y, b0, b1) {
  stopifnot(b1 < 0)
  x = b0 + b1 * y
  1 / (1 + exp(-x))
}

#' Sample from missing mechanism prior
#' @export
sample_from_miss_mech_prior = function(y, m_beta0, s2_beta0, m_beta1, s2_beta1,
                                       B=10) {
  b0 = rnorm(B, m_beta0, sqrt(s2_beta0))
  b1 = sapply(1:B, function(b) rtn(m_beta1, sqrt(s2_beta1), -Inf, 0))

  sapply(1:B, function(b) prob_miss(y, b0[b], b1[b]))
}

## TEST
#param = miss_mech_params(c(-4,-2), c(.99, .001))
#y = seq(-7, 7, l=100)
#p = prob_miss(y, param['b0'], param['b1'])
#
#v = .01
#b1_params = gamma_params(param['b1'], v)
#out = sample_from_miss_mech_prior(y, param['b0'], v, b1_params[1], b1_params[2],
#                                  B=1000)
#
#plot(y, p, type='l', lwd=2); abline(v=0, lty=2)
#for (k in 1:NCOL(out)) lines(y, out[,k], col='grey')
