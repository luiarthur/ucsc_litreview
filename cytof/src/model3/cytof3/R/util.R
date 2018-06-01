invgamma_params <- function(m,sig) {
  #' Get the parameter values for inv-gamma distribution given mean and sd.
  #' Parameterization: mu = b / (a-1)
  #' @export
  a <- (m / sig)^2 + 2
  b <- m * (a-1)
  c(a,b)
}

#' Compute parameters of gamma distribution from mean and sd
#' TODO: Put in different file
#' @export
gamma_params = function(m, v) {
  rate = m/v
  shape = m * rate
  c(shape=shape, rate=rate)
}


matApply = function(mat_ls, f, ...) {
  #' Apply a function to a list of matrices
  #' @export
  apply(simplify2array(mat_ls), 1:2, f, ...)
}

println = function(x, ...) cat(x, ..., "\n")

compress = function(x) float::dbl(float::fl(x))

"%+%" = function(a,b) paste0(a,b)


rgba = function(col, a=1) {
  sapply(col, function(co) {
    RGB = col2rgb(co) / 255
    rgb(RGB[1], RGB[2], RGB[3], a)
  })
}


pinvgamma = function(x, a, b, log.p=FALSE) {
  pgamma(1/x, a, b, lower.tail=FALSE, log.p=log.p)
}

qinvgamma = function(u, a, b, log.p=FALSE) {
  1 / qgamma(u, a, b, lower.tail=FALSE, log.p=log.p)
}

rinvgamma = function(n, a, b) {
  1 / rgamma(n, a, b)
}
