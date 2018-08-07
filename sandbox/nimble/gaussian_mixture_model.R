library(nimble)

model.code = nimbleCode({
  alpha[1:J] ~ ddirch(d[1:J])
  
  for (i in 1:N) {
    y[i] ~ dnorm(mu[c[i]], var=sig2)
    c[i] ~ dcat(alpha[1:J])
  }
  for (j in 1:J) {
    mu[j] ~ dnorm(3, sd=10)
  }
  sig2 ~ dinvgamma(3, 2)
})

### Sim Truth ###
N = 300 # 30000
J = 5
c_true = sample(1:5, N, replace=TRUE)
mu = 1:J
sig2 = .01
y = rnorm(N, mu[c_true], sqrt(sig2))
plot(sort(y))

## data and constants as R objects
model.consts = list(N=N, J=J, d=rep(1/J,J))
model.data = list(y=y)
model.inits = list(alpha=rep(1/J, J), c=sample(1:J,N,repl=TRUE),
                   mu=rep(0,J), sig2=1)
model = nimbleModel(model.code, data=model.data, constants=model.consts, inits=model.inits)
cmodel = compileNimble(model)

model.conf = configureMCMC(model, print=FALSE)
model.conf$addMonitors(c('c'))
print(system.time(
  model.mcmc <- buildMCMC(model.conf) # build time increases as N grows
))
cmodel = compileNimble(model.mcmc, project=model)
samps = runMCMC(cmodel, summary=TRUE, niter=10000, nburnin=9000)

# Plot cluster label against truth
#plot(c_true, samps$summary[6:105, 2], ylim=c(1,J))
plot(c_true, samps$summary[(J+1):(N+J), 1], ylim=c(1,J))



# Post each mean against truth
ncol_samps = NCOL(samps$samples)
mu_post = samps$samples[, (ncol_samps-J):(ncol_samps-1)]
c_post = samps$samples[, (J+1):(J+N)]

mu_post_mean = colMeans(mu_post)
plot(mu[c_true], mu_post_mean[c_post[1,]])
B = nrow(c_post)
#for (iter in 1:B) points(mu[c_true], mu_post_mean[c_post[iter,]], col=rgb(0,0,0,.01))

plot(sort(mu), sort(mu_post_mean), xlab='mu_true', ylab='mu_post_mean')
