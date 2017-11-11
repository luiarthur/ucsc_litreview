### Wikipedia Parameterization: location (m) and scale (s)

# Euler-Mascheroni constant
gumble.g <- euler_masc <- -digamma(1)
mean.gumbel <- function(m, s) m + s * gumble.g
sd.gumbel <- function(m, s) (pi * s) / sqrt(6)
var.gumbel <- function(m,s) sd.gumbel(m,s) ^ 2


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

x <- rgumbel(100000, 2, 3)
hist(x, col=rgb(1,0,0,.4), border='white',
     main=paste0('mean: ',round(mean(x),2),'; , sd(x): ', round(sd(x),2)))
abline(v=mean(x), lwd=3, col='red')
mean.gumbel(2,3)
sd.gumbel(2,3)
