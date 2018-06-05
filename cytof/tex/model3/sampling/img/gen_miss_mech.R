library(cytof3)
y0 = c(-6, -2, -1)
p0 = c(.1, .99, .01)
mmp = miss_mech_params(p=p0, y=y0)
yy = seq(-7, 7, l=100)
pm = prob_miss(yy, b0=mmp['b0'], b1=mmp['b1'], c0=mmp['c0'], c1=mmp['c1'])

pdf('prob_miss_example.pdf')
plot(yy, pm, type='l', ylab='probability of missing', xlab='y', 
     fg='grey', lwd=2, ylim=0:1, cex.axis=1.4, cex.lab=1.4)
abline(v=y0, lty=2, col='grey')
points(y0, p0, pch=20, cex=2, col='steelblue')
dev.off()
