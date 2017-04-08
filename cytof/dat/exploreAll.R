library(rcommon)
source("myimage.R")
dat_all <- read.csv("ALL.csv",skip=1)
dat_CB34 <- read.csv("cytof_data_lili/cytof_data_lili/cb/CB34_CLEAN.csv")

N <- nrow(dat_all)
K <- ncol(dat_all)

Z <- dat_all[,(K-30+1):K]
Y <- dat_all[,1:(K-30)]

hist(log(Y[which(Z[,25]==0),3]))

nonzero_rows <- apply(dat_CB34[,1:10],1,function(r) all(r!=0))
my.pairs(log(dat_CB34[nonzero_rows,1:10]))


# CLUSTER
#clusters <- kmeans(t(dat_CB34),centers=3)
D <- dist(t(dat_CB34))
hc <- hclust(D)

ord <- hc$order

# AXIS
f <- function(dummy) {
  axis(1,at=1:ncol(dat_CB34),label=colnames(dat_CB34)[ord],las=2,cex.axis=.6,fg='grey')
  axis(2,at=1:ncol(dat_CB34),label=colnames(dat_CB34)[ord],las=1,cex.axis=.6,fg='grey')
}

plot(hc)
COR <- cor(dat_CB34[,ord])
my.image(COR, main="Correlation b/w Markers", xlab="", ylab="",xaxt='n',yaxt='n',f=f)
#my.image(abs(COR), main="Correlation b/w Markers", xlab="", ylab="",xaxt='n',yaxt='n',f=f)

