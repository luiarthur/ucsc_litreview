library(cytof2)
library(rcommon)

transform_data <- function(dat, co) {
  as.matrix(t(log(t(dat) / co)))
  #as.matrix(t(log(t(dat+1) / (co+1))))
}

PATH <- "../../../dat/cytof_data_lili/cytof_data_lili/"

pat5_d54 <- read.expression.file(paste0(PATH,"patients/005_D54_CLEAN.csv"))
pat5_d70 <- read.expression.file(paste0(PATH,"patients/005_D70_CLEAN.csv"))
pat5_d93 <- read.expression.file(paste0(PATH,"patients/005_D93_CLEAN.csv"))

pat5_d54_cutoff<-read.cutoff.file(paste0(PATH,"patients/005_D54_CLEAN_cutoff.csv"))
pat5_d70_cutoff<-read.cutoff.file(paste0(PATH,"patients/005_D70_CLEAN_cutoff.csv"))
pat5_d93_cutoff<-read.cutoff.file(paste0(PATH,"patients/005_D93_CLEAN_cutoff.csv"))

y <- list(transform_data(pat5_d54, pat5_d54_cutoff),
          transform_data(pat5_d70, pat5_d70_cutoff),
          transform_data(pat5_d93, pat5_d93_cutoff))
J <- NCOL(y[[1]])

set.seed(1)

redToBlue <- colorRampPalette(c('red','grey90','blue'))(12)
blueToRed <- rev(redToBlue)

plot.histModel2(y, xlim=c(-5,5))
my.image(y[[1]], mn=-5, mx=5, col=blueToRed, addLegend=TRUE)
my.image(y[[2]], mn=-5, mx=5, col=blueToRed, addLegend=TRUE)
my.image(y[[3]], mn=-5, mx=5, col=blueToRed, addLegend=TRUE)


out <- cytof_fix_K_fit(y,
                       init=NULL,
                       prior=NULL,
                       truth=list(K=4), 
                       thin=0, B=200, burn=300,
                       compute_loglike=1, print_freq=1)



ll <- sapply(out, function(o) o$ll)
plot(ll <- sapply(out, function(o) o$ll), type='l')

# Z
Z <- lapply(out, function(o) o$Z)
Z_mean <- Reduce("+", Z) / length(Z)
ord <- left_order(Z_mean)
my.image(Z_mean[,ord], main="posterior")


# beta
beta_0 = sapply(out, function(o) o$beta_0)
plotPosts(t(beta_0[1:4,]))
plotPosts(t(beta_0[5:8,]))
plotPosts(t(beta_0[9:12,]))

betaBar_0 = sapply(out, function(o) o$betaBar_0)
rowMeans(betaBar_0)

beta_1 = sapply(out, function(o) o$beta_1)
rowMeans(beta_1)
plotPosts(t(beta_1[1:4,]))
plotPosts(t(beta_1[5:8,]))
plotPosts(t(beta_1[9:12,]))



my1 <- matrix(last(out)$missing_y[[1]], ncol=J)
y1 <- y[[1]]

hist(y1[y1[,1]>0,1], col=rgb(1,0,0,.3), border='white')
hist(my1[my1[,1]>0,1], col=rgb(0,0,1,.3), border='white', add=T)


hist(y1[y1[,1]<0,1], col=rgb(1,0,0,.3), border='white')
hist(my1[my1[,1]<0,1], col=rgb(0,0,1,.3), border='white', add=T)

