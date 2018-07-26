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
  sig2 ~ dinvgamma(a, scale=b)
  b0 ~ dnorm(m_b0, var=s2_b0)
  b1 ~ dnorm(m_b1, var=s2_b1)
})

logit = function(p) log(p) - log(1-p)
sigmoid = function(x) 1 / (1 + exp(-x))
solve_b = function(y, p) {
  stopifnot(length(y) == 2 && length(p) == 2)
  b1 = diff(logit(p)) / diff(y)
  b0 = logit(p[1]) - b1 * y[1]
  c(b0, b1)
}

### Data ###
N = 500
mu = 1
sig2 = 2
y_true = rnorm(N, mu, sig2)
b_true = solve_b(y=c(-1, -.5), p=c(.99, .01))
b0 = b_true[1]; b1 = b_true[2]
hist(y_true)
p_true = sigmoid(b0 + b1 * y_true)
plot(y_true, p_true)
m = rbinom(N, 1, p_true)
y = ifelse(m, NA, y_true)
hist(y)

### Model data, constants, and inits
b = solve_b(y=c(min(y,na.rm=TRUE), -.1), p=c(.99, .0001))
model.data = list(m=m, y=y)
model.consts = list(m_mu=0, s2_mu=10, a=301, b=300, I=length(y),
                    m_b0=b[1], m_b1=b[2], s2_b0=.1, s2_b1=.1)

plot(seq(-5,5,l=100), 
     sigmoid(model.consts$m_b0+model.consts$m_b1*seq(-5,5,l=100)),
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

# Posterior of b, mu, sig2
plotPosts(out$samples[,1:non_y])

# Posterior of first 4 missing y
plotPosts(out$samples[,(non_y+idx.na)[1:4]])

# Posterior distribution of complete data
dens = apply(out$sample[, -c(1:non_y)], 1, density)
plot(dens[[1]], col=rgb(0,0,1,.01), xlim=c(-10,10), 
     ylim=c(0,max(sapply(dens, function(d) max(d$y)))),
     main='Posterior draws of complete data')
for (d in dens) lines(d, col=rgb(0,0,1,.1))
lines(density(y_true), lwd=3)

# Posterior distribution of missing data
dens_missing = apply(out$sample[, -c(1:non_y)][,idx.na], 1, density)
plot(dens_missing[[1]], col=rgb(0,0,1,.01), xlim=c(-10, 5),
     ylim=c(0,max(sapply(dens_missing, function(d) max(d$y)))),
     main='Posterior draws of missing data')
for (d in dens_missing) lines(d, col=rgb(0,0,1,.1))
lines(density(y_true[idx.na]), lwd=3)

