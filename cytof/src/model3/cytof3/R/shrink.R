# require(float)
# These functions are intended to save on storage by storing 
# matrices of doubles to matrices of floats

shrinkOut = function(out) {
  #' shrinks the out object from MCMC
  #' @export
  B = length(out)

  out[[B]]$missing_y_mean = lapply(out[[B]]$missing_y_mean, fl)
  out[[B]]$missing_y = lapply(out[[B]]$missing_y, fl)

  out
}

unshrinkOut = function(out) {
  #' shrinks the out object from MCMC
  #' @export
  B = length(out)

  out[[B]]$missing_y_mean = lapply(out[[B]]$missing_y_mean, dbl)
  out[[B]]$missing_y = lapply(out[[B]]$missing_y, dbl)

  out
}

shrinkDat = function(dat) {
  #' shrinks data
  #' @export

  dat$missing_y_mean = lapply(dat$y, fl)
  dat$missing_y = lapply(dat$y_complete, fl)

  dat
}

unshrinkDat = function(dat) {
  #' Unshrink data
  #' @export

  dat$missing_y_mean = lapply(dat$y, dbl)
  dat$missing_y = lapply(dat$y_complete, dbl)

  dat
}

