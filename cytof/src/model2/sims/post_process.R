#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
library(xtable) # print_bmat
library(cytof2)
library(sdols)

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

### SALSO ESTIMATE ###
Zs = lapply(out, function(o) o$Z)
As = lapply(Zs, pairwise_alloc)
A_mean = matApply(As, mean)
est_Z = salso(A_mean, structure="featureAllocation", maxSize=10)

pdf(fileDest('salso.pdf'))
my.image(est_Z, ylab="marker", xlab="cell-type")
dev.off()
