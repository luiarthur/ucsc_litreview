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

  plot(trans.mean[,1],1:nrow(trans.mean),xlim=range(ci),type='n', fg='grey', ylab="",xlab="",yaxt='n',bty='n', ...)
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


### cutoff is a list of corresponding cutoff vectors
plot.boxplotModel2 <- function(dat, cutoff, col=rgb(1,0,0,.3),...) {
  stopifnot( length(dat) == length(cutoff) )
  I <- length(dat)

  ### Transform Raw Data to Y
  transform_data <- function(d, co) {
    Y <- t(log(t(as.matrix(d)) / co))
    ifelse(Y == -Inf, NA, Y)
  }

  ### Transpose of Y
  Y_list <- lapply(as.list(1:I), function(i) {
    transform_data(dat[[i]], cutoff[[i]])
  })

  COLOR = col
  markers <- colnames(Y_list[[1]])
  J <- length(markers)

  cur_fg <- par("fg")
  par("fg"="grey")

  xlab <- paste0("I=", I)
  for (i in 1:I) {
    if (i == 1) {
      boxplot(Y_list[[i]], horizontal=TRUE, outline=FALSE, col=COLOR, add=FALSE,
              xaxt='n', yaxt='n', border='grey30', xlab=xlab, ...)
    } else {
      boxplot(Y_list[[i]], horizontal=TRUE, outline=FALSE, col=COLOR, add=TRUE,
              xaxt='n', yaxt='n', border='grey30')
    }
  }
  axis(2,at=1:J,label=markers,las=1,cex.axis=.6, fg='grey')
  axis(1, fg='grey')
  abline(v=log(1), col='grey')

  par("fg"=cur_fg)
}


### cutoff is a list of corresponding cutoff vectors
plot.histModel2_old <- function(dat, cutoff, returnStats=FALSE,
                                col=rgb(1,0,0,.3), 
                                quant=c(.025,.975), ...) {
                            
  stopifnot( length(dat) == length(cutoff) )
  I <- length(dat)
  xlab <- paste0("I=", I)
  COL <- col

  transform_data <- function(dat, co) {
    as.matrix(t(log(t(dat) / co)))
  }

  Y <- lapply(as.list(1:I), function(i) {
    Yi <- transform_data(dat[[i]], cutoff[[i]])
    ifelse(Yi == -Inf, NA, Yi)
  })

  Y.mean <- sapply(Y, colMeans, na.rm=TRUE)
  Y.ci <- lapply(Y, function(Yi) {
    t(apply(Yi, 2, quantile, probs=quant, na.rm=TRUE))
  })

  args <- list(...)
  xlim_provided <- "xlim" %in% names(args)

  if (xlim_provided) {
   plot(Y.mean[,1],1:nrow(Y.mean),type='n',
        fg='grey', ylab="",xlab=xlab,yaxt='n',bty='n', ...)
  } else {
    plot(Y.mean[,1],1:nrow(Y.mean),type='n',xlim=range(Y.ci),
         fg='grey', ylab="",xlab=xlab,yaxt='n',bty='n', ...)
  }
  abline(h=1:nrow(Y.mean),col='grey85',lty=2)
  axis(2,at=1:nrow(Y.mean),label=rownames(Y.mean),las=1,
       cex.axis=.6, fg='grey')

  print(length(Y.ci))
  sapply(1:I, function(i) {
    add.errbar(Y.ci[[i]],transpose=TRUE,col=COL, lwd=10, lend=1)
  })

  abline(v=0, col='grey')
  sapply(1:I, function(i) {
    points(Y.mean[,i],1:nrow(Y.mean),pch=20,cex=.5, col='grey30')
  })

  if (returnStats) list(mean=Y.mean, ci=Y.ci)
}

### cutoff is a list of corresponding cutoff vectors
plot.histModel2 <- function(dat, cutoff, returnStats=FALSE,
                            col0=rgb(0,0,1,1/length(dat)), 
                            col1=rgb(1,0,0,1/length(dat)), 
                            quant=c(.025,.975), ...) {
                            
  stopifnot( length(dat) == length(cutoff) )
  I <- length(dat)
  xlab <- paste0("I=", I)
  COL0 <- col0
  COL1 <- col1
  J <- NCOL(dat[[1]])
  markers <- colnames(dat[[1]])

  transform_data <- function(dat, co) {
    as.matrix(t(log(t(dat) / co)))
  }

  Y <- lapply(as.list(1:I), function(i) {
    Yi <- transform_data(dat[[i]], cutoff[[i]])
    ifelse(Yi == -Inf, NA, Yi)
  })

  f0 <- function(X, f)
    apply(X, 2, function(Xj) f(Xj[Xj<0], na.rm=TRUE))

  f1 <- function(X, f)
    apply(X, 2, function(Xj) f(Xj[Xj>0], na.rm=TRUE))

  Y0.mean <- sapply(Y, f0, mean)
  Y1.mean <- sapply(Y, f1, mean)

  f.ci <- function(col,na.rm) quantile(col, probs=quant, na.rm=na.rm)
  Y0.ci <- lapply(Y, function(Yi) t(f0(Yi, f.ci)))
  Y1.ci <- lapply(Y, function(Yi) t(f1(Yi, f.ci)))

  f.N <- function(col, na.rm=TRUE) length(col[!is.na(col)])
  Y0.N <- sapply(Y, f0, f.N)
  Y1.N <- sapply(Y, f1, f.N)

  args <- list(...)
  xlim_provided <- "xlim" %in% names(args)

  if (xlim_provided) {
   plot(Y0.mean[,1],1:nrow(Y0.mean),type='n',
        fg='grey', ylab="",xlab=xlab,yaxt='n',bty='n', ...)
  } else {
    plot(Y0.mean[,1],1:nrow(Y0.mean),type='n',xlim=range(Y0.ci),
         fg='grey', ylab="",xlab=xlab,yaxt='n',bty='n', ...)
  }
  abline(h=1:J, col='grey85', lty=2)
  axis(2, at=1:J, label=markers, las=1, cex.axis=.6, fg='grey')

  ### Plot CI ###
  sapply(1:I, function(i) {
    add.errbar(Y0.ci[[i]], transpose=TRUE, col=COL0,lwd=10,lend=1)
    add.errbar(Y1.ci[[i]], transpose=TRUE, col=COL1,lwd=10,lend=1)
  })
  abline(v=0, col='grey')

  ### Plot Means ###
  sapply(1:I, function(i) {
    # Higher val => more data => Darker Color [0,.5]
    val0 = sapply(Y0.N[,i] / 1000, function(x) min(x,1))
    val1 = sapply(Y1.N[,i] / 1000, function(x) min(x,1))
    print(i)
    print(val0)
    print(val1)
    points(Y0.mean[,i], 1:J, pch=20, cex=.5, col=grey(1-val0))
    points(Y1.mean[,i], 1:J, pch=20, cex=.5, col=grey(1-val1))
  })

  if (returnStats) list(mean=Y0.mean, ci=Y0.ci)
}
