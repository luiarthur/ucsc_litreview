#' compute logit of a probability
#' @export
logit = function(p) {
  log(p) - log(1-p)
}

#' compute inverse-logit (sigmoid) of a real value
#' @export
sigmoid = function(x) {
  1 / (1 + exp(-x))
}
