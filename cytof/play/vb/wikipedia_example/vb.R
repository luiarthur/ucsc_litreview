vb <- function(init, update, compare, eps=1E-6) {
  param <- init

  its <- 0
  converged <- FALSE

  while (!converged) {
    its <- its + 1
    updt <- update(param)
    converged <- all(compare(updt, param) < eps)
    param <- updt
  }

  list(param=param, its=its)
}
