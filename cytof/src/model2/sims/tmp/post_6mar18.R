library(cytof2)
OUTDIR = './'
load("sim_result.RData")
dat_lim = c(-7,7)
fileDest = function(name) paste0(OUTDIR, name)
I = length(y)
J = NCOL(y[[1]])

### Post pred ###
pp = postpred(out)
Y_pp = pp$y
for (i in 1:I) colnames(Y_pp[[i]]) = colnames(y[[i]])

### Plot Y by lambda ###
png(fileDest('Y%03dpostpred.png'))
yZ(Y_pp, pp$Z, pp$cell, dat_lim=c(0,3), i=0, th=.05, prop=.3, col=greys(8))
dev.off()

### Plot Postpred
pdf(fileDest('postpred.pdf'))
par(mfrow=c(4,2))
for (i in 1:I) for (j in 1:J) {
  plot_dat(Y_pp, i, j, xlim=dat_lim, xlab=paste0('marker ',j))
}
par(mfrow=c(1,1))
dev.off()
