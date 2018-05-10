greys = function(n=10) {
  #' @export
  rev(grey(seq(0,1,len=n)))
} 

#' Plot y and Z together
#' @param fy function to execute after making y image
#' @param fZ function to execute after making Z image
#' @export
yZ_inspect = function(out, y, zlim, i, thresh=0.7, 
                      col=list(blueToRed(), greys(10))[[1]],
                      prop_lower_panel=.3, is.postpred=FALSE,
                      decimals_W=1, na.color='transparent',
                      fy=function(lami) {
                        #abline(h=cumsum(table(lami))+.5, lwd=2)
                        #abline(h=cumsum(table(lami))+.5, lwd=1, col='white', lty=2)
                        #axis(4, at=cumsum(table(lami))+.5, col=NA, col.ticks=1, cex.axis=.0001)
                        abline(h=cumsum(table(lami))+.5, lwd=3, col='yellow', lty=1)
                        axis(4, at=cumsum(table(lami))+.5, col=NA, col.ticks=1, cex.axis=.0001)
                      },
                      fZ=function(Z) abline(v=1:NCOL(Z)+.5, h=1:NROW(Z)+.5, col='grey')) {
  idx_best = estimate_ZWi_index(out, i)
  Zi = out[[idx_best]]$Z
  Wi = out[[idx_best]]$W[i,]
  lami = out[[idx_best]]$lam[[i]]
  yZ(y[[i]], Zi, Wi, lami, zlim, using_zero_index=TRUE,
     thresh=thresh, col=col, prop_lower_panel=prop_lower_panel, 
     decimals_W=decimals_W, fy=fy, fZ=fZ, na.color=na.color)
}

