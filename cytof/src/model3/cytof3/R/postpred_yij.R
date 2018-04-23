#' @export
postpred_yij = function(out, i, j) {
  sapply(out, function(o) {
    k = sample(1:prior$K, 1, prob=o$W[i,])
    z_jk = o$Z[j,k]
    eta_z = if (z_jk == 0) o$eta_0[i,j,] else o$eta_1[i,j,]
    mus_z = if (z_jk == 0) o$mus_0 else o$mus_1
    sig2_z = if (z_jk == 0) o$sig2_0[i,] else o$sig2_1[i,]
    Lz = length(mus_z)
    l = sample(1:Lz, 1, prob=eta_z)
    rnorm(1, mus_z[l], sqrt(sig2_z[l]))
  })
}
