yZ = function(y, Z, cell_types, dat_lim,
              i=0, thresh=0.1, col=greys(10), prop_lower_panel=.3) {
  #' @export
  I = length(y)
  J = NCOL(y[[1]])

  mn = dat_lim[1]
  mx = dat_lim[2]
  COL = col
  nticks = length(col) - 1

  ### NEW
  nrow_panel = 10
  nrow_lower_panel = round(nrow_panel * prop_lower_panel)
  nrow_upper_panel = nrow_panel - nrow_lower_panel
  M = rbind(cbind(matrix(1,nrow_upper_panel,8), matrix(2,nrow_upper_panel,1)),
            cbind(matrix(3,nrow_lower_panel,8), matrix(4,nrow_lower_panel,1)))
  marker_names = colnames(y[[1]])

  doit = function(i) {
    layout(M)
    par(mar=c(5.1, 4, 2.1, 0))

    ### Add Legend  #####
    #color.bar.horiz(COL,mn,mx,nticks)
    #par(mar=c(5.1, 3, 1, 3)) # b, l, t, r

    my.image(y[[i]],
             mn=dat_lim[1], mx=dat_lim[2],
             ylab='obs', xlab='', col=COL, xaxt='n')
    axis(1, at=1:J, labels=marker_names, las=2, fg='grey')
    color.bar(COL,mn,mx,nticks)

    cell_type_counts= tally(cell_types[[i]])
    Wi = cell_type_counts / sum(cell_type_counts)
    common_cell_types = which(Wi > thresh)
    my.image(t(Z[, common_cell_types]),
             xlab='markers', ylab='cell-types', axes=F)
    perc = paste0(round(Wi[common_cell_types],2) * 100, '%')
    axis(4, at=1:length(common_cell_types), label=perc, las=2, fg='grey', cex.axis=.8)
    axis(2, at=1:length(common_cell_types), label=common_cell_types, las=2, fg='grey', cex.axis=.8)
    axis(1, at=1:J, label=1:J, las=2, fg='grey')
  }

  if (i == 0) {
    for (ii in 1:I) doit(ii)
  } else doit(i)

  ### Restore Figures Settings ###
  par(mfrow=c(1,1),mar=c(5,4,4,2)+.1)
}
