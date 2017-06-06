library(truncnorm)
### y_i: N_i x J

cytof_simdat <- function(I, N, J, K, thresh=log(2), psi, tau2, W, sig2,
                         p=.3) {
  stopifnot(length(N) == I)
  stopifnot(nrow(W) == I && ncol(W) == K)
  stopifnot(all(rowSums(W) == 1))
  stopifnot(length(psi) == J)
  stopifnot(length(tau2) == J)

  Z <- matrix(NA, J, K)
  valid_Z <- FALSE
  while(!valid_Z) {
    Z <- matrix(rbinom(J*K, size=1, prob=p), J, K)
    if ( all(colSums(Z) >= 1) && ncol(unique(Z, MAR=2)) ) {
      valid_Z <- TRUE
    }
  }

  lam <- lapply(1:I, function(i)
                sample(1:K, N[[i]], prob=W[i,], replace=TRUE))
  mus <- matrix(NA, J, K)
  for (j in 1:J) {
    for (k in 1:K) {
      if (Z[j,k] == 0) {
        mus[j,k] <- rtruncnorm(1, -Inf, thresh, psi[j], sqrt(tau2[j]))
      } else { # Z[j,k] == 1
        mus[j,k] <- rtruncnorm(1, thresh,  Inf, psi[j], sqrt(tau2[j]))
      }
    }
  }

  y <- as.list(1:I)
  for (i in 1:I) {
    Ni <- N[[i]]
    y[[i]] <- matrix(NA, Ni, J)
    for (n in 1:Ni) for (j in 1:J) {
      y[[i]][n,j] <-
        rtruncnorm(1, 0, Inf, mus[j, lam[[i]][n]], sqrt(sig2[i]))
    }
  }

  list(Z=Z, lam=lam, mus=mus, psi=psi, tau2=tau2, W=W,
       I=I, N=N, J=J, K=K, thresh=thresh, y=y, sig2=sig2)
}
