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
  #' Adding a horizontal color bar
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
  #' Adding a vertical color bar
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

my.image <- function(Z, col=grey(seq(1,0,len=12)), na.color='transparent',
                     fg='grey', f=function(dat) stopifnot(TRUE),
                     truncate=TRUE,
                     rm0Cols=FALSE,
                     addLegend=FALSE,nticks=11,zlim=0:1,...) {
  #' Plotting an image with missing values
  #' @export

  if (rm0Cols) {
    Z <- Z[, which(colSums(Z) > 0)]
  }
  mn=zlim[1]
  mx=zlim[2]
  zstep=(mx - mn) / length(col)

  N = NROW(Z)
  K = NCOL(Z)
  COL = col
  FG = fg
  NTICKS = nticks
  #scaledZ <- (Z-min(Z))/ diff(range(Z))
  #image(1:K, 1:N, 1-t(scaledZ[N:1,]), fg='grey',...)

  if (addLegend) {
    layout(matrix(c(rep(1,9*10),rep(2,1*10)),10,10))
  }

  #image(1:K, 1:N, max(Z)-t(Z), fg=FG,col=COL, ...)
  #image(1:K, 1:N, mx-t(Z), fg=FG,col=COL, ...)


  if (truncate) {
    Z[which(Z >= mx)] = mx
    Z[which(Z <= mn)] = mn
    Z[which(is.na(Z))] = mx + zstep
  }
  image(1:K, 1:N, t(Z), fg=FG,col=c(COL,na.color), zlim=c(mn, mx + zstep), ...)
  f(Z)

  if (addLegend) {
    par(mar=c(5.1,1,4.1,1))
    color.bar(COL[-length(COL)],mn,mx,nticks)
    par(mfrow=c(1,1),mar=c(5.1,4.1,4.1,2.1))
  }

}
### TEST ###
#library(cytof3)
#y = readRDS('sims/data/cytof_cb.rds')
#ys = y[[1]][1:100,]
#na.color = 'black'
#my.image(ys, zlim=c(-3,3), col=blueToRed(), addL=TRUE, na.col='black')
#my.image.old(ys, mn=-3, mx=3, col=blueToRed(), addL=TRUE)

