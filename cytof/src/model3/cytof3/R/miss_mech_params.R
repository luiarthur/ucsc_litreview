#' Compute missing-mechanism parameters
#' @param y: (y_lo, y_center, y_hi)
#' @param prob: (p_lo, p_center, p_hi)
#' @export
miss_mech_params = function(y, prob) {
  logit = function(p) log(p / (1-p))

  stopifnot(length(y) == 3)
  stopifnot(length(prob) == 3)

  b0 = logit(prob[2])
  b1 = (b0 - logit(prob[1])) / (y[1] - y[2])^2
  c1 = (b0 - logit(prob[3])) / ( b1 * sqrt(y[3] - y[2]) )

  c(b0=b0, b1=b1, c1=c1, c0=y[2])
}

#' Compute probability of missing using missing mechanism
#' @param y, c0, b0, b1, c1
#' @export
prob_miss = function(y, c0, c1, b0, b1) {
  d = abs(y - c0)
  x = ifelse(y < c0, b0 - b1 * d^2, b0 - b1 * c1 * sqrt(d))
  1 / (1 + exp(-x))
}

#' Sample from missing mechanism prior
#' @export
sample_from_miss_mech_prior = function(y, c0, c1, m_beta0, s2_beta0, 
                                       a_beta1, b_beta1, B=10) {
  b0 = rnorm(B, m_beta0, sqrt(s2_beta0))
  b1 = rgamma(B, a_beta1, b_beta1)

  sapply(1:B, function(b) prob_miss(y, c0, c1, b0[b], b1[b]))
}

#' Compute parameters of gamma distribution from mean and sd
#' TODO: Put in different file
#' @export
gamma_params = function(m, v) {
  rate = m/v
  shape = m * rate
  c(shape=shape, rate=rate)
}

## TEST
#param = miss_mech_params(c(-4,-2,-1), c(.1, .99, .001))
#y = seq(-7, 7, l=100)
#p = prob_miss(y, param['c0'], param['c1'], param['b0'], param['b1'])
#
#v = .01
#b1_params = gamma_params(param['b1'], v)
#out = sample_from_miss_mech_prior(y, param['c0'], param['c1'], 
#                                  param['b0'], v,
#                                  b1_params[1], b1_params[2], B=1000)
#
#plot(y, p, type='l', lwd=2); abline(v=0, lty=2)
#for (k in 1:NCOL(out)) lines(y, out[,k], col='grey')
