pdf(fileDest('Z_best_byW.pdf'))
par(mfrow=c(I,1))
for (i in 1:I) {
  mar = par("mar")
  par(mar=c(5.1, 4.1, 4.1, 4.1))
  Zi = out[[idx_best[i]]]$Z
  Wi = out[[idx_best[i]]]$W[i,]
  ord = order(Wi, decreasing=TRUE)
  my.image(t(Zi[,ord]), xlab='markers', ylab='cell-types', xaxt='n', yaxt='n')
  axis(1, at=1:J, fg='grey', las=2, cex.axis=.8)
  axis(2, at=1:length(ord), label=ord ,fg='grey', las=2, cex.axis=1)
  axis(4, at=1:length(ord), paste0(round(Wi[ord]*100, 1),'%') ,fg='grey', las=2, cex.axis=1)
  abline(h=1:length(ord)+.5, v=1:J+.5, col='grey')
  par(mar=mar)
}
par(mfrow=c(1,1))
dev.off()


