#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
library(xtable) # print_bmat
library(cytof2)

### Declaring global vars ###
if (length(args) < 1) {
  stop('usage: Rscript post_process.R OUTDIR')
}

OUTDIR = args[1]
fileDest = function(name) paste0(OUTDIR, name)
### Finished declaring global vars ###

### Load Data ###
load(fileDest('sim_result.RData'))
plot_cytof_posterior(out, dat$y, outdir=OUTDIR, sim=dat, dat_lim=c(-10,10))
