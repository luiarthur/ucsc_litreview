# https://stackoverflow.com/questions/5322836/choosing-between-qplot-and-ggplot-in-ggplot2
#https://stackoverflow.com/questions/18700938/ggplot2-positive-and-negative-values-different-color-gradient/21893276
library(cytof3)
library(ggplot2)
library(reshape2)

source('multiplot.R')

y_orig = readRDS('../../data/cytof_cb.rds')
y = preimpute(y_orig, .01)
Y = do.call(rbind, y)
N = sapply(y, NROW)
idx = unlist(sapply(1:length(y), function(i) rep(as.character(i), N[i])))
dat = data.frame(markers=Y, idx=idx)

#ggplot(Y, aes(markers[1])) + geom_histogram(aes(y=..density..)) + geom_density()
#ggplot(dat, aes(markers.2B4, fill=idx)) + geom_histogram(aes(y=..density..))
#for (m in colnames(dat)) {
#  m[1] = ggplot(dat, aes(markers.2B4, fill=idx)) + stat_density(geom='line') + xlim(-5,5)
#  m[2] = ggplot(dat, aes(markers.CD16, fill=idx)) + stat_density(geom='line') + xlim(-5,5)
#}

markers = colnames(dat)[-NCOL(dat)]
J = 8
plotlist = as.list(1:8)
for (j in 1:8) {
  m = ggplot(dat, aes_string(markers[j], fill='idx'))
  m = m + stat_density(geom='line') + xlim(-7,8)
  plotlist[[j]] = m
}

multiplot(plotlist=plotlist, cols=2)




ggplot(dat, aes_string("markers.2B4", fill="idx")) + stat_density(geom='line', alpha=.2, fill=idx)
  
ggplot(dat, aes_string("markers.2B4", fill="idx")) + geom_histogram()


i = 1
for (j in 1:8) {
  yij = y[[i]][,j]
  marker = colnames(y[[i]])[j]
  yij_df = data.frame(marker=yij)
  yij_df$idx = 'data'
  jit_df = data.frame(marker=yij) + 1
  jit_df$idx = 'jit'
  all_dat = rbind(yij_df, jit_df)
  #m = ggplot(dat, aes(marker, fill=idx))
  #m = m + stat_density(geom='line') + xlim(-7,8)
  #m = m + geom_histogram(alpha=.7) + xlim(-7,8)
  #m = m + stat_density(alpha=.7) + xlim(-7,8)
  m = ggplot(all_dat, aes(marker, fill=idx))
  m = m + geom_histogram(alpha=.7) #+ xlim(-7,8)
  #m = m + stat_density(geom='line') + xlim(-7,8)
  m
  ggplot(all_dat, aes(marker, fill=idx)) + geom_density(alpha = 0.2)

  plotlist[[j]] = m
}
multiplot(plotlist=plotlist, cols=2)


### Heatmap
#y = y_orig
y = preimpute(y_orig)
km = kmeans(y[[1]], 10)

y1 = y[[1]][km$clus,]
#melt.y1 = melt(y1)
#ggplot(melt.y1, aes(x=Var2,y=Var1,fill=value)) + geom_tile() + scale_fill_gradient2(low=-3, high=3, mid=0)
y1_cut = apply(y1, 2, function(y1j) cut(y1j, breaks=c(-Inf,-3:3,Inf), right=FALSE))
melt.y1 = melt(y1_cut)
#ggplot(melt.y1, aes(x=Var1,y=Var2,fill=value)) + geom_tile() + scale_fill_brewer(palette = "PRGn")


ggplot(melt.y1, aes(x=Var1,y=Var2,fill=value)) + geom_tile() + 
      scale_fill_manual(breaks=c("[-Inf,-3)", "[-3,-2)", "[-2,-1)", 
                                 "[-1,0)", "[0,1)", "[1,2)", 
                                 "[2,3)", "[3, Inf)"),
                        values = blueToRed(8))

