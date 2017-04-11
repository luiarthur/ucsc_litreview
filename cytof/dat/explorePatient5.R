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

# CORRELATION
my.image(cor(pat5_d54),f=label_markers,xaxt='n',yaxt='n',xlab="",ylab="",
         main="Patient 5 (Day 54) Correlation b/w Markers",addLegend=TRUE)
my.image(cor(pat5_d70),f=label_markers,xaxt='n',yaxt='n',xlab="",ylab="",
         main="Patient 5 (Day 70) Correlation b/w Markers",addLegend=TRUE)
my.image(cor(pat5_d93),f=label_markers,xaxt='n',yaxt='n',xlab="",ylab="",
         main="Patient 5 (Day 93) Correlation b/w Markers",addLegend=TRUE)

for (p in seq(.1,.9,by=.1)) 
my.image(cor(pat5_d54)>p,f=label_markers,xaxt='n',yaxt='n',xlab="",ylab="",
         main=paste0("Patient 5 (Day 54) Correlation b/w Markers > ",p*100,"%"))

for (p in seq(.1,.9,by=.1)) 
my.image(cor(pat5_d70)>p,f=label_markers,xaxt='n',yaxt='n',xlab="",ylab="",
         main=paste0("Patient 5 (Day 70) Correlation b/w Markers > ",p*100,"%"))

for (p in seq(.1,.9,by=.1)) 
my.image(cor(pat5_d93)>p,f=label_markers,xaxt='n',yaxt='n',xlab="",ylab="",
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


### log(y/c) ### 
pdf("img/hist.pdf")
par(mfrow=c(3,1),mar=c(2,4,3,2))
for (i in 1:ncol(pat5_d54)) {
  hist(log((pat5_d54[,i]+1E-3) / pat5_d54_cutoff[i]),xlab="",
       main=paste0("Patient 5 Day 54 -- ", colnames(pat5_d54)[i],": log(expression / cutoff)"),prob=TRUE,ylab="Probability")

  hist(log((pat5_d70[,i]+1E-3) / pat5_d70_cutoff[i]),xlab="",
       main=paste0("Patient 5 Day 70 -- ", colnames(pat5_d54)[i],": log(expression / cutoff)"),prob=TRUE,ylab="Probability")

  hist(log((pat5_d93[,i]+1E-5) / pat5_d93_cutoff[i]),xlab="",
       main=paste0("Patient 5 Day 93 -- ", colnames(pat5_d54)[i],": log(expression / cutoff)"),prob=TRUE,ylab="Probability")
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
