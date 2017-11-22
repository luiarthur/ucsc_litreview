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



simdat <- function(I, N, J, K, W, Z=genZ(J,K),
                   gams_0=matrix(1/rgamma(I*J, 3, .1), nrow=I),
                   sig2=matrix(1/rgamma(I*J, 3, 1), nrow=I),
                   psi_0=-1, psi_1=1,
                   tau2_0=2, tau2_1=1,
                   thresh=-5) {
  #' Generate simulation data
  #' @examples
  #W <- matrix(c(.3, .4, .2, .1,
  #              .1, .7, .1, .1,
  #              .2, .3, .3, .2), nrow=3, byrow=TRUE)
  #out <- simdat(I=3, N=c(20,30,10), J=12, K=4, Z=genZ(12, 4, c(.4,.6)), W=W,
  #              thresh=-2)
  #' @export
  stopifnot(NROW(Z)==J && NCOL(Z)==K)
  stopifnot(NROW(W)==I && NCOL(W)==K)

  lam <- lapply(1:I, function(i) sample(1:K, N[[i]], prob=W[i,], replace=TRUE))

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
  
  y <- as.list(1:I)
  for (i in 1:I) {
    Ni <- N[[i]]
    y[[i]] <- matrix(NA, Ni, J)
    for (n in 1:Ni) for (j in 1:J) {
      lin <- lam[[i]][n]
      y[[i]][n, j] <- rnorm(1, mu(i,n,j), sqrt((1+gam(i,n,j))*sig2[i,j]))
    }
    y[[i]] <- ifelse(y[[i]] < thresh, NA, y[[i]])
  }

  list(Z=Z, lam=lam, mus_0=mus_0, mus_1=mus_1, y=y, I=I, N=N, J=J, K=K,
       gams_0=gams_0, psi_0=psi_0, psi_1=psi_1, sig2=sig2, tau2_0=tau2_0,
       tau2_1=tau2_1, W=W, thresh=thresh)
}

### TEST ###
#W <- matrix(c(.3, .4, .2, .1,
#              .1, .7, .1, .1,
#              .2, .3, .3, .2), nrow=3, byrow=TRUE)
#out <- simdat(I=3, N=c(20,30,10), J=12, K=4, Z=genZ(12, 4, c(.4,.6)), W=W,
#              thresh=-2)
