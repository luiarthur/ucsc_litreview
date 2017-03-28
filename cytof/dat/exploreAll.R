dat <- read.csv("ALL.csv",skip=1)

N <- nrow(dat)
K <- ncol(dat)

Z <- dat[,(K-30+1):K]
Y <- dat[,1:(K-30)]

hist(log(Y[which(Z[,25]==0),3]))
