compute_loglike = function(state, y, normalize=TRUE) {
  I = length(y)
  J = NCOL(y[[1]])
  N = sapply(y, NROW)

  ll = 0
  for (i in 1:I) for (j in 1:J) {
    k = state$lam[[i]]
    z = state$Z[j,k]
    gam = state$gam[[i]][,j]
    mu = sapply(1:N[i], function(n)
                ifelse(z[n] == 0, state$mus_0[gam[n]], state$mus_1[gam[n]]))
    sig2 = sapply(1:N[i], function(n)
                  ifelse(z[n] == 0, state$sig2_0[i,gam[n]], state$sig2_1[i,gam[n]]))
    ll = ll + sum(dnorm(y[[i]][,j], mu, sqrt(sig2), log=TRUE))
  }

  ifelse(normalize, ll / sum(N), ll)
}
