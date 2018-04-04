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

  c(b0=b0, b1=b1, c1=c1)
}

#' Compute probability of missing using missing mechanism
#' @param y, c0, b0, b1, c1
#' @export
prob_miss = function(y, c0, b0, b1, c1) {
  d = abs(y - c0)
  x = ifelse(y < c0, b0 - b1 * d^2, b0 - b1 * c1 * sqrt(d))
  1 / (1 + exp(-x))
}
