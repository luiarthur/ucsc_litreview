library(nimble)
#library(rcommon)
set.seed(1)

### Nimble Model Code ###
model.code = nimbleCode({
  for (i in 1:I) {
    for (j in 1:J[i]) {
      y[idxOffset[i] + j] ~ dnorm(mu[i], 1)
    }
    mu[i] ~ dnorm(m, var=s2)
  }
})

### Data ###
J = c(30, 15, 20)
mu_true = c(-3, 5, 10)
y_orig = sapply(1:length(J), function(i) rnorm(J[i], mu_true[i]))
I = length(y_orig)
y = Reduce(c, y_orig)
hist(y)

### Model data, constants, and inits
model.data = list(y=y)
model.consts = list(m=0, s2=100, idxOffset=c(0, cumsum(J[-I])), I=I, J=J)
model.inits = list(mu=rep(0, I))

### Compile Model ###
model = nimbleModel(model.code, data=model.data, constants=model.consts, inits=model.inits)
cmodel = compileNimble(model)

model.conf = configureMCMC(model, print=TRUE)
model.mcmc = buildMCMC(model.conf)
cmodel = compileNimble(model.mcmc, project=model)
out = runMCMC(cmodel, summary=TRUE, niter=10000, nburnin=9000)


### Summary ###
#plotPosts(out$samples)
print(cbind(mu_true, out$summary))
