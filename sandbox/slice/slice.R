### Slice sampler is good when number of aux variables is small (< 50)
### In this logistic regression example, N=50. Slice sampling is good.
### If N >> 50, then mixing is a bit slow. But still works.

library(rcommon)
library(truncnorm)
source('../mcmc/mcmc.R')
set.seed(1)

b0 = 3
b1 = 5
N = 50
x = rnorm(N)
p = sigmoid(b0 + b1 * x)
y = rbinom(N, 1, p)

plot(x, logit(p))
s = 3

mod = glm(y ~ x, family='binomial')
plot(x,y)
summary(mod)
#plot(mod)

update = function(state) {
  # update b0
  update_b0 = function(state) {
    # update u
    p = sigmoid(state$b0 + state$b1 * x)
    g = dbinom(y, 1, p)
    u = runif(N, 0, g)

    # update b0
    a = log(1/u - 1)
    b = state$b1 * x
    z = ifelse(y==1, -a-b, a-b)
    min_z = min(z[which(y == 0)])
    max_z = max(z[which(y == 1)])

    b0 = rtruncnorm(1, max_z, min_z, 0, s)

    return(b0)
  }

  update_b1 = function(state) {
    # update u
    p = sigmoid(state$b0 + state$b1 * x)
    g = dbinom(y, 1, p)
    u = runif(N, 0, g)

    # update b1
    a = log(1/u - 1)
    z = ifelse(y==1, (-a-state$b0) / x, (a-state$b0) / x)
    min_z = min(z[which(y == 0 & x > 0 | y == 1 & x < 0)])
    max_z = max(z[which(y == 1 & x > 0 | y == 0 & x < 0)])

    b1 = rtruncnorm(1, max_z, min_z, 0, s)

    return(b1)
  }

  state$b0=update_b0(state)
  state$b1=update_b1(state)
  state
}

out = gibbs(init=list(b0=0,b1=b1), update, B=10000, burn=2000, print_every=100)
#print(p)
b0_out = sapply(out, function(o) o$b0)
b1_out = sapply(out, function(o) o$b1)
plotPost(b0_out,float=TRUE); abline(v=b0, lty=2); abline(v=mod$coef[1], col='blue')
plotPost(b1_out,float=TRUE); abline(v=b1, lty=2); abline(v=mod$coef[2], col='blue')

effectiveSize(as.mcmc(b0_out))
raftery.diag(as.mcmc(b1_out))
