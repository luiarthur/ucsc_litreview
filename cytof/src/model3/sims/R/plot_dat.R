#' @export
plot_dat <- function(y, i, j, col='steelblue', nclass=20, main=paste0("Y",i,": Col",j), border='transparent', lwd=2, fg='grey', bty='n', ...) {
  yij = y[[i]][,j]
  #hist(yij, col=col, fg='grey', border=border, prob=TRUE,
  #     main=main, nclass=nclass, ...)
  plot(density(yij), col=col, main=main, lwd=lwd, bty=bty, fg=fg, ...)
  abline(v=0, lty=2, col='grey')
}
