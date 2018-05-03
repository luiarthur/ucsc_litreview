library(rcommon)
library(truncnorm)
source('../mcmc/mcmc.R')
set.seed(1)

b0 = 3
b1 = 4
N = 300
x = rnorm(N)
p = sigmoid(b0 + b1 * x)
y = rbinom(N, 1, p)

plot(x, logit(p))

mod = glm(y ~ x, family='binomial')
plot(x,y)
#plot(mod)

update = function(state) {
  # update b0
  update_b0 = function(state) {
    # update u
    p = sigmoid(state$b0 + state$b1 * x)
    #g = ifelse(y == 1, p, 1-p)
    g = dbinom(y, 1, p)
    u = runif(N, 0, g)

    # update b0
    a = log(1/u - 1)
    b = state$b1 * x
    z = ifelse(y==1, -a-b, a-b)
    min_z = min(z)
    b0 = rtruncnorm(1, -Inf, min_z, 0, 10)
    #b0 = runif(1, -5, min(5, min_z))

    return(b0)
  }

  state$b0=update_b0(state)
  #print(state$b0)
  #state=update_b1(state)
  state
}

out = gibbs(init=list(b0=b0,b1=b1), update, B=200, burn=200, print_every=10)
#print(p)
b0_out = sapply(out, function(o) o$b0)
plotPost(b0_out)
