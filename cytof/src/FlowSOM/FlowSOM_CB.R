### INSTALL ###
#source("https://bioconductor.org/biocLite.R")
#biocLite("FlowSOM")

library(FlowSOM)
library(flowCore)
library(rcommon)
library(cytof3)
source('est_Z_from_clusters.R')
set.seed(3)

DATDIR = '../model3/sims/data/cytof_cb.rds'
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
                #nClus = 10,
                maxMeta=30,
                # Seed for reproducible results:
                seed=42)
)
print(runtime)
#PlotStars(fSOM$FlowSOM, backgroundValues = as.factor(fSOM$metaclustering))
fSOM.clus = fSOM$meta[fSOM$FlowSOM$map$mapping[,1]]

i=1
clus = as.numeric(fSOM.clus)[idx[i,1]:idx[i,2]]
print(length(unique(clus))) # Number of clusters learned
est = est_ZW_from_clusters(y_tilde[[i]], clus)
yZ(yi=y[[i]], Zi=est$Z*1, Wi=est$W, cell_types_i=est$clus-1,
   zlim=c(-1,1), na.color='black', thresh=.9, col=blueToRed(5))


### Principal Components (2D) ###
pY = prcomp(Y_tilde)
#pY = prcomp(Y_tilde[idx[i,1]:idx[i,2],])
cumsum(pY$sd^2 / sum(pY$sd^2))
plot(pY$x[,c(1,2)], col=rgb(0,0,1,.1), pch=16) # appears to be 3 clusters

