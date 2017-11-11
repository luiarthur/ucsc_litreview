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
  ### Order by binary column
  #X[do.call(order, lapply(1:NCOL(X), function(i) X[, i])), ]

  ### Cluster rows by distance
  hc <- hclust(dist(X), method="single")
  X[hc$order,]
}

uniqueRows <- function(X) {
  U <- unique(X, MARGIN=1)
  orderRows(U)
}

xlim <- c(-10,10)
plot_dat <- function(dat, cutoff, name="") {
  X <- as.matrix(dat)
  Y <- log(t(t(X) / cutoff))

  #plot(apply(z,2,function(zc) min(zc[zc > 0])), xlab='', xaxt='n', fg='grey', 
  if (name > "") pdf(paste0(IMG_DIR,name,"_Y.pdf"))
    ### Histogram of Y
    hist(Y, border='white', col='steelblue',
         main=paste("Histogram of Y[>-Inf]:", name))
    #min(Y[Y > -Inf])

    ### Plot of Column Means of Y
    plot(colMeans(X), type='h', xlab='', xaxt='n', 
         main=paste('Column Means of Raw Data', name))
    axis(1,at=1:ncol(X), label=colnames(dat), las=2, cex.axis=.6, fg='grey')

    ### Plot Column Mins of Y
    plot(ycols <- apply(Y,2,function(yc) min(yc[yc > -Inf])), xlab='', xaxt='n',
         fg='grey', pch=20, cex=2,, ylab='',
         main=paste("min(Y[>-Inf])) of each marker:", name))
    label_markers(dat)
    abline(v=1:ncol(Y), col='grey85', lty=2)

    ### Histogram of Y Col mins
    hist(ycols, col='steelblue', border='white',
         main=paste("Histogram of min(log(Y[>0] / cutoff)) of each marker:", name))


    #mn <- round(quantile(ycols, .025), 1)
    mn <- -2 #round(min(Y[Y>-Inf]-0.1), 1)
    mx <-  2 #round(quantile(Y, .975), 1)
    #med <- round(median(Y), 1)

    ### Data Y Image
    my.image(Y, mn=mn, mx=mx, col=blueToRed, f=label_markers, xlab="", xaxt='n',
             addLegend=T, main=paste("Y:", name), useRaster=TRUE)

    #### Data Y Image Ordered
    #Y_tmp <- ifelse(Y==-Inf, -5, Y)
    #my.image(orderRows(Y_tmp[sample(1:nrow(Y), size=nrow(Y)*.05),]),
    #         mn=mn, mx=mx, col=blueToRed, f=label_markers, xlab="", xaxt='n',
    #         addLegend=T, main=paste("Y:", name), useRaster=TRUE)


    ### Binarized 
    Z <- as.matrix(Y > 0) * 1
    my.image(Z, yaxt='n', xaxt='n', ylab='', xlab='',
             main=paste("Y[> 0]:", name), useRaster=TRUE)
    axis(1,at=1:ncol(Z), label=colnames(dat), las=2, cex.axis=.6, fg='grey')

    #my.image(uniqueRows(Z), yaxt='n', ylab='')
    ### Rows of estimated Z Ordered
    my.image(orderRows(Z[sample(1:nrow(Z), size=nrow(Z)*.05),]),
             yaxt='n', ylab='', xaxt='n', xlab='',
             main=paste("Y[>0] clustered by rows:", name), useRaster=TRUE)
    axis(1,at=1:ncol(Z), label=colnames(dat), las=2, cex.axis=.6, fg='grey')

    ### Histogram of Y_j for each j
    J <- ncol(Y)
    par(mfrow=c(4,2))
    for (j in 1:J) {
      hist(Y[,j], main=paste0("Histogram of Y[,",j,"]: ", name), prob=T, 
           #xlim=c(min(Y[Y>-Inf]), max(Y)),
           xlim=xlim,
           col='steelblue', border='white', xlab=paste0('Y[,',j,']'))
    }
    par(mfrow=c(1,1))

  if (name > "") dev.off()
}

plot_dat(pat5_d54, pat5_d54_cutoff, "pat5_d54")
plot_dat(pat5_d70, pat5_d70_cutoff, "pat5_d70")
plot_dat(pat5_d93, pat5_d93_cutoff, "pat5_d93")

for (i in 1:length(pbs))
  plot_dat(pbs[[i]], pb_cutoff[[i]], paste0("pb",i))

for (i in 1:length(cbs))
  plot_dat(cbs[[i]], cb_cutoff[[i]], paste0("cb",i))



### Points Mean
#source("readExpression.R")
pdf(paste0(IMG_DIR, 'Y_compare.pdf'))
quant <- c(.1, .9)
#quant <- c(.025, .975)
main <- paste0("Mean and (", quant[1]*100, "%, ",quant[2]*100,"%) Quantiles for Y[>-Inf]")

pat5 <- list(pat5_d54,pat5_d70,pat5_d93)
pat5_cutoff <- list(pat5_d54_cutoff,pat5_d70_cutoff,pat5_d93_cutoff)
plot.histModel2(pat5, pat5_cutoff, quant=quant, xlim=xlim, main=paste("Patient5:", main))
plot.histModel2(pbs,pb_cutoff,quant=quant, xlim=xlim,col=rgb(1,0,0,.1),main=paste("PB:", main))
plot.histModel2(cbs,cb_cutoff,quant=quant, xlim=xlim,main=paste("CB:", main))
dev.off()

