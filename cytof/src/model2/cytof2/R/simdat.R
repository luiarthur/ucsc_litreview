invgamma_ab <- function(mu,sig) {
  #' Get the parameter values for inv-gamma distribution given mean and sd.
  #' Parameterization: mu = b / (a-1)
  #' @export
  a <- (mu / sig)^2 + 2
  b <- mu * (a-1)
  c(a,b)
}

extendZ <- function(Z,K) {
  #' Extend (or shrink) the columns of Z to have exactly K columns
  #' @export

  if (NCOL(Z) > K) {
    Z[,1:K]
  } else if (NCOL(Z) < K) {
    extendZ(cbind(Z,0), K)
  } else {
    Z
  }
}

matApply <- function(mat_ls, f) {
  #' Apply a function to a list of matrices
  #' @export
  apply(simplify2array(mat_ls), 1:2, f)
}

last <- function(lst) {
  #' @export
  lst[[length(lst)]]
}

left_order <- function(Z) {
  #' @export
  order(apply(Z, 2, function(z) paste0(as.character(z), collapse='')), decreasing=TRUE)
}

rowSort <- function(arr) {
  #' @export
  arr[do.call(order, lapply(1:NCOL(arr), function(i) arr[, i])), ]
}

genZ <- function(J,K,prob=c(.4,.6)) {
  #' @export
  Z <- sample(0:1, J*K, replace=TRUE, prob=prob)
  Z <- matrix(Z, J, K, byrow=TRUE)
  Z <- rowSort(Z)
  Z <- Z[, left_order(Z)]

  if (all(rowSums(Z) > 0)) Z else genZ(J,K,prob)
}

genSimpleZ <- function(J, K) {
  #diag(K) %x% rep(1, J/K)
  g <- J %/% K
  Z <- matrix(0, J, K)
  for (k in 1:K) {
    lo <- g * (k-1) + 1
    hi <- ifelse(k==K, Inf, g * k)
    for (j in 1:J) {
      if (j >= lo && j <= hi) Z[j,k] <- 1
    }
  }
  Z <- rowSort(Z)
  Z[, left_order(Z)]
}

simdat <- function(I, N, J, K, W, Z=genZ(J,K),
                   b0=matrix(-17.6,I,J),
                   b1=rep(4.4,J),
                   gams_0=matrix(1/rgamma(I*J, 40, 20), nrow=I),
                   sig2=matrix(1/rgamma(I*J, 3, 1), nrow=I),
                   psi_0=-1, psi_1=1,
                   tau2_0=3, tau2_1=3) {
  #' Generate simulation data
  #' @examples
  #' W <- matrix(c(.3, .4, .2, .1,
  #'               .1, .7, .1, .1,
  #'               .2, .3, .3, .2), nrow=3, byrow=TRUE)
  #' out <- simdat(I=3, N=c(20,30,10), J=12, K=4, Z=genZ(12, 4, c(.4,.6)), W=W,
  #'               thresh=-2)
  #' @export
  stopifnot(NROW(Z)==J && NCOL(Z)==K)
  stopifnot(NROW(W)==I && NCOL(W)==K)

  lam <- lapply(1:I, function(i) sample(1:K, N[[i]], prob=W[i,], replace=TRUE))
  lam_base0 <- lapply(1:I, function(i) lam[[i]] - 1)

  mus_0 = RcppTN::rtn(.mean=rep(psi_0,I*J),
                      .sd=rep(sqrt(tau2_0), I*J),
                      .lo=rep(-Inf,I*J), .hi=rep(0,I*J))
  mus_1 = RcppTN::rtn(.mean=rep(psi_1,I*J),
                      .sd=rep(sqrt(tau2_1), I*J),
                      .lo=rep(0,I*J), .hi=rep(Inf,I*J))
  mus_0 <- matrix(mus_0, nrow=I)
  mus_1 <- matrix(mus_1, nrow=I)

  mu <- function(i, n, j) ifelse(Z[j, lam[[i]][n]] == 0, mus_0[i,j], mus_1[i,j])
  gam <- function(i, n, j) ifelse(Z[j, lam[[i]][n]] == 0, gams_0[i,j], 0)

  p <- function(b0,b1,y) {
    x <- b0 - b1*y
    1 / (1+exp(-x))
  }
  
  y <- as.list(1:I)
  y_no_missing <- y
  for (i in 1:I) {
    Ni <- N[[i]]
    y[[i]] <- matrix(NA, Ni, J)
    y_no_missing[[i]] <- y[[i]]
    for (n in 1:Ni) {
      for (j in 1:J) {
        y_inj <- rnorm(1, mu(i,n,j), sqrt((1+gam(i,n,j))*sig2[i,j]))
        y_no_missing[[i]][n,j] <- y_inj

        prob_miss <- p(b0[i,j], b1[j], y_inj)
        y[[i]][n, j] <- ifelse(prob_miss > runif(1), NA, y_inj)
      }
    }
  }

  list(Z=Z, lam=lam, mus_0=mus_0, mus_1=mus_1, y=y, I=I, N=N, J=J, K=K,
       gams_0=gams_0, psi_0=psi_0, psi_1=psi_1, sig2=sig2, tau2_0=tau2_0,
       tau2_1=tau2_1, W=W, y_no_missing=y_no_missing, b0=b0, b1=b1,
       lam_base0=lam_base0)
}

### TEST ###
#W <- matrix(c(.3, .4, .2, .1,
#              .1, .7, .1, .1,
#              .2, .3, .3, .2), nrow=3, byrow=TRUE)
#out <- simdat(I=3, N=c(20,30,10), J=12, K=4, Z=genZ(12, 4, c(.4,.6)), W=W,
#              thresh=-2)
