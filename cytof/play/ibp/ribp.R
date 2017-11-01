ribp <- function(N,K,a) {
  v <- rbeta(K, a, 1)
  p <- cumprod(v)
  #print(p)
  matrix(rbinom(N*K, 1, p), N, K, byrow=TRUE)
}

x <- sapply(1:1000, function(i) {
  Z <- ribp(100,20,3)
  mean(rowSums(Z))
})
#image(t(Z))
