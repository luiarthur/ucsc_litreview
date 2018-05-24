#!/usr/bin/env Rscript
library(rcommon)
library(cytof3)
library(FlowSOM)
source('../FlowSOM/est_Z_from_clusters.R')
set.seed(1)
ZLIM=c(-5,5)
COLOR=blueToRed(11)
THRESH=1-1E-4

OUTDIR_repFAM_TRUE='../../out/sim_rand_beta_K10_N100_repFam-TRUE/'
OUTDIR_repFAM_FALSE='../../out/sim_rand_beta_K10_N100_repFam-FALSE/'

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
load(OUTDIR_repFAM_TRUE %+% 'checkpoint.rda')
Z.rfam = lapply(out, function(o) o$Z)
nRepeatedCols.rfam = sapply(Z.rfam, repeatedCols)
nRepeatedPosCols.rfam = sapply(Z.rfam, repeatedPosCols)

### Plot YZ Images ###
mult=1; png(OUTDIR_repFAM_TRUE %+% 'YZ%03d.png', height=600*mult, width=500*mult, type='Xlib')
best_idx = sapply(1:I, function(i) estimate_ZWi_index(out, i))
best_lam = sapply(1:I, function(i) out[[best_idx[i]]]$lam[[i]])
for (i in 1:I) {
  yZ_inspect(out, y, zlim=ZLIM, i=i, thresh=THRESH, na.color='black', col=COLOR,
             cex.z.b=1.5, cex.z.lab=1.5, cex.z.l=1.5, cex.z.r=1.5,
             cex.y.ylab=1.5, cex.y.xaxs=1.4, cex.y.yaxs=1.4, cex.y.leg=1.5)
}
dev.off()
clus.repFAM = relabel_clusters(unlist(best_lam))
# FAM model
load(OUTDIR_repFAM_FALSE %+% 'checkpoint.rda')
Z.fam = lapply(out, function(o) o$Z)
nRepeatedCols.fam = sapply(Z.fam, repeatedCols)
nRepeatedPosCols.fam = sapply(Z.fam, repeatedPosCols)

### Plot YZ Images ###
mult=1; png(OUTDIR_repFAM_FALSE %+% 'YZ%03d.png', height=600*mult, width=500*mult, type='Xlib')
best_idx = sapply(1:I, function(i) estimate_ZWi_index(out, i))
best_lam = sapply(1:I, function(i) out[[best_idx[i]]]$lam[[i]])
for (i in 1:I) {
  yZ_inspect(out, y, zlim=ZLIM, i=i, thresh=THRESH, na.color='black', col=COLOR,
             cex.z.b=1.5, cex.z.lab=1.5, cex.z.l=1.5, cex.z.r=1.5,
             cex.y.ylab=1.5, cex.y.xaxs=1.4, cex.y.yaxs=1.4, cex.y.leg=1.5)
}
dev.off()
clus.FAM = relabel_clusters(unlist(best_lam))


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

### F-scores ##
clus.true = relabel_clusters(unlist(dat$lam))
FM = c('rep-FAM'=FMeasure(clus.true, clus.repFAM, silent=TRUE),
       'FAM'=FMeasure(clus.true, clus.FAM, silent=TRUE))

sink(OUTDIR_repFAM_TRUE %+% 'fscore-rep-FAM.tex')
println(round(FM['rep-FAM'],4))
sink()

sink(OUTDIR_repFAM_TRUE %+% 'fscore-FAM.tex')
println(round(FM['FAM'],4))
sink()
