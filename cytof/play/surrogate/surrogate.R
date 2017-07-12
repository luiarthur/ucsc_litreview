set.seed(1)
source("gp.R")
library(fields)
library(rcommon)

mu_true <- 3
sig2_true <- 2
N <- 10000
y <- rnorm(N, mu_true, sqrt(sig2_true))
mu_range <- c(-10,10)
sig2_range <- c(1,10)

m <- 15
mu_grid <- seq(mu_range[1], mu_range[2], len=m)
sig2_grid <- seq(sig2_range[1], sig2_range[2], len=m)
param_grid <- as.matrix(expand.grid(mu_grid, sig2_grid))
D <- dist(param_grid)

ll <- sapply(1:nrow(param_grid), function(i) sum(dnorm(y, param_grid[i,1], sqrt(param_grid[i,2]), log=TRUE)))

#quilt.plot(param_grid[,1], param_grid[,2], ll, ylab='sig2', xlab='mu')
#i.max <- which.max(ll)
#points(param_grid[i.max,1], param_grid[i.max,2], pch=4, cex=3, lwd=3, col='grey85')


out <- gp(ll, param_grid)
new_param <- cbind(runif(1000, mu_range[1], mu_range[2]), runif(1000, sig2_range[1], sig2_range[2]))
new_ll <- sapply(1:nrow(new_param), function(i) sum(dnorm(y, new_param[i,1], sqrt(new_param[i,2]), log=TRUE)))
p <- gp.pred(new_param, gp=out)
mu_ci <- cbind(p$mu - 2*sqrt(diag(p$Sig)), p$mu + 2*sqrt(diag(p$Sig)))

plot(new_ll, p$mu, pch=20)
add.errbar(mu_ci, x=new_ll, col=rgb(1,0,0,.3))
abline(0, 1, col='grey')

print(param_grid[i.max,])
print(new_param[which.max(p$mu),])

