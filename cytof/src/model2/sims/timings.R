N = c(100, 1000, 10000)
K = c(2, 4, 6, 8, 10)
I = 3

timings <- matrix(c(72, 85, 102, 111, 109,
                    576, 650, 793, 785, 933,
                    4340, 5268, 5946, 7073, 7830),
                  nrow=length(N), ncol=length(K), byrow=TRUE)
log_timings <- log(timings)

Z <- log_timings
#X <- timings

plot(Z[1,],  type='b', lwd=3, col=2, xaxt='n', ylab='seconds',
     ylim=range(Z,na.rm=TRUE))
lines(Z[2,], type='b', lwd=3, col=3)
lines(Z[3,], type='b', lwd=3, col=4)
axis(1, at=1:length(K), label=K)
legend("topright", leg=paste0("N=",N), col=2:4, lwd=3)

log_n <- rep(log(N), length(K))
log_k <- rep(log(K), each=length(N))
log_time <- c(log_timings)
plot(log_n, log_time, xlab='log(N)', ylab='log(seconds)')

mod <- lm(log_time ~ log_n + log_k)
sx <- seq(0,10,l=100)
lines(sx, mod$coef[1] + mod$coef[2]*sx + mod$coef[3]*log(2))
lines(sx, mod$coef[1] + mod$coef[2]*sx + mod$coef[3]*log(4))
lines(sx, mod$coef[1] + mod$coef[2]*sx + mod$coef[3]*log(6))
lines(sx, mod$coef[1] + mod$coef[2]*sx + mod$coef[3]*log(8))
lines(sx, mod$coef[1] + mod$coef[2]*sx + mod$coef[3]*log(10))

log_timings[1,] / log(N[1])
log_timings[2,] / log(N[2])
log_timings[3,] / log(N[3])

approx_sim_time <- function(N, K, its=1000, thin=1, unit='s') {
  log_time_per_1000_its = mod$coef[1] + mod$coef[2]*log(N) + mod$coef[3]*log(K)
  time_secs = as.numeric(exp(log_time_per_1000_its) / 1000 * its * thin)

  if (unit=='m') time_secs / 60 else if(unit=='h') time_secs/60/60 else time_secs
}

approx_sim_time(N=50000, K=5, its=1200, thin=5, unit='h')
