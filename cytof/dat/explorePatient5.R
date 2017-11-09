library(rcommon)
source("myimage.R")        # Helper function for plotting images
source("readExpression.R") # Helper functions for reading 
                           #   1. marker expression data 
                           #   2. cutoff files

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

# CORRELATION
my.image(cor(pat5_d54),f=label_markers,xaxt='n',yaxt='n',xlab="",ylab="",
         mn=-1,mx=1,col=redToBlue,
         main="Patient 5 (Day 54) Correlation b/w Markers",addLegend=TRUE)
my.image(cor(pat5_d70),f=label_markers,xaxt='n',yaxt='n',xlab="",ylab="",
         mn=-1,mx=1,col=redToBlue,
         main="Patient 5 (Day 70) Correlation b/w Markers",addLegend=TRUE)
my.image(cor(pat5_d93),f=label_markers,xaxt='n',yaxt='n',xlab="",ylab="",
         mn=-1,mx=1,col=redToBlue,
         main="Patient 5 (Day 93) Correlation b/w Markers",addLegend=TRUE)

for (p in seq(.1,.9,by=.1)) 
my.image(abs(cor(pat5_d54))>p,f=label_markers,xaxt='n',yaxt='n',xlab="",ylab="",
         main=paste0("Patient 5 (Day 54) Correlation b/w Markers > ",p*100,"%"))

for (p in seq(.1,.9,by=.1)) 
my.image(abs(cor(pat5_d70))>p,f=label_markers,xaxt='n',yaxt='n',xlab="",ylab="",
         main=paste0("Patient 5 (Day 70) Correlation b/w Markers > ",p*100,"%"))

for (p in seq(.1,.9,by=.1)) 
my.image(abs(cor(pat5_d93))>p,f=label_markers,xaxt='n',yaxt='n',xlab="",ylab="",
         main=paste0("Patient 5 (Day 93) Correlation b/w Markers > ",p*100,"%"))


# Percentage of 0's
zeros <- function(dat) apply(dat,2,function(x) mean(x==0))
pat5_d54_zeros <- zeros(pat5_d54)
pat5_d70_zeros <- zeros(pat5_d70)
pat5_d93_zeros <- zeros(pat5_d93)
pat5_zeros <- rbind(pat5_d54_zeros,pat5_d70_zeros,pat5_d93_zeros)
rownames(pat5_zeros) <- paste0("pat5_",c("d54","d70","d93"))

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

pbs_zeros <- t( sapply(pbs, zeros) )
cbs_zeros <- t( sapply(cbs, zeros) )
summary_zeros <- rbind(pat5_zeros,pbs_zeros,cbs_zeros)


# Summary of percentage of 0's
my.image(t(summary_zeros),xlab="",ylab="Markers",xaxt="n",yaxt="n",
         main="Percentage of Expression Level == 0",
         f=function(dat) {
           axis(1,at=1:ncol(dat),label=colnames(dat),las=2,cex.axis=.6,fg='grey')
           axis(2,at=1:nrow(dat),label=rownames(dat),las=1,cex.axis=.6,fg='grey')
         },addLegend=TRUE)
t(summary_zeros)

for (p in seq(.1,.9,by=.1))
my.image(t(summary_zeros)>p,xlab="",ylab="Markers",xaxt="n",yaxt="n",
         main=paste0("Percentage of Expression Level == 0 (>",p*100,"%)"),
         f=function(dat) {
           axis(1,at=1:ncol(dat),label=colnames(dat),las=2,cex.axis=.6,fg='grey')
           axis(2,at=1:nrow(dat),label=rownames(dat),las=1,cex.axis=.6,fg='grey')
         })


### log(1 + y/c) ### 
pdf("img/hist.pdf")
par(mfrow=c(3,1),mar=c(2,4,3,2))
for (i in 1:ncol(pat5_d54)) {
  hist(log(1 + pat5_d54[,i] / pat5_d54_cutoff[i]),xlab="",xlim=c(0,6),
       main=paste0("Patient 5 Day 54 -- ", colnames(pat5_d54)[i],": log(1 + expression / cutoff)"),prob=TRUE,ylab="Probability")

  hist(log(1 + pat5_d70[,i] / pat5_d70_cutoff[i]),xlab="",xlim=c(0,6),
       main=paste0("Patient 5 Day 70 -- ", colnames(pat5_d54)[i],": log(1 + expression / cutoff)"),prob=TRUE,ylab="Probability")

  hist(log(1 + pat5_d93[,i] / pat5_d93_cutoff[i]),xlab="",xlim=c(0,6),
       main=paste0("Patient 5 Day 93 -- ", colnames(pat5_d54)[i],": log(1 + expression / cutoff)"),prob=TRUE,ylab="Probability")
  #readline()
}
par(mfrow=c(1,1),mar=c(5.1,4.1,4.1,2.1))
dev.off()



### Log((Expression+eps) / Cutoff) PLOTS FOR PB & CB ### 
pdf('img/logExpressionOverCutoff.pdf')
plot.expression.mean.sd(list(pat5_d54,pat5_d70,pat5_d93), 
                        list(pat5_d54_cutoff,pat5_d70_cutoff,pat5_d93_cutoff),
                        main="Patient5: log[(y+eps)/cutoff]")

plot.expression.mean.sd(pbs,pb_cutoff,main="PB: log[(y+eps)/cutoff]")
plot.expression.mean.sd(cbs,cb_cutoff,main="CB: log[(y+eps)/cutoff]")
dev.off()


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
  if (name > "") pdf(paste0("img/",name,"_Y.pdf"))
    ### Histogram of Y
    hist(Y, border='white', col='steelblue', main=paste("Histogram of Y:", name))
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
  if (name > "") dev.off()


  mn <- round(quantile(ycols, .025), 1)
  mx <- round(quantile(ycols, .975), 1)
  med <- round(median(ycols), 1)
  if (name > "") png(paste0("img/",name,"_Y.png"))
    my.image(Y, mn=mn, mx=mx, col=redToBlue, f=label_markers, xlab="", xaxt='n',
             addLegend=T, main=paste("Y:", name))
  if (name > "") dev.off()

  ### Binarized 
  if (name > "") png(paste0("img/",name,"_Y_gt_median.png"))
    Z <- as.matrix(Y > med) * 1
    my.image(Z, yaxt='n', xaxt='n', ylab='', xlab='',
             main=paste("Y[> median]:", name))
    axis(1,at=1:ncol(Z), label=colnames(dat), las=2, cex.axis=.6, fg='grey')
  if (name > "") dev.off()

  #my.image(uniqueRows(Z), yaxt='n', ylab='')
  if (name > "") png(paste0("img/",name,"_Y_sortedByRows.png"))
    my.image(orderRows(Z), yaxt='n', ylab='', xaxt='n', xlab='',
             main=paste("Y sorted by rows:", name))
    axis(1,at=1:ncol(Z), label=colnames(dat), las=2, cex.axis=.6, fg='grey')
  if (name > "") dev.off()
}

plot_dat(pat5_d54, pat5_d54_cutoff, "pat5_d54")
plot_dat(pat5_d70, pat5_d70_cutoff, "pat5_d70")
plot_dat(pat5_d93, pat5_d93_cutoff, "pat5_d93")

plot_dat(pbs[[1]], pb_cutoff[[1]], "pb1")
