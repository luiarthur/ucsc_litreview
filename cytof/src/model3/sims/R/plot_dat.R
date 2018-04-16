plot_dat <- function(y, i, j, col=rgb(0,0,1,.3), nclass=20, main=paste0("Y",i,": Col",j), ...) {
  #' @export
  yij <- y[[i]][,j]
  hist(yij, col=col, fg='grey', border='transparent', prob=TRUE,
       main=main, nclass=nclass, ...)
  abline(v=0, lwd=2)
}
