source("mcmc.R")
library(rcommon)


N = 1000
b = c(2, -2)
y = rnorm(N, 0, 10)
m = rbinom(N, 1, inv_logit(b[1] + b[2] * y))
y_dat = ifelse(m == 1, NA, y)
#plot(y, y)
hist(y, col=rgb(0,0,1,.3)); hist(y_dat, add=TRUE, col=rgb(1,0,0,.3))

#xx = seq(min(x), max(x),l=100)
#plot(xx, inv_logit(b[1] + b[2]*xx))


