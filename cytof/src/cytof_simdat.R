library(truncnorm)
### y_i: N_i x J

cytof_simdat <- function(I, N, J, K, W, thresh=log(2),
                         pi_a=rep(.5,J), pi_b=1,
                         #psi=rnorm(J,.5,1),
                         a=1,
                         tau2=1/rgamma(J,3,.2),
                         sig2=1/rgamma(I,3,2)
                         ) {
  stopifnot(length(N) == I)
  stopifnot(nrow(W) == I && ncol(W) == K)
  stopifnot(all(rowSums(W) == 1))
  #stopifnot(length(psi) == J)
  stopifnot(length(tau2) == J)
  stopifnot(J %% K == 0)

  Z <- diag(K) %x% rep(1, J/K)

  lam <- lapply(1:I, function(i)
                sample(1:K, N[[i]], prob=W[i,], replace=TRUE))
  mus <- matrix(NA, J, K)
  for (j in 1:J) {
    for (k in 1:K) {
      if (Z[j,k] == 0) {
        #mus[j,k] <- rtruncnorm(1, -Inf, thresh, psi[j], sqrt(tau2[j]))
        mus[j,k] <- rtruncnorm(1, -Inf, thresh, log(2)-a, sqrt(tau2[j]))
      } else { # Z[j,k] == 1
        #mus[j,k] <- rtruncnorm(1, thresh,  Inf, psi[j], sqrt(tau2[j]))
        mus[j,k] <- rtruncnorm(1, thresh, Inf, log(2)+a, sqrt(tau2[j]))
      }
    }
  }

  pi_var <- matrix(rbeta(I*J, pi_a, pi_b), I, J)

  y <- as.list(1:I)
  for (i in 1:I) {
    Ni <- N[[i]]
    y[[i]] <- matrix(NA, Ni, J)
    for (n in 1:Ni) for (j in 1:J) {
      lin <- lam[[i]][n]
      y[[i]][n,j] <- if (Z[j,lin] == 1 || 1-pi_var[i,j] > runif(1)) {
        rtruncnorm(1, 0, Inf, mus[j,lin], sqrt(sig2[i]))
      } else 0
    }
  }


  list(Z=Z, lam=lam, mus=mus, tau2=tau2, W=W, pi_var=pi_var,
       I=I, N=N, J=J, K=K, thresh=thresh, y=y, sig2=sig2, a, #psi=psi,
       lam_index_0=lapply(lam, function(l) l-1))
}
