postpred = function(out) {
  # Based on (B) MCMC samples, return a list (length I) of matrices (B x J) 
  # of posterior predictives samples

  mus0 = lapply(out, function(o) o$mus[,,1])
  mus1 = lapply(out, function(o) o$mus[,,2])

  I = NROW(mus0[[1]])
  J = NCOL(mus0[[1]])
  B = length(out)

  gams0 = lapply(out, function(o) o$gams_0)
  sig2 = lapply(out, function(o) o$sig2)
  W = lapply(out, function(o) o$W)
  Z = lapply(out, function(o) o$Z)
  est_idx = estimate_Z(Z, returnIndex=TRUE)
  W_est = W[[est_idx]]
  Z_est = Z[[est_idx]]
  K = NCOL(W_est)

  # Y posterior predictive
  Y_pp = lapply(as.list(1:I), function(i) matrix(NA, B, J))
  cell_type = lapply(as.list(1:I), function(i)
                     sort(sample(1:K, B, prob=W_est[i,], replace=TRUE)))

  for (i in 1:I) {
    for (j in 1:J) {
      mus0_ij = sapply(mus0, function(m0) m0[i,j])
      mus1_ij = sapply(mus1, function(m1) m1[i,j])
      gams0_ij = sapply(gams0, function(g0) g0[i,j])
      sig2_ij = sapply(sig2, function(s2) s2[i,j])
      Z_jk = Z_est[j,cell_type[[i]]]
      m = ifelse(Z_jk == 1, mus1_ij, mus0_ij)
      v = ifelse(Z_jk == 1, sig2_ij, sig2_ij * (1 + gams0_ij))
      Y_pp[[i]][,j] = rnorm(B, m, sqrt(v))
    }
  }

  list(y=Y_pp, W_est=W_est, Z_est=Z_est, cell_type=cell_type)
}

