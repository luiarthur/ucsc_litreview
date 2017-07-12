logdet <- function(X) {
  determinant(X)$mod[1]
}

logdmvnorm <- function(y, mu, Sigma) {
  x <- y - mu
  as.numeric(-0.5 * (logdet(Sigma) + t(x) %*% solve(Sigma) %*% x))
}

gp <- function(y, X, m0=0, alpha0=1, phi0=1, ...) {
  D <- as.matrix(dist(X))

  neg_ll <- function(param) {
    if (param[2] <= 0 || param[3] <= 0) {
      Inf
    } else {
    -logdmvnorm(y, param[1], param[2] * exp(-D/param[3]))
    }
  }

  opt <- optim(par=c(m0, alpha0, phi0), neg_ll, ...)

  m <- opt$par[1]
  alpha <- opt$par[2]
  phi <- opt$par[3]
  K.i <- solve(alpha * exp(-D / phi))
  R <- K.i %*% (y - m)

  list(y=y, X=X, opt=opt, K.i=K.i, R=R, m=m, alpha=alpha, phi=phi)
}

gp.pred <- function(X_new, gp) {
  m <- gp$m
  alpha <- gp$alpha
  phi <- gp$phi
  K.i <- gp$K.i
  R <- gp$R

  nnew <- nrow(X_new)
  n <- nrow(gp$X)

  D <- as.matrix(dist(rbind(X_new, gp$X)))
  D_new <- D[1:nnew, 1:nnew]
  D_new_old <- D[1:nnew, -c(1:nnew)]

  K.star <- alpha * exp(-D_new / phi)
  C <- matrix(alpha * exp(-D_new_old / phi), nrow=nnew)

  mu_star <- m + C %*% R
  Sig_star <- K.star - C %*% K.i %*% t(C)

  list(mu=mu_star, Sig=Sig_star)
}
