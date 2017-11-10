library(rcommon)
source("myimage.R")        # Helper function for plotting images
source("readExpression.R") # Helper functions for reading 
                           #   1. marker expression data 
                           #   2. cutoff files
IMG_DIR = "img/model2/"

# Analyze patients/005_D93_CLEAN_cutoff.csv (preped by me)
PATH <- "cytof_data_lili/cytof_data_lili/"

pat5_d54 <- read.expression.file(paste0(PATH,"patients/005_D54_CLEAN.csv"))
pat5_d70 <- read.expression.file(paste0(PATH,"patients/005_D70_CLEAN.csv"))
pat5_d93 <- read.expression.file(paste0(PATH,"patients/005_D93_CLEAN.csv"))

# Read Cutoff Files
pat5_d54_cutoff<-read.cutoff.file(paste0(PATH,"patients/005_D54_CLEAN_cutoff.csv"))
pat5_d70_cutoff<-read.cutoff.file(paste0(PATH,"patients/005_D70_CLEAN_cutoff.csv"))
pat5_d93_cutoff<-read.cutoff.file(paste0(PATH,"patients/005_D93_CLEAN_cutoff.csv"))

# PB CUTOFF FILES
pb_cutoff <- read.cutoff.in.dir(paste0(PATH,"pb/"))
cb_cutoff <- read.cutoff.in.dir(paste0(PATH,"cb/"))

# Assert pb and cutoff file colnames are the same!
stopifnot(
  all(apply(sapply(pb_cutoff,names),1,function(r) length(unique(r))==1)) &&
  all(apply(sapply(cb_cutoff,names),1,function(r) length(unique(r))==1))
)

# Assert cutoff files columns names are the same!
stopifnot(
  all(names(pat5_d54_cutoff) == colnames(pat5_d54)) &&
  all(names(pat5_d70_cutoff) == colnames(pat5_d54)) &&
  all(names(pat5_d93_cutoff) == colnames(pat5_d54))
)


# Assert marker names are the same!
stopifnot(
  all(colnames(pat5_d54) == colnames(pat5_d70)) &&
  all(colnames(pat5_d54) == colnames(pat5_d93))
)

redToBlue <- colorRampPalette(c('red','grey90','blue'))(12)
blueToRed <- rev(redToBlue)

# READ PB
pbs <- read.expression.in.dir(paste0(PATH,"pb/"))
names(pbs)
# Assert PB marker names are the same!
stopifnot(
  all(sapply(pbs,function(x) all(colnames(x) == colnames(pat5_d70))))
)

cbs <- read.expression.in.dir(paste0(PATH,"cb/"))
names(cbs)
# Assert CB marker names are the same!
stopifnot(
  all(sapply(cbs,function(x) all(colnames(x) == colnames(pat5_d70))))
)

stopifnot(all(names(cbs)==names(cb_cutoff)))
stopifnot(all(names(pbs)==names(pb_cutoff)))


### NEW: image of Data
orderRows <- function(X) {
  X[do.call(order, lapply(1:NCOL(X), function(i) X[, i])), ]
}
uniqueRows <- function(X) {
  U <- unique(X, MARGIN=1)
  orderRows(U)
}

plot_dat <- function(dat, cutoff, name="") {
  X <- as.matrix(dat)
  Y <- log(t(t(X) / cutoff))

  #plot(apply(z,2,function(zc) min(zc[zc > 0])), xlab='', xaxt='n', fg='grey', 
  if (name > "") pdf(paste0(IMG_DIR,name,"_Y.pdf"))
    ### Histogram of Y
    hist(Y, border='white', col='steelblue',
         main=paste("Histogram of Y[>0]:", name))
    #min(Y[Y > -Inf])

    ### Plot of Column Means of Y
    plot(colMeans(X), type='h', xlab='', xaxt='n', 
         main=paste('Column Means of Raw Data', name))
    axis(1,at=1:ncol(X), label=colnames(dat), las=2, cex.axis=.6, fg='grey')

    ### Plot Column Mins of Y
    plot(ycols <- apply(Y,2,function(yc) min(yc[yc > -Inf])), xlab='', xaxt='n',
         fg='grey', pch=20, cex=2,, ylab='',
         main=paste("min(log(Y[>0] / cutoff)) of each marker:", name))
    label_markers(dat)
    abline(v=1:ncol(Y), col='grey85', lty=2)

    ### Histogram of Y Col mins
    hist(ycols, col='steelblue', border='white',
         main=paste("Histogram of min(log(Y[>0] / cutoff)) of each marker:", name))


    #mn <- round(quantile(ycols, .025), 1)
    mn <- round(min(Y[Y>-Inf]), 1)
    mx <- round(quantile(Y, .975), 1)
    med <- round(median(Y), 1)

    ### Data Y Image
    my.image(Y, mn=mn, mx=mx, col=blueToRed, f=label_markers, xlab="", xaxt='n',
             addLegend=T, main=paste("Y:", name), useRaster=TRUE)

    ### Binarized 
    Z <- as.matrix(Y > med) * 1
    my.image(Z, yaxt='n', xaxt='n', ylab='', xlab='',
             main=paste("Y[> median]:", name), useRaster=TRUE)
    axis(1,at=1:ncol(Z), label=colnames(dat), las=2, cex.axis=.6, fg='grey')

    #my.image(uniqueRows(Z), yaxt='n', ylab='')
    ### Rows of estimated Z Ordered
    my.image(orderRows(Z), yaxt='n', ylab='', xaxt='n', xlab='',
             main=paste("Y sorted by rows:", name), useRaster=TRUE)
    axis(1,at=1:ncol(Z), label=colnames(dat), las=2, cex.axis=.6, fg='grey')

    ### Histogram of Y_j for each j
    J <- ncol(Y)
    par(mfrow=c(4,2))
    for (j in 1:J) {
      hist(Y[,j], main=paste0("Histogram of Y[,",j,"]: ", name), prob=T, 
           xlim=c(min(Y[Y>-Inf]), max(Y)),
           col='steelblue', border='white', xlab=paste0('Y[,',j,']'))
    }
    par(mfrow=c(1,1))

  if (name > "") dev.off()
}

plot_dat(pat5_d54, pat5_d54_cutoff, "pat5_d54")
plot_dat(pat5_d70, pat5_d70_cutoff, "pat5_d70")
plot_dat(pat5_d93, pat5_d93_cutoff, "pat5_d93")

plot_dat(pbs[[1]], pb_cutoff[[1]], "pb1")
plot_dat(cbs[[1]], cb_cutoff[[1]], "cb1")
plot_dat(cbs[[2]], cb_cutoff[[2]], "cb2")


