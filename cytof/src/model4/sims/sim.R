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
K_TRUE=4
L0=5
L1=3
dat = cytof3::sim_dat(I=I, J=J, N=N, K=K_TRUE, L0=L0, L1=L1)
  
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

### Source post processing functions ###
source('post_process.R')
post_process(out$cmodel, N=c(3,1,2)*100, J=8, K=10, L=5)
