redToBlue <- function(n=12) {
  #' @export
  colorRampPalette(c('red','grey90','blue'))(n)
}

blueToRed <- function(n=12) {
  #' @export
  rev(redToBlue(n))
}

color.bar.horiz <- function(colorVec, mn, mx=-mn, nticks=length(colorVec)-1, 
                      ticks=seq(mn, mx, len=nticks), colGrids=10, title='',
                      digits=1) {
  #' @export
  scale = (length(colorVec)-1) / (mx-mn)

  plot(c(mn,mx), c(0,colGrids), type='n', bty='n', 
       xaxt='n', xlab='', yaxt='n', ylab='', main=title,fg='grey')
  axis(1, round(ticks,digits), las=1)
  for (i in 1:(length(colorVec)-1)) {
    x = (i-1)/scale + mn
    rect(xl=x, yb=0, xr=x+1/scale, yt=colGrids,
         col=colorVec[i], border=NA)
  }
}
#M = rbind(matrix(1,1,10),matrix(2,4,10))
#layout(M)
#color.bar.horiz(blueToRed(), -3, 3)


color.bar <- function(colorVec, mn, mx=-mn, nticks=length(colorVec)-1, digits=1,
                      ticks=seq(mn, mx, len=nticks), title='', colGrids=10) {
  #' @export

  scale = (length(colorVec)-1)/(mx-mn)

  plot(c(0,colGrids), c(mn,mx), type='n', bty='n', 
       xaxt='n', xlab='', yaxt='n', ylab='', main=title,fg='grey')
  axis(2, round(ticks,digits), las=1)
  for (i in 1:(length(colorVec)-1)) {
    y = (i-1)/scale + mn
    rect(0,y,colGrids,y+1/scale, col=colorVec[i], border=NA)
  }
}


my.image <- function(Z,col=grey(seq(1,0,len=12)),fg='grey', 
                     f=function(dat) stopifnot(TRUE),
                     truncate=TRUE,
                     rm0Cols=FALSE,
                     addLegend=FALSE,nticks=11,mn=0,mx=1,...) {
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


