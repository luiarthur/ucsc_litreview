library(foreach)
library(doMC)
registerDoMC(as.numeric(system("nproc",intern=TRUE)))

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

read.cutoff.file <- function(f) {
  tmp <- read.csv(f,header=FALSE)
  x <- tmp[,2]
  names(x) <- parse_marker(tmp[,1])
  x[order(names(x))]
}

read.cutoff.in.dir <- function(path) {
  x <- list.files(path)
  fn <- paste0(path,x[grep("cutoff.csv",x)])

  setNames(
    lapply(as.list(fn),read.cutoff.file),
    gsub("[_CLEAN_cutoff]*.csv", "", x[grep("cutoff.csv",x)])
  )
}

read.expression.file <- function(f) {
  order_col(read.csv(f),parse_marker)
}

read.expression.in.dir <- function(path) {
  x <- list.files(path)
  fn <- paste0(path,x[grep("[^cutoff].csv",x)])
  all_dat <- foreach(f=as.list(fn)) %dopar% read.expression.file(f)
  setNames(
    all_dat, 
    gsub("[_CLEAN]*.csv", "", x[grep("[^cutoff].csv",x)])
  )
}


### Transform data
trans.y <- function(y,cutoff,eps=0) {
  log((t(y)+eps) / cutoff)
}

### y is a list of expression matrices
### cutoff is a list of corresponding cutoff vectors
plot.expression.mean.sd <- function(y,cutoff,eps=1E-3,returnStats=FALSE,
                                    col=rgb(0,0,1,.5),...) {
  stopifnot( length(y) == length(cutoff) )

  COL <- col
  N <- length(y)

  trans.mean <- sapply(1:N, function(i) {
    apply(trans.y(y[[i]],cutoff[[i]],eps=eps),1,mean)}
  )
  trans.sd <- sapply(1:N, function(i) {
    apply(trans.y(y[[i]],cutoff[[i]],eps=eps),1,sd)}
  )
  ci <- lapply(1:N, function(i) {
    cbind(
      trans.mean[,i]-trans.sd[,i], 
      trans.mean[,i]+trans.sd[,i]
    )
  }) 

  plot(trans.mean[,1],1:nrow(trans.mean),xlim=range(ci),type='n',
       fg='grey', ylab="",xlab="",yaxt='n',bty='n', ...)
  abline(h=1:nrow(trans.mean),col='grey85',lty=2)
  axis(2,at=1:nrow(trans.mean),label=rownames(trans.mean),las=1,cex.axis=.6,
       fg='grey')

  sapply(1:N, function(i) {
    points(trans.mean[,i],1:nrow(trans.mean),pch=20,cex=2,col=COL)
    add.errbar(ci[[i]],transpose=TRUE,col=COL)
  })

  if (returnStats) {
    return( list(mean=trans.mean, sd=trans.sd, ci=ci) )
  }
}

