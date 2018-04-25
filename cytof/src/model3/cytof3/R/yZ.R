reorder_lami = function(ord, lami, using_zero_index=TRUE) {
  ### Check for zero-based index
  if (using_zero_index) {
    lami = lami + 1
  } else {
    lami = lami
  }

  lami_new = rep(NA, length(lami))

  K = length(ord)
  for (k in 1:K) {
    lami_new[lami == ord[k]] = k
  }

  lami_new
}

yZ = function(yi, Zi, Wi, cell_types_i, dat_lim=c(-4,4),
              using_zero_index=TRUE,
              thresh=0.8, col=list(blueToRed(), greys(10))[[1]],
              prop_lower_panel=.3, decimals_W=1,
              fy=function(lami) {
                #abline(h=cumsum(table(lami))+.5, lwd=2)
                #axis(2, at=cumsum(table(lami))+.5, col=NA, col.ticks=1, cex.axis=.0001)
                axis(4, at=cumsum(table(lami))+.5, col=NA, col.ticks=1, cex.axis=.0001)
              },
              fZ=function(Z) abline(v=1:NCOL(Z)+.5, h=1:NROW(Z)+.5, col='grey')) {
  #' @export
  J = NCOL(yi)

  mn = dat_lim[1]
  mx = dat_lim[2]
  COL = col
  nticks = length(col) - 1

  ### Configure Plot settings ###
  nrow_panel = 10
  nrow_lower_panel = round(nrow_panel * prop_lower_panel)
  nrow_upper_panel = nrow_panel - nrow_lower_panel
  M = rbind(cbind(matrix(1,nrow_upper_panel,8), matrix(2,nrow_upper_panel,1)),
            cbind(matrix(3,nrow_lower_panel,8), matrix(4,nrow_lower_panel,1)))
  marker_names = colnames(yi)

  ### Common cell types ###
  #which(Wi > thresh)
  common_cell_types = {
    Wi_order = order(Wi, decreasing=T)
    cumsum_Wi = cumsum(Wi[Wi_order])
    k = min(which(cumsum_Wi > thresh))
    Wi_order[1:k]
  }

  perc = paste0(round(Wi[common_cell_types]*100, decimals_W), '%')
  K_trunc = length(common_cell_types)
  ord = order(Wi[common_cell_types], decreasing=TRUE)
  tZ_common = t(Zi[, common_cell_types])

  lami = reorder_lami(order(Wi, decreasing=TRUE), cell_types_i, using_zero_index)


  ### Plot the stuff ###
  layout(M)
  par(mar=c(5.1, 4, 2.1, 0)) # b, l, t, r

  my.image(yi[order(lami),],
           mn=dat_lim[1], mx=dat_lim[2],
           ylab='cells', xlab='', col=COL, xaxt='n')
  axis(1, at=1:J, labels=marker_names, las=2, fg='grey')
  fy(lami)
  color.bar(COL,mn,mx,nticks)


  my.image(tZ_common[ord,],
           xlab='markers', ylab='cell-types', axes=F)
  axis(4, at=1:K_trunc, label=perc[ord], las=2, fg='grey', cex.axis=.8)
  axis(2, at=1:K_trunc, label=common_cell_types[ord], las=2, fg='grey', cex.axis=.8)
  axis(1, at=1:J, label=1:J, las=2, fg='grey')
  fZ(tZ_common)
  ### Enf of plot the stuff ###


  ### Restore Plot Settings ###
  par(mfrow=c(1,1),mar=c(5,4,4,2)+.1)
}