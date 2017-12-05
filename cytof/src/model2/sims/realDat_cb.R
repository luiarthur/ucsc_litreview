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

fileDest = function(name) paste0(OUTDIR, name)

### Read in CB Data 
load(DATA_DIR) # dat/cytof_cb.RData

truth = list(K=MCMC_K)
system.time(out <- cytof_fix_K_fit(y, truth=truth, B=B, burn=BURN, thin=THIN))
plot_cytof_posterior(out, y, outdir=OUTDIR)
