#' @export
model.inits = function(y, N, K=10, L=5) {
  J = NCOL(y)
  I = length(N)
  y.init = y
  y.init[which(is.na(y))] <- mean(y[y<0], na.rm=TRUE)
  y.init[-which(is.na(y))] <- NA

  list(gam=matrix(1, sum(N), J),
       lam=rep(1,sum(N)),
       Z0=matrix(rbinom(J*K,1,.5),J,K),
       W=matrix(1/K, I, K),
       v=rep(1/K,K),
       y=y.init,
       alpha=1,
       sig2=rep(1,I),
       eta=array(1/L, dim=c(2,I,J,L)),
       mus=rbind(rep(-3,L), rep(3,L)))
}
