### INSTALL ###
#source("https://bioconductor.org/biocLite.R")
#biocLite("FlowSOM")

library(FlowSOM)
library(flowCore)
library(rcommon)
library(cytof3)
source('est_Z_from_clusters.R')
set.seed(3)
OUT_FLOW = '../../out/FlowSOM/'
OUT_SIM  = 
DAT_DIR  = '../../data/cytof_cb.rds'
system(paste0('mkdir -p ', OUTDIR_ORIG, 'FlowSOM/')

y = readRDS(DATDIR)
N = sapply(y, NROW)
J = NCOL(y[[1]])
I = length(y)

### Indices for each sample ###
idx_upper = cumsum(N)
idx_lower = c(1,idx_upper[-I]+1)
idx = cbind(idx_lower, idx_upper)

### Transform to y tilde ###
#min_y = min(sapply(y, min, na.rm=TRUE))
#y_tilde = lapply(y, function(yi) {
#  yi[which(is.na(yi))] = min_y
#  #exp(yi)
#  yi
#})
y_tilde = preimpute(y)

Y_tilde = Reduce(rbind, y_tilde)
ff_Y = flowFrame(Y_tilde)

### Example ###
# http://bioconductor.org/packages/release/bioc/vignettes/FlowSOM/inst/doc/FlowSOM.pdf

### FlowSOM ###
println("Running FlowSoM...")
runtime = system.time(
fSOM <- FlowSOM(ff_Y,
                # Input options:
                colsToUse=1:J,
                # Metaclustering options:
                #nClus = 20,
                maxMeta=20,
                # Seed for reproducible results:
                seed=42)
)
print(runtime)
#PlotStars(fSOM$FlowSOM, backgroundValues = as.factor(fSOM$metaclustering))
fSOM.clus = fSOM$meta[fSOM$FlowSOM$map$mapping[,1]]

mult=1
png('out/YZ%03d_FlowSOM_CB.png', height=600*mult, width=500*mult, type='Xlib')
for (i in 1:I) {
  clus = as.numeric(fSOM.clus)[idx[i,1]:idx[i,2]]
  print(length(unique(clus))) # Number of clusters learned
  est = est_ZW_from_clusters(y_tilde[[i]], clus, f=median)
  yZ(yi=y[[i]], Zi=est$Z*1, Wi=est$W, cell_types_i=est$clus-1,
     zlim=c(-3,3), na.color='black', thresh=.9, col=blueToRed(7),
     cex.z.b=1.5, cex.z.lab=1.5, cex.z.l=1.5, cex.z.r=1.5,
     cex.y.ylab=1.5, cex.y.xaxs=1.4, cex.y.yaxs=1.4, cex.y.leg=1.5)
}
dev.off()


### Principal Components (2D) ###
pY = prcomp(Y_tilde)
#pY = prcomp(Y_tilde[idx[i,1]:idx[i,2],])
cumsum(pY$sd^2 / sum(pY$sd^2))

### Cytof3 ###
out = readRDS('../../out/cb_locked_beta1_K20/out.rds')
best_idx = sapply(1:I, function(i) estimate_ZWi_index(out, i))
best_lam = sapply(1:I, function(i) out[[best_idx[i]]]$lam[[i]])
cy.c = relabel_clusters(unlist(best_lam))
fs.c = relabel_clusters(as.integer(fSOM.clus))
#FMeasure(cy.c, fs.c)
#FMeasure(fs.c, cy.c)

cy.c.cs = cumsum(table(cy.c) / sum(table(cy.c)))
fs.c.cs = cumsum(table(fs.c) / sum(table(fs.c)))

par(mfrow=c(1,2), mar=c(5,4,4,0)+.1)
# appears to be 3 clusters
plot(pY$x[,c(1,2)], col=rgba(fs.c,.3), pch=16, main='FlowSOM')
par(mar=c(5,2,4,1)+.1)
plot(pY$x[,c(1,2)], col=rgba(cy.c,.3), pch=16, main='FAM', yaxt='n', ylab='')
par(mfrow=c(1,1), mar=c(5,4,4,1)+.1)

### Plot Cumulative Proportion by Clusters ###
pdf('out/compareClus_FlowSOM_CB.pdf')
plot(cy.c.cs, type='o', col=rgba('blue', .5), fg='grey', ylim=0:1,
     xlab='cell-types', cex.lab=1.4, cex.axis=1.5,
     ylab='cumulative  proportion', lwd=5)
lines(fs.c.cs, type='o', col=rgba('red', .5), lwd=5)
abline(h=1:10 / 10, v=1:last(out)$prior$K, lty=2, col='grey')
legend('bottomright', col=c('red', 'blue'), legend=c('FlowSOM', 'FAM'), cex=3,
       lwd=5, bty='n')
dev.off()
