library(rcommon)
source("myimage.R")

filt <- function(f,x) x[f(x)]

parse_marker <- function(x) {
  x <- toupper(gsub("[-|.]","",x))
  x <- toupper(gsub("^KIR","",x))
  x <- toupper(gsub("^X","",x))
  x
}

order_col <- function(x, trans=identity) {
  colnames(x) <- trans(colnames(x))
  x[,order(colnames(x))] 
}

label_markers <- function(dat) {
  axis(1,at=1:ncol(dat),label=colnames(dat),las=2,cex.axis=.6,fg='grey')
  axis(2,at=1:ncol(dat),label=colnames(dat),las=1,cex.axis=.6,fg='grey')
}

# Analyze patients/005_D93_CLEAN_cutoff.csv (preped by me)
PATH <- "cytof_data_lili/cytof_data_lili/"

pat5_d54 <- order_col(read.csv(paste0(PATH,"patients/005_D54_CLEAN.csv")),parse_marker)
pat5_d70 <- order_col(read.csv(paste0(PATH,"patients/005_D70_CLEAN.csv")),parse_marker)
pat5_d93 <- order_col(read.csv(paste0(PATH,"patients/005_D93_CLEAN.csv")),parse_marker)

# Assert marker names are the same!
stopifnot(
  all(colnames(pat5_d54) == colnames(pat5_d70)) &&
  all(colnames(pat5_d54) == colnames(pat5_d93))
)

# CORRELATION
my.image(cor(pat5_d54)>.8,f=label_markers,xaxt='n',yaxt='n',xlab="",ylab="",
         main="Patient 5 (Day 54) Correlation b/w Markers > .8")


# Percentage of 0's
zeros <- function(dat) apply(dat,2,function(x) mean(x==0))
pat5_d54_zeros <- zeros(pat5_d54)
pat5_d70_zeros <- zeros(pat5_d70)
pat5_d93_zeros <- zeros(pat5_d93)
pat5_zeros <- rbind(pat5_d54_zeros,pat5_d70_zeros,pat5_d93_zeros)
rownames(pat5_zeros) <- paste0("pat5_",c("d54","d70","d93"))

# READ PB
pbs <- {
  x <- list.files(paste0(PATH,"pb"))
  fn <- paste0(PATH,"pb/",x[grep("csv",x)])
  setNames(
    lapply(as.list(fn),function(f) order_col(read.csv(f),parse_marker)),
    gsub("[_CLEAN]*.csv", "", x[grep("csv",x)])
  )
}
names(pbs)
# Assert PB marker names are the same!
stopifnot(
  all(sapply(pbs,function(x) all(colnames(x) == colnames(pat5_d70))))
)

cbs <- {
  x <- list.files(paste0(PATH,"cb"))
  fn <- paste0(PATH,"cb/",x[grep("csv",x)])
  setNames(
    lapply(as.list(fn),function(f) order_col(read.csv(f),parse_marker)),
    gsub("[_CLEAN]*.csv$", "", x[grep("csv",x)])
  )
}
names(cbs)

# Assert CB marker names are the same!
stopifnot(
  all(sapply(cbs,function(x) all(colnames(x) == colnames(pat5_d70))))
)

pbs_zeros <- t( sapply(pbs, zeros) )
cbs_zeros <- t( sapply(cbs, zeros) )
summary_zeros <- rbind(pat5_zeros,pbs_zeros,cbs_zeros)


# Summary of percentage of 0's
my.image(t(summary_zeros),xlab="",ylab="Markers",xaxt="n",yaxt="n",
         main="Percentage of Expression Level == 0",
         f=function(dat) {
           axis(1,at=1:ncol(dat),label=colnames(dat),las=2,cex.axis=.6,fg='grey')
           axis(2,at=1:nrow(dat),label=rownames(dat),las=1,cex.axis=.6,fg='grey')
         })
t(summary_zeros)

