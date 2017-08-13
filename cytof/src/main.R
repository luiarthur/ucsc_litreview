library(rcommon)
source("cytof.R")
source("../dat/readExpression.R")
source("../dat/myimage.R")

### PATH to DATA ###
PATH <- "../dat/cytof_data_lili/cytof_data_lili/"

### PATIENT 5 DATA ###
pat5_d54 <- read.expression.file(paste0(PATH,"patients/005_D54_CLEAN.csv"))
pat5_d70 <- read.expression.file(paste0(PATH,"patients/005_D70_CLEAN.csv"))
pat5_d93 <- read.expression.file(paste0(PATH,"patients/005_D93_CLEAN.csv"))

### Read Cutoff Files ###
pat5_d54_cutoff<-read.cutoff.file(paste0(PATH,"patients/005_D54_CLEAN_cutoff.csv"))
pat5_d70_cutoff<-read.cutoff.file(paste0(PATH,"patients/005_D70_CLEAN_cutoff.csv"))
pat5_d93_cutoff<-read.cutoff.file(paste0(PATH,"patients/005_D93_CLEAN_cutoff.csv"))

### PATIENT 5
pat5 <- list(pat5_d54=pat5_d54, pat5_d70=pat5_d70, pat5_d93=pat5_d93)
pat5_cutoff <- list(pat5_d54=pat5_d54_cutoff, 
                    pat5_d70=pat5_d70_cutoff, 
                    pat5_d93=pat5_d93_cutoff)
stopifnot(all.equal(names(pat5), names(pat5_cutoff)))

I <- length(pat5)
y <- lapply(as.list(1:I), function(i)
            as.matrix(log( pat5[[i]]/pat5_cutoff[[i]] + 1)))

### Plot histogram of Data. Use this for psi_j means?
par(mfrow=c(3,1))
hist(colMeans(y[[1]]), col=rgb(1,0,0, .2), prob=TRUE, xlim=c(0, 4), border='white')
hist(colMeans(y[[2]]), col=rgb(0,1,0, .4), prob=TRUE, xlim=c(0, 4), border='white')
hist(colMeans(y[[3]]), col=rgb(0,0,1, .2), prob=TRUE, xlim=c(0, 4), border='white')
par(mfrow=c(1,1))

hist(y[[1]][,1])

ord <- sapply(y, function(x) order(colMeans(x), decreasing=TRUE))

my.image(y[[1]][,ord[,1]], addLegend=T, mn=0, mx=6)
my.image(y[[2]][,ord[,2]], addLegend=T, mn=0, mx=6)
my.image(y[[3]][,ord[,3]], addLegend=T, mn=0, mx=6)


### Correlations
redToBlue <- colorRampPalette(c('red','grey90','blue'))(12)
my.image(cor(y[[1]][,ord[,1]]), xaxt='n',yaxt='n',xlab="",ylab="", col=redToBlue,
         main="y1 Correlation b/w Markers",addLegend=TRUE, mn=-1, mx=1)
my.image(cor(y[[2]][,ord[,2]]), xaxt='n',yaxt='n',xlab="",ylab="", col=redToBlue,
         main="y2 Correlation b/w Markers",addLegend=TRUE, mn=-1, mx=1)
my.image(cor(y[[3]][,ord[,3]]), xaxt='n',yaxt='n',xlab="",ylab="", col=redToBlue,
         main="y3 Correlation b/w Markers",addLegend=TRUE, mn=-1, mx=1)

rbind(apply(y[[1]], 2, mean),
      apply(y[[2]], 2, mean),
      apply(y[[3]], 2, mean))

p <- .05
N_i <- sapply(y, nrow)
train_idx <- lapply(N_i, function(N) sample(1:N, round(N*p)))
y_TE <- lapply(as.list(1:I), function(i) y[[i]][-train_idx[[i]],])
y_TR <- lapply(as.list(1:I), function(i) y[[i]][ train_idx[[i]],])

set.seed(1)
library(rcommon)
source("cytof.R")
out <- cytof(y_TE, y_TR, burn_small=100, K_min=1, K_max=5, a_K=1,
             burn=100, B=200, pr=1)

psi <- t(sapply(out, function(o) o$psi))
plotPost(psi[,32])
plotPosts(psi[,1:5])
plot(apply(psi, 2, function(pj) length(unique(pj)) / length(out)),
     ylim=0:1, main="Acceptance rate for psi")
abline(h=c(.25, .4), col='grey')

Z <- lapply(out, function(o) o$Z)
Z_mean <- Reduce("+", Z) / length(Z)
my.image(Z_mean >= .4)
my.image(Z_mean)
