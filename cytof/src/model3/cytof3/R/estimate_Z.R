pairwise_alloc <- function(Z, W, i) {
  #' Returns a pairwise allocation matrix of a feature allocation (binary) matrix Z
  #' using SALSO by David B. Dahl.
  #' @export

  J <- NROW(Z)
  K <- NCOL(Z)

  A <- matrix(0, J, J)

  for (j1 in 1:J) {
    for (j2 in 1:J) {
      for (k in 1:K) {
        if (Z[j1,k] == 1 && Z[j2,k] == 1) {
          A[j1,j2] <- A[j2,j1] <- A[j1,j2] + W[i, k] #1
        }
      }
    }
  }

  A
}


estimate_ZWi_index = function(out, i) {
  As = lapply(out, function(o) {
    pairwise_alloc(o$Z, o$W, i)
  })
  A_mean = matApply(As, mean)
  mse = sapply(As, function(A) mean((A-A_mean)^2))
  which.min(mse)
}
