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

### Plot Cumulative Proportion by Clusters ###
cumprop.repFAM = cumsum(table(clus.repFAM) / sum(table(clus.repFAM)))
cumprop.FAM = cumsum(table(clus.FAM) / sum(table(clus.FAM)))
pdf(OUTDIR_repFAM_TRUE %+% 'compareClus.pdf')
plot(cumprop.FAM, type='o', col=rgba('blue', .5), fg='grey', ylim=0:1,
     xlab='cell types', cex.lab=1.4, cex.axis=1.5,
     ylab='cumulative  proportion', lwd=5)
lines(cumprop.repFAM, type='o', col=rgba('red', .5), lwd=5)
abline(h=1:10 / 10, v=1:last(out)$prior$K, lty=2, col='grey')
legend('bottomright', col=c('red', 'blue'), legend=c('rep-FAM', 'FAM'), cex=3,
       lwd=5, bty='n')
dev.off()


### UQ on Z / W ###
Z = lapply(out, function(o) o$Z)
my.image(matApply(Z, mean), xlab='cell types', ylab='markers', col=greys(5), addL=TRUE)
my.image(matApply(Z, sd),   xlab='cell types', ylab='markers', col=greys(4), addL=TRUE)

W = lapply(out, function(o) o$W)
cc=5; M = cbind(matrix(rep(1:3,cc), ncol=cc), 4)
layout(M)
my.image(matApply(W, quantile, .975), zlim=c(0,.4), xlab='cell types',
         ylab='markers', col=greys(6), main='97.5% Quantile')
my.image(matApply(W, mean), zlim=c(0,.4), xlab='cell types', ylab='markers',
         col=greys(4), main='mean')
my.image(matApply(W, quantile, .025), zlim=c(0,.4), xlab='cell types',
         ylab='markers', col=greys(6), main='2.5% Quantile')
color.bar(greys(5), zlim=c(0,.4), dig=3)
par(mfrow=c(1,1))



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
