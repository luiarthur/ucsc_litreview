library(cytof4)
library(nimble)
source("getOpts.R")

print(Sys.time())

# utils
mkdir = function(dir) system('mkdir -p ' %+% dir)
println = function(x,...) cat(x,...,'\n')

### Get Commandline Args ###
opt_parser = getOpts()
opt = parse_args(opt_parser)

### Globals ###
OUTDIR = getOrFail(paste0(opt$outdir,'/'), opt_parser)
N_factor = getOrFail(opt$N_factor, opt_parser)
niter = getOrFail(opt$niter, opt_parser)
BURN = getOrFail(opt$burn, opt_parser)
J = getOrFail(opt$J, opt_parser)
K_TRUE = getOrFail(opt$K_TRUE, opt_parser)
L0 = getOrFail(opt$L0, opt_parser)
L1 = getOrFail(opt$L1, opt_parser)

K_MCMC = getOrFail(opt$K_MCMC, opt_parser)
L_MCMC = getOrFail(opt$L_MCMC, opt_parser)

USE_REPULSIVE = getOrFail(opt$use_repulsive, opt_parser)
println("Use repulsive: ", USE_REPULSIVE)
### END OF GLOBALS ###
mkdir(OUTDIR)


### Set seed for random number generator for reproducibility ###
set.seed(1)

### Data ###
println(Sys.time() %+% ": Simulating Data...") 
I=3
N=c(3,1,2) * N_factor
# TODO: check cytof4 sim_dat is doing well
dat = sim_dat(I=I, J=J, N=N, K=K_TRUE, L0=L0, L1=L1)
save.image(file=OUTDIR %+% 'checkpoint.rda')
#load(OUTDIR %+% 'checkpoint.rda')
  
### Compile Model ###
println(Sys.time() %+% ': Compiling model...')
compile_time = system.time({
  cmodel <- compile.cytof.model(dat$y, K=K_MCMC, L=L_MCMC)
}); cat("Compilation Time (seconds): ", compile_time[3], '\n')
# Don't save!!! Saving model is NOT SUPPORTED!!!

### Fit Model ###
println(Sys.time() %+% ': Fitting model...')
fit_time = system.time({
  out <- fit.cytof(cmodel, niter=niter, nburnin=BURN, warmup=10)
}); cat("Model Fitting Time (seconds): ", fit_time[3], '\n')
#cmodel$run(3000); out$cmodel <- cmodel
println(Sys.time() %+% ': Model-fitting done.')


### Save mcmc samples (but not cmodel object!) ###
saveRDS(list(mvSamples=as.matrix(out$cmodel$mvSamples),
             mvSamples2=as.matrix(out$cmodel$mvSamples2)), OUTDIR %+% 'samples.rds')
#out = list(cmodel=readRDS(OUTDIR %+% 'samples.rds'))

### Source post processing functions ###
source('post_process.R')

# TODO: move `my.image` to cytof4

pdf(OUTDIR %+% 'out.pdf')
post_process(out$cmodel, N=N, J=J, K=K_MCMC, L=L_MCMC)
dev.off()

