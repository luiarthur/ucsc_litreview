library(cytof2)
library(rcommon)
set.seed(1)

args = commandArgs(trailingOnly=TRUE)
if (length(args) < 6) {
  stop('usage: Rscript src.R DATA_DIR MCMC_K OUTDIR B BURN THIN')
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
PREIMPUTE = as.integer(args[10])

RANDOM_K = (PROP > 0)
dat_lim = c(-7,7)

fileDest = function(name) paste0(OUTDIR, name)

### Read in CB Data 
system(paste0('mkdir -p ', OUTDIR))
load(DATA_DIR) # dat/cytof_cb.RData
if (PREIMPUTE) {
  ### TODO: Don't preimpute at the end
  print("Preimputing Y")
  y = preimpute(y, subsample_prop=.05)
}
G = cor(do.call(rbind, preimpute(y)))
y = resample(y, .05)
system(paste0('cp src.R ', fileDest('src.R')))

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
print(G)
prior = list(#cs_v=4, cs_h=3, d_w=1,
             G=G,
             cs_v=.1, cs_h=.1, d_w=1,
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
             alpha=5,
             psi0Bar=-1.77,
             psi1Bar=1.57,
             s2_psi0=.0001, s2_psi1=.05, 
             #a_tau0=6,b_tau0=.01,
             a_tau0=100,b_tau0=.01,
             a_tau1=3,b_tau1=.2,
             G=diag(J),#diag(J)*3,
             a_gam=15, b_gam=5,
             a_sig=83,b_sig=74)

if (RANDOM_K) {
  init$K = MCMC_K
} else {
  truth$K = MCMC_K
  truth$beta_all = TRUE
  truth$beta_1 = rep(bdat.prior['b1'], J)
  truth$beta_0 = matrix(bdat.prior['b0'], I, J)
  truth$x =  rep(bdat.prior['x'], J)
  ### FIXME: Remove when done ###

  truth$psi_0 = -1.77
  truth$tau2_0 = .01

  #truth$mus = array(unlist(list(matrix(-1.77,I,J),matrix(1.57,I,J))), dim=c(I,J,2))
  #truth$sig2 = matrix(.8, I, J)
  #truth$gams_0 = matrix(.87, I, J)

  #truth$tau2=c(.1, .8)
  #truth$sig2=matrix(.1,I,J)
}

print("Start MCMC")

sim_time <- system.time(
  out <- cytof_fix_K_fit(y, init=init, prior=prior, B=B, burn=BURN, thin=THIN,
                         warmup=WARMUP, thin_K=1, ncores=NCORES, truth=truth,
                         prop_for_training=PROP, print=1, normalize_loglike=TRUE)
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

### Post pred ###
pp = postpred(out)
Y_pp = pp$y
for (i in 1:I) colnames(Y_pp[[i]]) = colnames(y[[i]])

### Plot Y by lambda ###
png(fileDest('Y%03dpostpred.png'))
yZ(Y_pp, pp$Z, pp$cell, dat_lim=c(0,3), i=0, th=.05, prop=.3, col=greys(8))
dev.off()

### Plot Postpred
pdf(fileDest('postpred.pdf'))
par(mfrow=c(4,2))
for (i in 1:I) for (j in 1:J) {
  plot_dat(Y_pp, i, j, xlim=dat_lim, xlab=paste0('marker ',j))
}
par(mfrow=c(1,1))
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

### H Trace ###
pdf(fileDest('H_11_trace.pdf'))
h11 = sapply(out, function(o) o$H[1,1])
plotPost(h11)
dev.off()


### Plot missing_y (last in MCMC) ###
pdf(fileDest('missing_y_last.pdf'))
missing_y_last = lapply(last(out)$missing_y_last, matrix, ncol=J)

par(mfrow=c(4,2))
for (i in 1:I) for (j in 1:J) {
  plot_dat(missing_y_last, i, j, xlim=dat_lim, xlab=paste('marker',j))
}
par(mfrow=c(1,1))
dev.off()


pdf(fileDest('psi1.pdf'))
psi1 = sapply(out, function(o) o$psi[2])
plotPost(psi1, main='psi_1')
dev.off()

pdf(fileDest('tau2_1.pdf'))
tau2_1 = sapply(out, function(o) o$tau2[2])
plotPost(tau2_1, main='tau2_1')
dev.off()

### ALWAYS CHECK: 
# - true
# - prior
# - init


