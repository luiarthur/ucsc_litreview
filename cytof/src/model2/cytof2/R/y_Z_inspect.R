greys = function(n=10) {
  #' @export
  rev(grey(seq(0,1,len=n)))
} 

### TODO: build from yZ.R ###
y_Z_inspect = function(out, y, dat_lim, i=0, thresh=0.1, 
                       col=list(blueToRed(), greys(10))[[1]],
                       prop_lower_panel=.3, is.postpred=FALSE) {
  #' @export
  I = length(y)
  J = NCOL(y[[1]])

  mn = dat_lim[1]
  mx = dat_lim[2]
  COL = col
  nticks = length(col) - 1

  Z = lapply(out, function(o) o$Z)
  idx = estimate_Z(Z, returnIndex=TRUE)
  lam_est = out[[idx]]$lam
  Z_est = out[[idx]]$Z
  W_est = out[[idx]]$W
  last_out = last(out)

  ### NEW
  #M = rbind(matrix(1,1,12), matrix(2,8,12), matrix(3, 3, 12))
  nrow_panel = 10
  nrow_lower_panel = round(nrow_panel * prop_lower_panel)
  nrow_upper_panel = nrow_panel - nrow_lower_panel
  M = rbind(cbind(matrix(1,nrow_upper_panel,8), matrix(2,nrow_upper_panel,1)),
            cbind(matrix(3,nrow_lower_panel,8), matrix(4,nrow_lower_panel,1)))
  #print(M)
  #par(mar=c(5, 4, 4, 0)) # b, l, t, r
  #par(mar=c(2, 3, 1, 3)) # b, l, t, r
  marker_names = colnames(y[[1]])

  doit = function(i) {
    layout(M)
    par(mar=c(5.1, 4, 2.1, 0))


    ### Add Legend  #####
    #color.bar.horiz(COL,mn,mx,nticks)
    #par(mar=c(5.1, 3, 1, 3)) # b, l, t, r

    if (is.postpred) {
      Yi = y[[i]]
      lami_ord = 1:NROW(Yi)
    } else {
      Yi = matrix(last_out$missing_y[[i]], ncol=J)
      lami_ord = order(lam_est[[i]])
    }
    my.image(Yi[lami_ord,],
             mn=dat_lim[1], mx=dat_lim[2],
             ylab='obs', xlab='', col=COL, xaxt='n')
    axis(1, at=1:J, labels=marker_names, las=2, fg='grey')
    color.bar(COL,mn,mx,nticks)

    cell_types = which(W_est[i,] > thresh)
    my.image(t(Z_est[, cell_types]), xlab='markers', ylab='cell-types', axes=F)
    perc = paste0(round(W_est[i,cell_types],2) * 100, '%')
    axis(4, at=1:length(cell_types), label=perc, las=2, fg='grey', cex.axis=.8)
    axis(2, at=1:length(cell_types), label=cell_types, las=2, fg='grey', cex.axis=.8)
    axis(1, at=1:J, label=1:J, las=2, fg='grey')
  }

  if (i == 0) {
    for (ii in 1:I) doit(ii)
  } else doit(i)

  ### Restore Figures Settings ###
  par(mfrow=c(1,1),mar=c(5,4,4,2)+.1)
}
