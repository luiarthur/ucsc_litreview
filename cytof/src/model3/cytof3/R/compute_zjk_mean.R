compute_zjk_mean= function(out, i, j) {
  #' Compute the posterior probability that marker j in sample i is expressed
  #' @export
  #K = last(out)$prior$K
  zjk = sapply(out, function(o) {
    #k = sample(1:K, 1, prob=o$W[i,])
    #k = sample(o$lam[[i]],1) + 1
    #o$Z[j,k]
    k = o$lam[[i]] + 1
    mean(o$Z[j,k])
  })
  mean(zjk)
}


