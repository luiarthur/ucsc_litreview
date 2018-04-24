#' @export
left_order <- function(Z) {
  order(apply(Z, 2, function(z) paste0(as.character(z), collapse='')), decreasing=TRUE)
}

#' @export
rowSort <- function(arr) {
  arr[do.call(order, lapply(1:NCOL(arr), function(i) arr[, i])), ]
}

  
#' @export
genSimpleZ <- function(J, K) {
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

#' @export
genZ <- function(J,K,prob1=c(.6)) {
  stopifnot(prob1 > 0 && prob1 < 1)
  Z <- sample(0:1, J*K, replace=TRUE, prob=c(1-prob1, prob1))
  Z <- matrix(Z, J, K, byrow=TRUE)
  Z <- rowSort(Z)
  Z <- Z[, left_order(Z)]

  if (all(rowSums(Z) > 0)) Z else genZ(J,K,prob1)
}


#' @export
rdirichlet = function(a) {
  x = rgamma(length(a), a, 1)
  x / sum(x)
}

#' Simulate Data
#' @description Given some metrics, generate data y, and simulation truth of parameters
#' @export
sim_dat = function(I, J, N, K, L0, L1,
                   mmp=miss_mech_params(c(-6, -2.5, -1),c(.1,.99,.001)),
                   Z=genSimpleZ(J,K),
                   sig2_0=matrix(.1, I, L0), sig2_1=matrix(.1, I, L1),
                   mus_0=seq(-5,-1,length=L0), mus_1=seq(1,5,length=L1),
                   a_W=1:K, a_eta0=1:L0, a_eta1=1:L1, sort_lambda=FALSE) {

  # Check Z dimensions
  stopifnot(NCOL(Z) == K && NROW(Z) == J)

  # Check N dimensions
  stopifnot(all(N > 0))
  stopifnot(length(N) == I)

  # Check sig2 dimensions
  stopifnot(all(sig2_0 > 0) && all(sig2_1 > 0))
  stopifnot(all( dim(sig2_0) == c(I, L0) ))
  stopifnot(all( dim(sig2_1) == c(I, L1) ))

  # Check mus dimensions
  stopifnot(all(mus_0 < 0) && all(mus_1 > 0))
  stopifnot(length(mus_0) == L0 && length(mus_1) == L1)

  # Check a_W dimensions
  stopifnot(length(a_W) == K)
  stopifnot(all(a_W > 0))

  # Check a_eta dimensions
  stopifnot(length(a_eta0) == L0)
  stopifnot(length(a_eta1) == L1)
  stopifnot(all(a_eta0 > 0))
  stopifnot(all(a_eta1 > 0))

  # Simulate W
  W = matrix(NA, I, K)
  for (i in 1:I) {
    W[i,] = rdirichlet(sample(a_W))
  }

  # Simulate lambda
  lam = sapply(1:I, function(i) {
    sample(1:K, N[i], prob=W[i,], replace=TRUE)
  })
  if (sort_lambda) {
    lam = lapply(lam, sort)
  }

  # Simulate eta
  eta_0 = array(dim=c(I,J,L0))
  eta_1 = array(dim=c(I,J,L1))
  for (i in 1:I) for (j in 1:J) {
    eta_0[i,j,] = rdirichlet(sample(a_eta0))
    eta_1[i,j,] = rdirichlet(sample(a_eta1))
  }

  # Simulate gam
  gam = sapply(N, function(Ni) matrix(NA, Ni, J))
  for (i in 1:I) for (j in 1:J) for (n in 1:N[i]) {
    z = Z[j, lam[[i]][n]]
    Lz = ifelse(z == 0, L0, L1)
    eta_z = if (z==0) eta_0[i,j,] else eta_1[i,j,]
    gam[[i]][n,j] = sample(1:Lz, 1, prob=eta_z)
  }

  # Generate y
  y = sapply(N, function(Ni) matrix(NA, Ni, J))
  y_complete = y

  mu_inj = function(z_inj, gam_inj) {
    l = gam_inj
    ifelse(z_inj == 0, mus_0[l], mus_1[l])
  }

  sig_inj = function(i, z_inj, gam_inj) {
    l = gam_inj
    sqrt(ifelse(z_inj == 0, sig2_0[i, l], sig2_1[i, l]))
  }

  for (i in 1:I) {
    for (j in 1:J) {
      z_ij = Z[j, lam[[i]]]
      gam_ij = gam[[i]][,j]
      mu_ij = sapply(1:N[i], function(n) mu_inj(z_ij[n], gam_ij[n]))
      sig_ij = sapply(1:N[i], function(n) sig_inj(i, z_ij[n], gam_ij[n]))
      y_complete[[i]][,j] = rnorm(N[i], mu_ij, sig_ij)
      p_miss = prob_miss(y_complete[[i]][,j], mmp['b0'], mmp['b1'],
                         mmp['c0'], mmp['c1'])
      y[[i]][,j] = ifelse(p_miss > runif(N[i]),NA, y_complete[[i]][,j])
    }
  }

  list(y=y, y_complete=y_complete, Z=Z, W=W,
       eta_0=eta_0, eta_1=eta_1, mus_0=mus_0, mus_1=mus_1,
       sig2_0=sig2_0, sig2_1=sig2_1, lam=lam, gam=gam,
       b0=mmp['b0'], b1=mmp['b1'], c0=mmp['c0'], c1=mmp['c1'])
}


### Test ###
#I=3; J=32; K=10
#dat = sim_dat(I=I, J=J, N=c(300,200,100), K=K, L0=4, L1=5, Z=genZ(J,K,prob=.5))
##I=3; J=32; K=8
##dat = sim_dat(I=I, J=J, N=c(300,200,100), K=K, L0=4, L1=5, Z=genSimpleZ(J,K))
#
#hist(dat$y_complete[[1]][,1], xlim=c(-7,7), col=rgb(0,0,1,.5), border='transparent')
#hist(dat$y[[1]][,1], add=TRUE, col=rgb(1,0,0,.5),border='transparent')
#
#plot_dat(dat$y_complete, i=1, j=16, xlim=c(-7,7))
#
#my.image(dat$Z)
