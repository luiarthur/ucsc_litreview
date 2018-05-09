### INSTALL ###
#source("https://bioconductor.org/biocLite.R")
#biocLite("FlowSOM")

library(FlowSOM)
library(flowCore)
library(rcommon)
library(cytof3)
set.seed(3)

#DATDIR = '../model3/sims/data/cytof_cb.rds'
#y = readRDS(DATDIR)

N_degree=100
I=3; J=32; N=c(3,2,1)*N_degree; K=10
dat = sim_dat(I=I, J=J, N=N, K=K, L0=3, L1=4, Z=genZ(J,K,.6),
              miss_mech_params(c(-7, -3, -1), c(.1, .99, .001)))
y = dat$y
#y = dat$y_complete

### Set column names  ###
for (i in 1:I) colnames(y[[i]]) = paste0('V',1:J)

### Transform to y tilde ###
y_tilde = lapply(y, function(yi) {
  yi[which(is.na(yi))] = -Inf
  exp(yi)
})

ff_y = sapply(y_tilde, flowFrame)

### Example ###
# http://bioconductor.org/packages/release/bioc/vignettes/FlowSOM/inst/doc/FlowSOM.pdf
fSOM <- FlowSOM(ff_y[[1]],
                # Input options:
                colsToUse = 1:J,
                # Metaclustering options:
                nClus = 10,
                # Seed for reproducible results:
                seed = 42)
#PlotStars(fSOM$FlowSOM, backgroundValues = as.factor(fSOM$metaclustering))
fSOM.clus = fSOM$meta[fSOM$FlowSOM$map$mapping[,1]]
my.image(dat$y[[1]][order(fSOM.clus),], zlim=c(-3,3), col=blueToRed(), addL=TRUE,
         na.color='black')

