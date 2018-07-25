library(nimble)
library(rcommon)
set.seed(1)

model.code = nimbleCode({
  for (i in 1:I) {
    y[i] ~ dnorm(mu, var=sig2)
    m[i] ~ dbern( p[i])
    logit(p[i]) <- b0 + b1 * y[i]
  }
  mu ~ dnorm(m_mu, var=s2_mu)
  sig2 ~ dinvgamma(a, b)
  b0 ~ dnorm(m_b0, s2_b0)
  b1 ~ dnorm(m_b1, s2_b1)
})

logit = function(p) log(p) - log(1-p)
sigmoid = function(x) 1 / (1 + exp(-x))

### Data ###
N = 300
mu = 1
sig2 = 2
y_true = rnorm(N, mu, sig2)
b0 = -1; b1 = -3
hist(y_true)
p_true = sigmoid(b0 + b1 * y_true)
plot(y_true, p_true)
m = rbinom(N, 1, p_true)
y = ifelse(m, NA, y_true)
hist(y)

### Model data, constants, and inits
model.data = list(m=m, y=y)
model.consts = list(m_mu=0, s2_mu=100, a=2, b=1, I=length(y),
                    #m_b0=0, m_b1=-3, s2_b0=3, s2_b1=.01, cc=-5)
                    m_b0=-1, m_b1=-3, s2_b0=1, s2_b1=1)
                    #b0=-1, b1=-3, cc=-5)

plot(seq(-10,10,l=100), 
     #sigmoid(model.consts$b0+model.consts$b1*(seq(-10,10,l=100)-model.consts$cc)^2),
     sigmoid(model.consts$m_b0+model.consts$m_b1*seq(-10,10,l=100)),
     type='l')

y.init = y
idx.na = which(is.na(y.init))
y.init[idx.na] <- rnorm(length(idx.na))
y.init[-idx.na] <- NA
model.inits = list(y=y.init, mu=0, sig2=1, b0=0, b1=0, p=rep(.5,length(y)))

### Compile Model ###
model = nimbleModel(model.code, data=model.data, constants=model.consts, inits=model.inits)
cmodel = compileNimble(model)

model.conf = configureMCMC(model, print=TRUE)
model.conf$addMonitors(c('y'))
model.mcmc = buildMCMC(model.conf)
cmodel = compileNimble(model.mcmc, project=model)
out = runMCMC(cmodel, summary=TRUE, niter=20000, nburnin=19000)


### Summary ###
non_y = 4
plotPosts(out$samples[,1:non_y])
plotPosts(out$samples[,(non_y+idx.na)[1:4]])
hist(out$summary[-c(1:non_y),1], prob=TRUE, col=rgb(1,0,0,.4), border='transparent', xlim=c(-6,6))
hist(y_true, add=TRUE, prob=TRUE, col=rgb(0,0,1,.4), border='transparent')

hist(out$summary[-c(1:non_y),1][idx.na], prob=TRUE, col=rgb(1,0,0,.4),border='transparent', xlim=c(-6,6))
#hist(out$samples[1,-c(1:non_y)][idx.na], prob=TRUE, col=rgb(1,0,0,.4),border='transparent', xlim=c(-6,6))
hist(y_true[idx.na], prob=TRUE, col=rgb(0,0,1,.4),border='transparent', add=TRUE)

