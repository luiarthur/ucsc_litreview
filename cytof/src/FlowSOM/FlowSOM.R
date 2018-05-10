### INSTALL ###
#source("https://bioconductor.org/biocLite.R")
#biocLite("FlowSOM")

library(FlowSOM)
library(flowCore)
library(rcommon)
library(cytof3)
library(Rclusterpp)
source('est_Z_from_clusters.R')
set.seed(3)

#DATDIR = '../model3/sims/data/cytof_cb.rds'
#y = readRDS(DATDIR)

N_degree=1000
I=3; J=32; N=c(3,2,1)*N_degree; K=10
dat = sim_dat(I=I, J=J, N=N, K=K, L0=3, L1=4, Z=genZ(J,K,.6),
              miss_mech_params(c(-7, -3, -1), c(.1, .99, .001)))

### Indices for each sample ###
idx_upper = cumsum(N)
idx_lower = c(1,idx_upper[-I]+1)
idx = cbind(idx_lower, idx_upper)

y = dat$y
#y = dat$y_complete

### Set column names  ###
for (i in 1:I) colnames(y[[i]]) = paste0('V',1:J)

### Transform to y tilde ###
y_tilde = lapply(y, function(yi) {
  yi[which(is.na(yi))] = -7
  #exp(yi)
  yi
})

ff_y = sapply(y_tilde, flowFrame)
Y_tilde = Reduce(rbind, y_tilde)
ff_Y = flowFrame(Y_tilde)

### Example ###
# http://bioconductor.org/packages/release/bioc/vignettes/FlowSOM/inst/doc/FlowSOM.pdf

### FlowSOM ###
println("Running FlowSoM...")
fSOM <- FlowSOM(ff_Y,
                # Input options:
                colsToUse = 1:J,
                # Metaclustering options:
                #nClus = 20,
                maxMeta=20,
                # Seed for reproducible results:
                seed = 42)
#PlotStars(fSOM$FlowSOM, backgroundValues = as.factor(fSOM$metaclustering))
fSOM.clus = fSOM$meta[fSOM$FlowSOM$map$mapping[,1]]

i=1
clus = as.numeric(fSOM.clus)[idx[i,1]:idx[i,2]]
est = est_ZW_from_clusters(y_tilde[[i]], clus)
yZ(yi=y[[i]], Zi=est$Z*1, Wi=est$W, cell_types_i=est$clus-1,
   dat_lim=c(-3,3), na.color='black', thresh=.9)

### Kmeans ###
println("Running Kmeans...")
km = kmeans(Y_tilde, 20)

### Principal Components ###
#pY = prcomp(Y_tilde)$x[,1:2]
#km = kmeans(pY, 20)

i=1
est = est_ZW_from_clusters(y_tilde[[i]], km$cluster[idx[i,1]:idx[i,2]])
yZ(yi=y[[i]], Zi=est$Z*1, Wi=est$W, cell_types_i=est$clus-1,
   dat_lim=c(-3,3), na.color='black', thresh=.9)


### Rclusterpp ###
println("Running Rclusterpp...")
rclusterpp <- Rclusterpp.hclust(Y_tilde, method="ward", distance="euclidean")
rcpp_clus = cutree(rclusterpp, 20)
i = 1
est = est_ZW_from_clusters(y_tilde[[i]], rcpp_clus[idx[i,1]:idx[i,2]])
yZ(yi=y[[i]], Zi=est$Z*1, Wi=est$W, cell_types_i=est$clus-1,
   dat_lim=c(-1,1), na.color='black', thresh=.5)

