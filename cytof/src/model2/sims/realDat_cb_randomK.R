library(cytof2)
library(rcommon)
source("preimpute.R")
set.seed(1)

args = commandArgs(trailingOnly=TRUE)
if (length(args) < 6) {
  stop('usage: Rscript realDat_cb.R DATA_DIR MCMC_K OUTDIR B BURN THIN')
}

### GLOBAL VARS ###
DATA_DIR = args[1]
MCMC_K <- as.integer(args[2])
OUTDIR <- args[3]
B <- as.integer(args[4])
BURN <- as.integer(args[5])
THIN <- as.integer(args[6])
PROP = as.numeric(args[7])
WARMUP = as.integer(args[8])
NCORES = as.integer(args[9])
RANDOM_K = (PROP > 0)
dat_lim = c(-7,7)

fileDest = function(name) paste0(OUTDIR, name)

### Read in CB Data 
system(paste0('mkdir -p ', OUTDIR))
load(DATA_DIR) # dat/cytof_cb.RData
#y = preimpute(y) ### TODO: Remove this?
system(paste0('cp realDat_cb_randomK.R ', fileDest('src.R')))

### Plotting Data ###
pdf(fileDest('data.pdf'))
### Prob Missing
sink(fileDest('missing_count.txt'))
cat("Missing count:\n")
print(get_missing_count(y))
sink()

missing_prop = get_missing_prop(y)
sink(fileDest('missing_prop.txt'))
cat("Missing proportion:\n")
print(missing_prop)
sink()

### Estimate of mu*
par(mfrow=c(4,2))
I = length(y)
J = NCOL(y[[1]])
for (i in 1:I) for (j in 1:J) {
  plot_dat(y, i, j, xlim=dat_lim, xlab=paste0('marker ',j))
  #Sys.sleep(1)
}
par(mfrow=c(1,1))

### Distribution of Data
plot.histModel2(y, xlim=dat_lim, main='Distribution of Data', quant=c(.05,.95))
for (i in 1:I) {
  plot.histModel2(list(y[[i]]), xlim=dat_lim, main='Distribution of Data')
}
dev.off()

png(fileDest('rawDat%03d.png'))
for (i in 1:I) {
  my.image(y[[i]], mn=dat_lim[1], mx=dat_lim[2], col=blueToRed(), addLegend=TRUE,
           main=paste0('y',i), xlab='j', ylab='n')
}
dev.off()

#### End of Plotting Data ###
init = NULL
truth = NULL

#prior = list(cs_v=4, cs_h=3, d_w=1/MCMC_K, a_beta=200000, b_beta=10000,
#             K_min=1, K_max=10, a_K=2)

bdat.prior = get_beta_new(y=c(-3, c0 <- -2, -1), p_tar=c(.1, .6, .01))
prior = list(cs_v=4, cs_h=3, d_w=1,
             #cs_v=.1, cs_h=.1, d_w=1,
             m_betaBar=bdat.prior['b0'], s2_betaBar=.0001, s2_beta0=.0001, #b0
             a_beta=bdat.prior['b1'] * 100, b_beta=100, # b1
             c0=c0, a_x=bdat.prior['x'] * 100, b_x=100, # x
             K_min=1, K_max=16, a_K=2,
             ### Want s0^2 + tau0^2 + sig^2 = 1.5^2
             # s0^2 = .5, sig2 ~ IG(mean=1,sd=.5), tau0^2 ~ IG(mean=.75,sd=.3)
             #s2_psi0=.5, a_sig=6,b_sig=5, a_tau0=8.25,b_tau0=5.44)
             ### Want s0^2 + tau0^2 + sig^2 = .5^2 = .25
             # s0^2 = .05, tau0^2 ~ IG(mean=.1,sd=.1), sig2 ~ IG(mean=.1,sd=.1)
             #s2_psi0=.05, a_tau0=3,b_tau0=.2, a_sig=3,b_sig=.2)
             ### empirical sig2 = .9
             ### empirical gam* = .36 (var(y[y<0]) = 1.22)
             a_gam=15, b_gam=5,
             s2_psi0=.05, a_tau0=3,b_tau0=.2, a_sig=83,b_sig=74)

if (RANDOM_K) {
  init$K = MCMC_K
} else {
  truth$K = MCMC_K
  truth$beta_all = TRUE
  truth$beta_1 = rep(bdat.prior['b1'], J)
  truth$beta_0 = matrix(bdat.prior['b0'], I, J)
  truth$x =  rep(bdat.prior['x'], J)
  ### FIXME: Remove when done ###
  #truth$tau_0=c(.1, .8)
  #truth$sig2=matrix(.1,I,J)
}

print("Start MCMC")

sim_time <- system.time(
  out <- cytof_fix_K_fit(y, init=init, prior=prior, B=B, burn=BURN, thin=THIN,
                         warmup=WARMUP, thin_K=1, ncores=NCORES, truth=truth,
                         prop_for_training=PROP, print=1)
)
sink(fileDest('simtime.txt')); print(sim_time); sink()
save(y, out, file=fileDest('sim_result.RData'))

plot_cytof_posterior(out, y, outdir=OUTDIR, dat_lim=dat_lim, prior=prior)
# FIXME: change this to previous line
#plot_cytof_posterior(out, y, outdir=OUTDIR, dat_lim=dat_lim, prior=prior, supress=c('tau2'))

### Plot Y by lambda ###
png(fileDest('Y%03dsortedByLambda.png'))
y_Z_inspect(out, y, dat_lim=c(0,3), i=0, th=.05, prop=.3, col=greys(8))
dev.off()


### Kmeans ###
#yi = ifelse(is.na(y[[i]]), -3, y[[i]])
#ks = 2:16
#costs = double(length(ks))
#for (k in ks) {
#  print(k)
#  km = kmeans(yi, k)
#  costs[k-1] = km$tot.within
#}
#plot(costs, type='b')


### INSPECT MUS ###
pdf(fileDest('mus_inspect.pdf'))
for (i in 1:I) {
  mus_inspect(i, out, y)
}
dev.off()

#Rscript realDat_cb_randomK.R "dat/cytof_cb.RData" 20 "out/cb_fixedK20_randTau/" 2000 10000 1 0 0 1 &
#Rscript realDat_cb_randomK.R "dat/cytof_cb.RData" 10 "out/cb_fixedK_randTau_small_cs/" 2000 20000 1 0 0 1 &
#Rscript realDat_cb_randomK.R "dat/cytof_cb.RData" 10 "out/cb_fixedK_randTau_preimpute/" 2000 10000 1 0 0 1 &
#Rscript realDat_cb_randomK.R "dat/cytof_cb.RData" 10 "out/cb_fixedK_randTau/" 2000 10000 1 0 0 1 &
#Rscript realDat_cb_randomK.R "dat/cytof_cb.RData" 10 "out/cb_fixedK_fixedTau/" 2000 10000 1 0 0 1 &
