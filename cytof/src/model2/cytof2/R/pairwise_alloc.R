pairwise_alloc <- function(Z) {
  #' Returns a pairwise allocation matrix of a feature allocation (binary) matrix Z
  #' using SALSO by David B. Dahl.
  #' @export

  J <- NROW(Z)
  K <- NCOL(Z)

  A <- matrix(0, J, J)

  for (j in 1:J) {
    for (i in 1:J) {
      for (k in 1:K) {
        if (Z[i,k] == 1 && Z[j,k] == 1) {
          A[j,i] <- A[i,j] <- A[i,j] + 1
        }
      }
    }
  }

  A
}

estimate_Z <- function(Zs, returnIndex=FALSE) {
  #' Provides a point esitmate of Z using SALSO for feature allocation 
  #' by David B. Dahl.
  #' @export

  As = lapply(Zs, pairwise_alloc)
  A_mean = matApply(As, mean)
  mse = sapply(As, function(A) mean((A-A_mean)^2))

  if (!returnIndex) {
    Zs[[which.min(mse)]]
  } else {
    which.min(mse)
  }
}

#set.seed(1)
##J <- 5; K <- 3
#J <- 32; K <- 10
#Z <- matrix(rbinom(J*K, 1, c(.6,.4)), J, K)
#Zs <- rep(list(Z), 200)
#system.time(A <- pairwise_alloc(Z))
#system.time(lapply(Zs, pairwise_alloc))
#
#Z
#A
