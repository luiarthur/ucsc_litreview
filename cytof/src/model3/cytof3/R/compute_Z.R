compute_Z = function(H, v, G) {
  J = NROW(H)
  K = NCOL(H)
  Z = matrix(0, J, K)

  stopifnot(NCOL(G) == J && NCOL(G) == J)
  stopifnot(length(v) == K)

  for (k in 1:K) {
    for (j in 1:J) {
      Z[j,k] = (pnorm(H[j,k], 0 , G[j,j], lower.tail=TRUE) < v[k]) * 1
    }
  }

  return(Z)
}
