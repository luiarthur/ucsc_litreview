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

yZ = function(yi, Zi, Wi, cell_types_i, zlim=c(-4,4),
              using_zero_index=TRUE, na.color='transparent',
              thresh=0.8, col=list(blueToRed(), greys(10))[[1]],
              prop_lower_panel=.3, decimals_W=1,
              fy=function(lami) {
                abline(h=cumsum(table(lami))+.5, lwd=3, col='yellow', lty=1)
                #axis(4, at=cumsum(table(lami))+.5, col=NA, col.ticks=1, cex.axis=.0001)
              },
              fZ=function(Z) abline(v=1:NCOL(Z)+.5, h=1:NROW(Z)+.5, col='grey'),
              cex.y.ylab=1,
              cex.y.yaxs=1,
              cex.y.leg=1,
              cex.y.xaxs=1,
              cex.z.bottom=1,
              cex.z.left=.8,
              cex.z.right=.8,
              cex.z.lab=1, useRaster=FALSE) {
  #' @export
  J = NCOL(yi)

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
           zlim=zlim, na.color=na.color,
           ylab='cells', xlab='', col=col, xaxt='n',
           cex.lab=cex.y.ylab, cex.axis=cex.y.yaxs, useRaster=useRaster)
  axis(1, at=1:J, labels=marker_names, las=2, fg='grey', cex.axis=cex.y.xaxs)
  fy(lami)
  color.bar(col, zlim, cex=cex.y.leg)


  my.image(tZ_common[ord,],
           xlab='markers', ylab='cell-types', axes=F, cex.lab=cex.z.lab)
  axis(4, at=1:K_trunc, label=perc[ord], las=2, fg='grey', cex.axis=cex.z.right)
  axis(2, at=1:K_trunc, label=common_cell_types[ord], las=2, fg='grey',
       cex.axis=cex.z.left)
  axis(1, at=1:J, label=1:J, las=2, fg='grey', cex.axis=cex.z.bottom)
  fZ(tZ_common)
  ### Enf of plot the stuff ###


  ### Restore Plot Settings ###
  par(mfrow=c(1,1),mar=c(5,4,4,2)+.1)
}
