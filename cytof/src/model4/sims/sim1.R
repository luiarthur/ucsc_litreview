library(cytof4)
library(nimble)


### OUTPUT DIRECTORY ###
OUTDIR = 'log/'

### Set seed for random number generator for reproducibility ###
set.seed(1)

### Data ###
I=3
J=8
N=c(3,1,2) * 100
K_true=4
L0=5
L1=3
dat = cytof3::sim_dat(I=I, J=J, N=N, K=K_true, L0=L0, L1=L1)
  
### MCMC COMFIGS ###
L_MCMC=5
K_MCMC=10

### Compile Model ###
compile_time = system.time({
  cmodel <- compile.cytof.model(dat$y, K=K_MCMC, L=L_MCMC)
}); cat("Compilation Time (seconds): ", compile_time[3], '\n')
# Don't save!!! Saving model is NOT SUPPORTED!!!

### Fit Model ###
fit_time = system.time({
  out <- fit.cytof(cmodel, niter=200, nburnin=1000, warmup=10)
}); cat("Model Fitting Time (seconds): ", fit_time[3], '\n')
#cmodel$run(3000); out$cmodel <- cmodel

### Save mcmc samples (but not cmodel object!) ###
saveRDS(list(mvSamples=as.matrix(out$cmodel$mvSamples),
             mvSamples2=as.matrix(out$cmodel$mvSamples2)), OUTDIR %+% 'samples.rds')
#out = list(cmodel=readRDS(OUTDIR %+% 'samples.rds'))

samples = as.matrix(out$cmodel$mvSamples)
samples2 = as.matrix(out$cmodel$mvSamples2)

# Plot log-likelihood
ll.cols = get_param('logProb_y', samples)
ll = rowSums(samples[, ll.cols]) / sum(N)
plot(ll, type='o')

Z.cols = get_param('Z0', samples)
Z.post = samples[, Z.cols]
Z.mean = matrix(colMeans(Z.post), J, K_MCMC)
cytof3::my.image(Z.mean, addL=T, col=cytof3::greys(11))

mus.cols = get_param('mus', samples)
mus.post = samples[, mus.cols]
mus.mean = matrix(colMeans(mus.post), 2, L_MCMC)
plot(c(mus.mean[1,], mus.mean[2,]))
abline(h=0, v=L_MCMC+.5, lty=2, col='grey')

N = sapply(dat$y, NROW)
y.cols = get_param('y', samples2)
y.post = matrix(samples2[, y.cols], sum(N), J)
hist(y.post[,4])
cytof3::my.image(y.post, col=cytof3::blueToRed(7), addL=TRUE, zlim=c(-3,3))
cytof3::my.image(Reduce(rbind, dat$y), col=cytof3::blueToRed(7), addL=TRUE, zlim=c(-3,3), na.col='black')

