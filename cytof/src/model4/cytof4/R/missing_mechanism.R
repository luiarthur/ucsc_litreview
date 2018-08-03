#' Compute probability of missing using missing mechanism
#' @param y, b0, b1
#' @export
prob_miss = function(y, b0, b1) {
  stopifnot(b1 < 0)
  x = b0 + b1 * y
  1 / (1 + exp(-x))
}


#' Solves for parameters in missing mechanism given two points on the mechanism
#' @export
solve_miss_mech_params = function(y, p) {
  stopifnot(length(y) == 2 && length(p) == 2)
  b1 = diff(logit(p)) / diff(y)
  b0 = logit(p[1]) - b1 * y[1]
  c('b0'=b0, 'b1'=b1)
}
