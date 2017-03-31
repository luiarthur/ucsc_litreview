dat_all <- read.csv("ALL.csv",skip=1)

N <- nrow(dat_all)
K <- ncol(dat_all)

Z <- dat_all[,(K-30+1):K]
Y <- dat_all[,1:(K-30)]

hist(log(Y[which(Z[,25]==0),3]))

dat_CB34 <- read.csv("cytof_data_lil/cytof_data_lili/cb/CB34_CLEAN.csv")
