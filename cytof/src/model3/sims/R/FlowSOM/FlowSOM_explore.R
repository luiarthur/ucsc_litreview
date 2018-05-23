# Exploring FlowSOM Properties

add.cut = function(clus) {
  abline(h=cumsum(table(clus)) + .5, lwd=3, col='yellow')
}

library(FlowSOM)
library(flowCore)
library(cytof3)
source("est_Z_from_clusters.R")
set.seed(3)

OUT_SIM  = '../../out/'
OUT_FLOW = OUT_SIM %+% 'FlowSOM_test/'
system('mkdir -p ' %+% OUT_FLOW)

sim.study = function(N=1000, J=2, mu=seq(-2,2,l=2^J), sig=.01, maxMeta=20) {
  stopifnot(length(mu) == 2^J)
  #k.samp = sample.int(length(mu)^2, N*J, replace=TRUE)
  k.samp = sample(1:length(mu), N*J, replace=TRUE)
  y = matrix(rnorm(2*N, mu[k.samp], sig), ncol=J)
  colnames(y) = paste0('V', 1:J)
  ff.y = flowFrame(y)

  println("Running FlowSOM...")
  tim = system.time({
    ## Version 1
    fSOM <- FlowSOM(ff.y, colsToUse = 1:J, maxMeta=maxMeta, seed = 42)

    # Version 2
    #fSOM = ReadInput(ff.y)
    #fSOM = BuildSOM(fSOM, colsToUse=1:J);
    #fSOM = BuildMST(fSOM)
  })
  print(tim)

  list(y=y, ff=ff.y, fSOM=fSOM, time=tim)
}


#### Kmeans ###
#km = kmeans(y, 4)
#km.clus = relabel_clusters(km$clus)
#my.image(y[order(km.clus),], col=blueToRed(4), zlim=c(-2,2), addL=TRUE,
#         f=function(z) add.cut(km.clus))
#plot(y, col=km.clus, pch=20)
#
#### H-clust ###
#hc = hclust(dist(y))
#hc.clus = relabel_clusters(cutree(hc, k=4))
#my.image(y[order(fs.clus),], col=blueToRed(4), zlim=c(-2,2), addL=TRUE,
#         f=function(z) add.cut(fs.clus))
#plot(y, col=hc.clus, pch=20)




for (sig in c(.1, .5, 1, .01)) {
  maxK = 20
  #sim = sim.study(sig=sig, mu=rnorm(4,sd=5), maxMeta=20)
  sim = sim.study(sig=sig, maxMeta=maxK)
  fSOM = sim$fSOM
  #PlotStars(fSOM$FlowSOM, backgroundValues = as.factor(fSOM$metaclustering))

  # Version 1 # this is too good
  fSOM.clus = fSOM$meta[fSOM$FlowSOM$map$mapping[,1]]

  ## Version 2  This is realistic
  #fSOM.clus = fSOM$map$mapping[, 1]
  #fSOM <- ConsensusClusterPlus::ConsensusClusterPlus(t(fSOM$map$codes), maxK=maxK, seed=42)
  #fSOM <- fSOM[[maxK]]$consensusClass
  #fSOM.clus = fSOM[fSOM.clus]

  ## Version 2.1 # this is too good
  #fSOM.clus = MetaClustering(fSOM$map$codes, "metaClustering_consensus", max=maxK)
  #fSOM.clus <- fSOM.clus[fSOM$map$mapping[,1]]

  fs.clus = relabel_clusters(as.numeric(fSOM.clus))
  print(fs.clus)

  png(OUT_FLOW %+% 'YZ_FlowSOM_sig' %+% sig %+% '.png', height=600*1, width=500*1, type='Xlib')
  my.image(sim$y[order(fs.clus),], col=blueToRed(4), zlim=c(-2,2), addL=TRUE,
           f=function(z) add.cut(fs.clus))
  dev.off()

  pdf(OUT_FLOW %+% 'dat_sig' %+% sig %+% '.pdf')
  plot(sim$y, col=fs.clus, pch=20, main='number of clusters: ' %+% length(unique(fs.clus)))
  dev.off()
}


