### Wikipedia Parameterization: location (m) and scale (s)
dgumbel <- function(x, m, s) {
  z <- (x - m) / s
  exp(-z - exp(-z)) / s
}

pgumbel <- function(x, m, s) {
  exp(-exp(-(x - m) / s))
}

rgumbel <- function(n, m, s) {
  u <- runif(n)
  m - s * log(-log(u))
}

### Tests
n <- 1e6
par(mfrow=c(2,1))
hist(-rgumbel(n, 2, 3), prob=T, border='white', col=rgb(0,0,1,.4))
curve(dgumbel(-x, 2, 3),lwd=2, add=TRUE, col='blue')
curve(pgumbel(-x, 2, 3), from=-50, to=5)
par(mfrow=c(1,1))

