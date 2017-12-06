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
  #' @export
  tmp <- read.csv(f,header=FALSE)
  x <- tmp[,2]
  names(x) <- parse_marker(tmp[,1])
  x[order(names(x))]
}

read.cutoff.in.dir <- function(path) {
  #' @export
  x <- list.files(path)
  fn <- paste0(path,x[grep("cutoff.csv",x)])

  setNames(
    lapply(as.list(fn),read.cutoff.file),
    gsub("[_CLEAN_cutoff]*.csv", "", x[grep("cutoff.csv",x)])
  )
}

read.expression.file <- function(f) {
  #' @export
  order_col(read.csv(f),parse_marker)
}

read.expression.in.dir <- function(path) {
  #' @export
  x <- list.files(path)
  fn <- paste0(path,x[grep("[^cutoff].csv",x)])
  all_dat <- foreach(f=as.list(fn)) %dopar% read.expression.file(f)
  setNames(
    all_dat, 
    gsub("[_CLEAN]*.csv", "", x[grep("[^cutoff].csv",x)])
  )
}


### cutoff is a list of corresponding cutoff vectors
plot.histModel2 <- function(dat, cutoff=NULL, returnStats=FALSE,
                            col0=rgb(0,0,1,1/length(dat)), 
                            col1=rgb(1,0,0,1/length(dat)), 
                            quant=c(.025,.975),
                            ...) {
                            
  #' @export
  preTransformed <- is.null(cutoff)
  if (!preTransformed) stopifnot( length(dat) == length(cutoff) )
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
    Yi <- if (preTransformed) dat[[i]] else transform_data(dat[[i]], cutoff[[i]])
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
    points(Y0.mean[,i], 1:J, pch=20, cex=.5, col=grey(1-val0))
    points(Y1.mean[,i], 1:J, pch=20, cex=.5, col=grey(1-val1))
  })

  if (returnStats) list(mean=Y0.mean, ci=Y0.ci)
}

plot_dat <- function(y, i, j, ...) {
  #' @export
  yij <- y[[i]][,j]
  yij0 <- yij[yij<0]
  yij1 <- yij[yij>0]

  num_not_na <- function(x) length(which(!is.na(x)))

  if (num_not_na(yij0) > 0) {
    hist(yij0, border='white', col=rgb(0,0,1,.5), fg='grey', 
         main=paste0("Y",i,": Col",j), prob=TRUE, ...)
    hist(yij1, border='white', col=rgb(1,0,0,.5), add=TRUE, prob=TRUE)
  } else {
    hist(yij1, border='white', col=rgb(1,0,0,.5), add=FALSE, prob=TRUE, 
         main=paste0("Y",i,": Col",j),fg='red',...)
  }
  #hist(yij, border='white', col=rgb(0,1,0,.1), add=TRUE, prob=TRUE)
  lines(density(yij,na.rm=TRUE), col='grey')
}

get_missing_count <- function(y) {
  #' @export
  sapply(y, function(yi)
    apply(yi, 2, function(col) sum(col == -Inf | is.na(col)))
  )
}

get_missing_prop <- function(y) {
  #' @export
  sapply(y, function(yi)
    apply(yi, 2, function(col) mean(col == -Inf | is.na(col)))
  )
}
 
get_mus_est <- function(y) {
  #' @export
  I <- length(y)
  J <- ncol(y[[1]])

  mus0_est <- matrix(0, I, J)
  mus1_est <- matrix(0, I, J)

  for (i in 1:I) for (j in 1:J) {
    mus0_est[i,j] <- mean(y[[i]][y[[i]][,j]<0,j], na.rm=T)
    mus1_est[i,j] <- mean(y[[i]][y[[i]][,j]>0,j], na.rm=T)
  }

  list(mus0=mus0_est, mus1=mus1_est)
}


plot_simdat <- function(dat,i,j,...) {
  #' @export
  lin <- dat$Z[j, dat$lam[[i]]]
  hist(dat$y[[i]][lin==0,j], border='white', col=rgb(0,0,1,.5), ...)
  hist(dat$y[[i]][lin==1,j], border='white', col=rgb(1,0,0,.5), add=TRUE, ...)
}


