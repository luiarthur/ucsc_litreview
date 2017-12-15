library(cytof2)
library(rcommon)
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
dat_lim = c(-10,10)

fileDest = function(name) paste0(OUTDIR, name)

### Read in CB Data 
system(paste0('mkdir -p ', OUTDIR))
load(DATA_DIR) # dat/cytof_cb.RData
system(paste0('cp realDat_cb.R ', fileDest('src.R')))

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
  my.image(y[[i]], mn=-5, mx=5, col=blueToRed(), addLegend=TRUE,
           main=paste0('y',i), xlab='j', ylab='n')
}
dev.off()

#### End of Plotting Data ###


truth = list(K=MCMC_K)
prior = list(cs_v=4, cs_h=3, d_w=1/MCMC_K, a_beta=200000, b_beta=10000)
sim_time <- system.time(
  out <- cytof_fix_K_fit(y, truth=truth, prior=prior, B=B, burn=BURN, thin=THIN)
)
sink(fileDest('simtime.txt')); print(sim_time); sink()
save(y, out, file=fileDest('sim_result.RData'))

plot_cytof_posterior(out, y, outdir=OUTDIR, dat_lim=dat_lim)

png(fileDest('Y%03dsortedByLambda.png'))
for (i in 1:I) {
  lami_ord = order(last(out)$lam[[i]])
  my.image(y[[i]][lami_ord,], mn=dat_lim[1], mx=dat_lim[2],
           ylab='obs', xlab='markers', col=blueToRed(),addL=TRUE)
}
dev.off()
