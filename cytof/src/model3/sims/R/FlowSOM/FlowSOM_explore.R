# Exploring FlowSOM Properties

add.cut = function(clus) {
  abline(h=cumsum(table(clus)) + .5, lwd=3, col='yellow')
}

uniqueRows = function(X) unique(X)
binaryToInt = function(x) sum(2^(which(as.logical(rev(x)))-1))
#binaryToInt(c(1,0,0,0))

library(FlowSOM)
library(flowCore)
library(cytof3)
source("est_Z_from_clusters.R")
set.seed(3)

OUT_SIM  = '../../out/'
OUT_FLOW = OUT_SIM %+% 'FlowSOM_test/'
system('mkdir -p ' %+% OUT_FLOW)


sim.study = function(N=1000, J=2,
                     mu=seq(-2,2,l=2^J), sig=rep(.01,2^J), maxMeta=20) {
  stopifnot(length(mu) == 2^J)
  stopifnot(length(sig) == 2^J)
  #k.samp = sample.int(length(mu)^2, N*J, replace=TRUE)
  k.samp = sample(1:length(mu), N*J, replace=TRUE)
  y = matrix(rnorm(N*J, mu[k.samp], sig[k.samp]), ncol=J)
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

  pheno.true = apply(matrix(mu[k.samp],ncol=J) > 0, 1, binaryToInt) + 1

  list(y=y, ff=ff.y, fSOM=fSOM, time=tim, pheno.true=pheno.true)
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



sig_cand = c(.01, .1, .5, 1.0)
for (i in 1:length(sig_cand)) {
  sig = sig_cand[i]
  maxK = 20
  #sim = sim.study(sig=sig, mu=rnorm(4,sd=5), maxMeta=20)
  sim = sim.study(sig=rep(sig,4), maxMeta=maxK)
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

  png(OUT_FLOW %+% 'YZ_FlowSOM_sig' %+% sig %+% '.png',
      height=600*1, width=500*1, type='Xlib')
  my.image(sim$y[order(fs.clus),], col=blueToRed(4), zlim=c(-2,2), addL=TRUE,
           f=function(z) add.cut(fs.clus))
  dev.off()

  ### Compute F-score
  fscore = FMeasure(relabel_clusters(sim$pheno), fs.clus)

  pdf(OUT_FLOW %+% 'dat_sig' %+% sig %+% '.pdf')
  main = 'number of clusters: ' %+% length(unique(fs.clus))
  main = main %+% '; F-score: ' %+% round(fscore, 3)
  plot(sim$y, col=fs.clus, pch=20,
       main=main)
  abline(v=0, h=0, lty=2, col='grey')
  dev.off()

  sink(OUT_FLOW %+% 'fscore.txt', append=i>1)
  println(sprintf('F-score (sig=%.2f): %.3f', sig, fscore))
  sink()
}

### Simulation 2 ###
if (TRUE) {
  maxK = 20
  sim = sim.study(maxMeta=maxK,
                  #J=3,
                  #mu=c(-2,-1.5,-.5,-.1, .1, .5, 2, 1.5),
                  #sig=rep(c(.2, .1, .01, .1),2))
                  J=2,
                  mu=c(-2,-.5,.5, 2),
                  sig=c(.2, .1, .01, .1))
  fSOM = sim$fSOM

  # Version 1 # this is too good
  fSOM.clus = fSOM$meta[fSOM$FlowSOM$map$mapping[,1]]

  fs.clus = relabel_clusters(as.numeric(fSOM.clus))
  print(fs.clus)

  png(OUT_FLOW %+% 'YZ_FlowSOM_sim2' %+% '.png',
      height=600*1, width=500*1, type='Xlib')
  my.image(sim$y[order(fs.clus),], col=blueToRed(4), zlim=c(-2,2), addL=TRUE,
           f=function(z) add.cut(fs.clus))
  dev.off()

  ### Compute F-score
  fscore = FMeasure(relabel_clusters(sim$pheno), fs.clus)

  pdf(OUT_FLOW %+% 'dat_sim2.pdf')
  main = 'number of clusters: ' %+% length(unique(fs.clus))
  main = main %+% '; F-score: ' %+% round(fscore, 3)
  if (NCOL(sim$y) > 2) {
    #px = prcomp(sim$y)$x[,1:2]
    px = sim$y[,1:2]
  } else px = sim$y
  plot(px, col=fs.clus, pch=20,
       main=main)
  abline(v=0, h=0, lty=2, col='grey')
  dev.off()

  sink(OUT_FLOW %+% 'fscore.txt', append=TRUE)
  println('')
  println(sprintf('F-score (sim2): %.3f', sig, fscore))
  sink()
}


