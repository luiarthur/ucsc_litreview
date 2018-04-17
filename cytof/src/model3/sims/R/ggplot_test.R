# https://stackoverflow.com/questions/5322836/choosing-between-qplot-and-ggplot-in-ggplot2
library(cytof3)
library(ggplot2)
source('multiplot.R')

y_orig = readRDS('../data/cytof_cb.rds')
y = preimpute(y_orig, .01)
Y = do.call(rbind, y)
N = sapply(y, NROW)
idx = unlist(sapply(1:length(y), function(i) rep(i, N[i])))
dat = data.frame(markers=Y, idx=idx)

#ggplot(Y, aes(markers[1])) + geom_histogram(aes(y=..density..)) + geom_density()
#ggplot(dat, aes(markers.2B4, fill=idx)) + geom_histogram(aes(y=..density..))
grid.arrange(layout_matrix = c(1,2))
multiplot()
for (m in colnames(dat)) {
  m[1] = ggplot(dat, aes(markers.2B4, fill=idx)) + stat_density(geom='line') + xlim(-5,5)
  m[2] = ggplot(dat, aes(markers.CD16, fill=idx)) + stat_density(geom='line') + xlim(-5,5)
}

markers = colnames(dat)[-NCOL(dat)]
J = 8
plotlist = as.list(1:8)
for (j in 1:8) {
  m = ggplot(dat, aes_string(markers[j], fill='idx'))
  m = m + stat_density(geom='line') + xlim(-7,8)
  plotlist[[j]] = m
}

multiplot(plotlist=plotlist, cols=2)


