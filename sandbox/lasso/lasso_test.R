library(rcommon)
library(fields)

N <- 30
b <- c(200, 1)
K <- length(b)
X <- matrix(rnorm(N*K), nrow=N)
sig2 <- 1
y <- X %*% b + rnorm(N, 0, sqrt(sig2))

my.pairs(cbind(y, X))

laplace_lpdf <- function(x, m, s) {
  -abs(x - m) / s
}

cost_laplace <- function(b) {
  sum(dnorm(y, X %*% b, sqrt(sig2), log=TRUE)) + sum(laplace_lpdf(b, 0, 1))
}

cost_normal <- function(b) {
  sum(dnorm(y, X %*% b, sqrt(sig2), log=TRUE)) + sum(dnorm(b, 0, 1))
}

L <- 100
b_grid <- expand.grid(seq(-max(b), max(b), l=L), seq(-max(b), max(b), l=L))

### Laplace Prior
g_laplace <- apply(b_grid, 1, cost_laplace)
g_laplace.imax <- which.max(g_laplace)

### Normal Prior
g_normal <- apply(b_grid, 1, cost_normal)
g_normal.imax <- which.max(g_normal)

### PLOT
par(mfrow=c(3,1))
### LAPLACE
quilt.plot(b_grid[,1], b_grid[,2], g_laplace)
points(b_grid[g_laplace.imax,1], b_grid[g_laplace.imax,2], pch=4, lwd=3, cex=3)
abline(v=b_grid[g_laplace.imax,1])
abline(h=b_grid[g_laplace.imax,2])
### NORMAL
quilt.plot(b_grid[,1], b_grid[,2], g_normal)
points(b_grid[g_normal.imax,1], b_grid[g_normal.imax,2], pch=4, lwd=3, cex=3)
abline(v=b_grid[g_normal.imax,1])
abline(h=b_grid[g_normal.imax,2])
### DIFF
quilt.plot(b_grid[,1], b_grid[,2], g_laplace-g_normal)
par(mfrow=c(1,1))


print(b_grid[c(g_laplace.imax, g_normal.imax), ])
