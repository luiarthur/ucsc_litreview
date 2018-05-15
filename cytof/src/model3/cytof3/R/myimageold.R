my.image.old <- function(Z,col=grey(seq(1,0,len=12)),fg='grey', 
                         f=function(dat) stopifnot(TRUE),
                         truncate=TRUE,
                         rm0Cols=FALSE,
                         addLegend=FALSE,nticks=11,mn=0,mx=1,...) {
  #' Old way of plotting images (deprecated)
  #' @export

  if (rm0Cols) {
    Z <- Z[, which(colSums(Z) > 0)]
  }

  N <- NROW(Z)
  K <- NCOL(Z)
  COL <- col
  FG <- fg
  NTICKS <- nticks
  #scaledZ <- (Z-min(Z))/ diff(range(Z))
  #image(1:K, 1:N, 1-t(scaledZ[N:1,]), fg='grey',...)

  if (addLegend) {
    layout(matrix(c(rep(1,9*10),rep(2,1*10)),10,10))
  }

  #image(1:K, 1:N, max(Z)-t(Z), fg=FG,col=COL, ...)
  #image(1:K, 1:N, mx-t(Z), fg=FG,col=COL, ...)

  if (truncate) {
    Z[which(Z >= mx)] <- mx
    Z[which(Z <= mn)] <- mn
  }
  image(1:K, 1:N, t(Z), fg=FG,col=COL, zlim=c(mn, mx), ...)
  f(Z)

  if (addLegend) {
    par(mar=c(5.1,1,4.1,1))
    color.bar(COL,mn,mx,nticks)
    par(mfrow=c(1,1),mar=c(5.1,4.1,4.1,2.1))
  }

}


