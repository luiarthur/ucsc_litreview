#!/usr/bin/env Rscript
library(rcommon)
library(cytof3)
library(FlowSOM)
set.seed(1)

OUTDIR='./'
fileDest = function(filename) paste0(OUTDIR, filename)

# repFAM model
load('../../out/sim_locked_beta_K20_N500_repFam-TRUE/checkpoint.rda')
best_idx.rfam = sapply(1:I, function(i) estimate_ZWi_index(out, i))
best_lam.rfam = sapply(1:I, function(i) out[[best_idx.rfam[i]]]$lam[[i]])

# FAM model
load('../../out/sim_locked_beta_K20_N500_repFam-FALSE/checkpoint.rda')
best_idx.fam = sapply(1:I, function(i) estimate_ZWi_index(out, i))
best_lam.fam = sapply(1:I, function(i) out[[best_idx.fam[i]]]$lam[[i]])

# True clusters
true_lam = dat$lam

# FMeasure
FM = c("rfam"=FMeasure(unlist(true_lam), unlist(best_lam.rfam)),
       "fam"=FMeasure(unlist(true_lam), unlist(best_lam.fam)))
print(FM)
# F score:
#      rfam       fam
# 1.0000000 0.9319114
