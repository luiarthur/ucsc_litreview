#library(cytof3)

#y_orig = readRDS('../data/cytof_cb.rds')
#y = resample(y_orig, prop=.01)
#prior = gen_default_prior(y)

### TODO!!! ###
#' Generate smart initial values
#' @examples init = smart_init(y, prior, K=10, L0=10, L1=10)
#' @param prior   List of priors (from gen_default_prior(y))
#' @param y       List of log expression levels divided by cutoffs
#' @description THIS FUNCTION IS NOT READY!
#' @export
# TODO
smart_init = function(prior, y) {
  J = prior$J
  N = prior$N
  L0 = prior$L0
  L1 = prior$L1
  K = prior$K
  I = prior$I

  y_init = preimpute(y)

  ### kmeans ###
  Y = do.call(rbind, y_init)
  km = kmeans(Y, K)
  Z = t(unique(km$centers > 0))
  clusters = km$clus
  idx = unlist(lapply(as.list(1:I), function(i) rep(i, N[i])))
  lam_init = lapply(as.list(1:I), function(i) clusters[which(idx==i)] - 1)
  W = matrix(0, I, K)
  for (i in 1:I) for (k in 1:K) {
    W[i,k] = mean(lam_init[[i]]+1 == k)
  }


}
