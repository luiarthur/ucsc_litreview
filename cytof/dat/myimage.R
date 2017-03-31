my.image <- function(Z,col=grey(seq(0,1,len=12)),fg='grey', 
                     f=function() for(i in 1:1) break,...) {
  N <- nrow(Z)
  K <- ncol(Z)
  COL <- col
  FG <- fg
  #scaledZ <- (Z-min(Z))/ diff(range(Z))
  #image(1:K, 1:N, 1-t(scaledZ[N:1,]), fg='grey',...)
  image(1:K, 1:N, max(Z)-t(Z), fg=FG,col=COL, ...)
  f()
}

