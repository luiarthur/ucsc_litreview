library(nimble)
#library(rcommon)
set.seed(1)

pad_zeros = function(y_list) {
  n_max = max(sapply(y_list, length))
  y_padded = lapply(y_list, function(y) if (length(y) == n_max) y else c(y, double(n_max-length(y))))
  Reduce(cbind, y_padded)
}
y_ls = list(rep(1,3), rep(2,5), rep(3,2))
pad_zeros(y_ls)

### Nimble Model Code ###
model.code = nimbleCode({
  for (i in 1:I) {
    for (j in 1:J[i]) {
      #y[idxOffset[i] + j] ~ dnorm(mu[i], 1) # version 1
      y[i,j] ~ dnorm(mu[i], 1) # version 2
    }
    mu[i] ~ dnorm(m, var=s2)
  }
})

### Data ###
J = c(30, 15, 20)
mu_true = c(-3, 5, 10)
y_orig = sapply(1:length(J), function(i) rnorm(J[i], mu_true[i]))
I = length(y_orig)
#y = Reduce(c, y_orig) # version 1
y = t(pad_zeros(y_orig)) # version 2

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
