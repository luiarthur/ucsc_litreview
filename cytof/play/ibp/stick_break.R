ibp_sb <- function(N,a=1,K=10) {
  v <- rbeta(K,a,1)
  b <- cumprod(v)

  t(sapply(1:N, function(bk) rbinom(K,1,cumprod(rbeta(K,a,1)) )))
}

image(t(Z <- ibp_sb(100,a=5,K=100)))
hist(rowSums(Z)); abline(v = mean(rowSums(Z)),lwd=3)
mean(rowSums(Z))
var(rowSums(Z))
colSums(Z)
