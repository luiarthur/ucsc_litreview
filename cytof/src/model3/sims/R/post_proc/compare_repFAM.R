#!/usr/bin/env Rscript
library(rcommon)
library(cytof3)
set.seed(1)

OUTDIR='./'
fileDest = function(filename) paste0(OUTDIR, filename)
repeatedCols = function(Z) {
  NCOL(Z) - uniqueCols(Z)
}
repeatedPosCols = function(Z) {
  nPosCols = length(which(colSums(Z) > 0))
  nPosCols - uniquePosCols(Z)
}
repeats = function(Z) repeatedCols(Z) > 0
repeatsPos = function(Z) repeatedPosCols(Z) > 0

# repFAM model
load('../../out/sim_locked_beta_K20_N500_repFam-TRUE/checkpoint.rda')
Z.rfam = lapply(out, function(o) o$Z)
nRepeatedCols.rfam = sapply(Z.rfam, repeatedCols)
nRepeatedPosCols.rfam = sapply(Z.rfam, repeatedPosCols)

# FAM model
load('../../out/sim_locked_beta_K20_N500_repFam-FALSE/checkpoint.rda')
Z.fam = lapply(out, function(o) o$Z)
nRepeatedCols.fam = sapply(Z.fam, repeatedCols)
nRepeatedPosCols.fam = sapply(Z.fam, repeatedPosCols)


# Plots
#par(mfrow=c(1,2))
#plot(table(nRepeatedCols.fam) / sum(table(nRepeatedCols.fam)), ylim=0:1,
#     ylab='proportion')
#plot(table(nRepeatedPosCols.fam) / sum(table(nRepeatedPosCols.fam)), ylim=0:1,
#     ylab='proportoin')
#par(mfrow=c(1,1))

table(nRepeatedPosCols.fam) / sum(table(nRepeatedPosCols.fam))

mean(sapply(Z.fam, repeats))
mean(sapply(Z.fam, repeatsPos))
