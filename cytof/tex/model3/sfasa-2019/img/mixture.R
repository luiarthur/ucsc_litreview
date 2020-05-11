# mixture.R
set.seed(42)

N = 1000
m0 = c(.5, 1, 1.5) * -1
m1 = c(.5, 1, 1.5)
s0 = runif(3, 0, 1)
s1 = runif(3, 0, 1)

x0 = rnorm(N, m0, s0)
x1 = rnorm(N, m1, s1)

den.x0 = density(x0)
den.x1 = density(x1)
h = max(den.x0$y, den.x1$y) * 1.2

pdf('mixture.pdf')
plot(den.x0, lwd=3, xlim=range(x0,x1), ylim=c(0,h), col='blue',
     fg='grey', cex.axis=1.5, cex.lab=1.5, main='', xlab='y')
lines(den.x1, lwd=3, col='red')
abline(v=0, lty=2)
legend("topleft", legend=c(expression(y~"~"~F[0]),expression(y~"~"~F[1])),
       col=c('blue', 'red'), lwd=3, cex=2, bty='n')
dev.off()
