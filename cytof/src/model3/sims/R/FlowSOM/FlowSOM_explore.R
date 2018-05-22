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

sim.study = function(N=1000, J=2, mu_lim=c(-2,2), sig=.01, maxMeta=20) {
  k.samp = sample.int(2^J, N*J, replace=TRUE)
  mu = seq(mu_lim[1], mu_lim[2], length=2^J)
  y = matrix(rnorm(2*N, mu[k.samp], sig), ncol=J)
  colnames(y) = paste0('V', 1:J)
  ff.y = flowFrame(y)

  println("Running FlowSOM...")
  tim = system.time(
    fSOM <- FlowSOM(ff.y, colsToUse = 1:J, maxMeta=maxMeta, seed = 42)
    #fSOM <- FlowSOM(ff.y, colsToUse = 1:J, nClus=16, seed = 42)
  )
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




for (sig in c(1, .5, .1, .01)) {
  sim = sim.study(sig=sig)
  fSOM = sim$fSOM
  fSOM.clus = fSOM$meta[fSOM$FlowSOM$map$mapping[,1]]
  fs.clus = relabel_clusters(as.numeric(fSOM.clus))
  #PlotStars(fSOM$FlowSOM, backgroundValues = as.factor(fSOM$metaclustering))

  png(OUT_FLOW %+% 'YZ_FlowSOM_sig' %+% sig %+% '.png', height=600*1, width=500*1, type='Xlib')
  my.image(sim$y[order(fs.clus),], col=blueToRed(4), zlim=c(-2,2), addL=TRUE,
           f=function(z) add.cut(fs.clus))
  dev.off()

  pdf(OUT_FLOW %+% 'dat_sig' %+% sig %+% '.pdf')
  plot(sim$y, col=fs.clus, pch=20, main='number of clusters: ' %+% length(unique(fs.clus)))
  dev.off()
}
