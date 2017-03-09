ibp_sb <- function(N,a=1,K=10) {
  v <- rbeta(K,a,1)
  b <- cumprod(v)

  sapply(b, function(bk) rbinom(N,1,bk))
}

image(t(Z <- ibp_sb(100,a=5,K=50)))
rowSums(Z)
colSums(Z)
