library(nimble)
library(rcommon)

model.code = nimbleCode({
  alpha[1:J] ~ ddirch(d[1:J])
  
  for (i in 1:N) {
    y[i] ~ dnorm(mu[c[i]], var=sig2)
    c[i] ~ dcat(alpha[1:J])
  }
  for (j in 1:J) {
    mu[j] ~ dnorm(0, sd=3)
  }
  sig2 ~ dinvgamma(3, 2)
})

### Sim Truth ###
N = 300 # 30000
J = 5
shape_true = 3.0
rate_true = 2.0
y = -rgamma(N, shape_true, rate_true) + 1
# y = rnorm(N)

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
get_param = function(name, out_samples) {
  out_samples[, which(sapply(colnames(out_samples), function(cn) grepl(name, cn)))]
}


# Posterior
mu_post = get_param('mu', samps$samples)
c_post = get_param('c', samps$samples)
sig2_post = get_param('sig2', samps$samples)
B = NROW(samps$samples)

# plotPost(sig2_post, main="sig2")
# plotPosts(mu_post)

# Posterior Predictive
one_post_pred = function(mu, clus, sig2) {
  n = length(clus)
  rnorm(n, mu[clus], sqrt(sig2))
}
post_pred = sapply(1:B, function(b) one_post_pred(mu_post[b, ], c_post[b, ], sig2_post[b]))


# Plots
par(mfrow=c(1,2))
# Density
plot(density(post_pred[, 1]), xlim=c(-5,5), ylim=c(0, .7), type='n', main='Posterior Predictive')
for (b in 1:B ) lines(density(post_pred[, b]), col=rgba('grey', .1))
lines(density(y), col='black')

# QQ
my.qqplot(y, post_pred, pch=20, ylim=range(post_pred), xlim=range(post_pred), type='o',
          col='blue', xlab="obs", ylab="post pred", main="QQ")
par(mfrow=c(1,1))
