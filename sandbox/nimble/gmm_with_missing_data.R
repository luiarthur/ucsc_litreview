library(nimble)
library(rcommon)
set.seed(251)
# will call cytof3::ari

### util functions ###
logit = function(p) log(p) - log(1-p)
sigmoid = function(x) 1 / (1 + exp(-x))
solve_b = function(y, p) {
  stopifnot(length(y) == 2 && length(p) == 2)
  b1 = diff(logit(p)) / diff(y)
  b0 = logit(p[1]) - b1 * y[1]
  c(b0, b1)
}
getmode <- function(v) {
   uniqv = unique(v)
   uniqv[which.max(tabulate(match(v, uniqv)))]
}

### Model ###
model.code = nimbleCode({
  for (i in 1:N) {
    y[i] ~ dnorm(mu[c[i]], var=sig2)
    c[i] ~ dcat(alpha[1:J])
    m[i] ~ dbern( p[i])
    logit(p[i]) <- b0 + b1 * y[i]
  }
  for (j in 1:J) {
    mu[j] ~ dnorm(m_mu, var=s2_mu)
  }
  sig2 ~ dinvgamma(a, scale=b) # mean = b / (a-1)
  b0 ~ dnorm(m_b0, var=s2_b0)
  b1 ~ dnorm(m_b1, var=s2_b1)
  alpha[1:J] ~ ddirch(d[1:J])

  # Constrains mu to be in ascending order
  constraints ~ dconstraint( prod(mu[1:(J-1)] <= mu[2:J]) )
})

### Sim Dat ###
N = 1000
J = 3
mu_true = c(-3, 1, 5)
alpha_true = c(.3, .5, .2)
sig2_true = .5
c_true = sample(1:J, N, p=alpha_true, replace=T)
y_complete = rnorm(N, mu_true[c_true], sig2_true)
hist(y_complete)

b_true = solve_b(y=c(-5, -1), p=c(.99, .01))
p_true = sigmoid(b_true[1] + b_true[2] * y_complete)
plot(y_complete, p_true)
m = rbinom(N, 1, p_true)
y = ifelse(m, NA, y_complete)
hist(y)

missing_prop = mean(is.na(y))

### Model data, constants, and inits
quantile(y, seq(0,1,l=10), na.rm=T)
y_lower = min(y, na.rm=TRUE)
y_upper = quantile(y, .1, na.rm=T)
b = solve_b(y=c(y_lower, y_upper), p=c(.99, .01))
model.data = list(m=m, y=y, constraints=1) # constraints set to 1 (satisfied)
model.consts = list(m_mu=0, s2_mu=10, a=301, b=300,
                    N=length(y), J=J, d=rep(1/J, J),
                    m_b0=b[1], m_b1=b[2], s2_b0=.001, s2_b1=.001)

y_seq = seq(-5,5,l=100)
plot(y_seq, 
     sigmoid(model.consts$m_b0+model.consts$m_b1*y_seq),
     type='l')

y.init = y
idx.na = which(is.na(y.init))
y.init[idx.na] <- rnorm(length(idx.na))
y.init[-idx.na] <- NA
model.inits = list(y=y.init, mu=c(0,0,0), sig2=1, b0=0, b1=0, p=rep(.5,length(y)),
                   alpha=rep(1/J,J), c=sample(1:J, N, replace=T))

### Compile Model ###
model = nimbleModel(model.code, data=model.data, 
                    constants=model.consts, inits=model.inits)
model$initializeInfo()
cmodel = compileNimble(model)

B = 1000
nsamps2 = 10
model.conf = configureMCMC(model, print=TRUE, monitors2=c('y', 'c'),
                           thin2=(B/nsamps2))
model.mcmc = buildMCMC(model.conf, enableWAIC=TRUE)
cmodel = compileNimble(model.mcmc, project=model)
burn = 10000
out = runMCMC(cmodel, summary=TRUE, niter=B+burn, nburnin=burn,
              WAIC=TRUE, progressBar=TRUE, setSeed=251)

#colnames(out$samples2)
#colnames(out$samples)

y_post = out$samples2[, paste0('y[',1:N,']')]
c_post = out$samples2[, paste0('c[',1:N,']')]
mu_post = out$samples[, paste0('mu[',1:J,']')]

# Posterior of alpha
plotPosts(out$samples[, 1:J])

# Posterior of model params
plotPosts(out$samples[, -c(1:J)])

# Posterior missing mechanism
b_post = out$samples[,c('b0', 'b1')]
p_post = apply(b_post, 1, function(b) sigmoid(b[1] + b[2] * y_seq))
plot(y_seq, 
     sigmoid(model.consts$m_b0+model.consts$m_b1*y_seq),
     type='l')
for (i in 1:B) lines(y_seq, p_post[,i], col=rgb(0,0,1,.1))

# Posterior distribution of complete data
dens = apply(y_post, 1, density)
plot(density(y_complete), xlim=c(-10,10), lwd=3,
     ylim=c(0,max(sapply(dens, function(d) max(d$y)))),
     main='Posterior draws of complete data', lty=2)
for (d in dens) lines(d, col=rgb(0,0,1,10/nsamps2))

# Posterior distribution of missing data
dens_missing = apply(y_post[,idx.na], 1, density)
plot(density(y_complete[idx.na]), xlim=c(-10, 5),
     ylim=c(0,max(sapply(dens_missing, function(d) max(d$y)))),
     main='Posterior draws of missing data', lwd=3, lty=2)
for (d in dens_missing) lines(d, col=rgb(0,0,1,10/nsamps2))

# Evaluate cluster accuracy via ARI metric
# ARI has range of unity, higher is better
c_post_est = apply(c_post, 2, getmode)
c_est_ari = cytof3::ari(c_post_est, c_true)
c_post_ari = cytof3::ari(c_post[nsamps2,], c_true)
cat('Cluster ARI of last sample: ', c_post_ari, '\n')
cat('Cluster ARI of mode:        ', c_post_ari, '\n')

# Test
plotPosts(out$samples[, -c(1:J)])
