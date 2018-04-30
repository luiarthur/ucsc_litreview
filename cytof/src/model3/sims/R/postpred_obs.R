library(cytof3)
load('checkpoint.rda')

#B = length(out)
#gam = as.list(1:B)
#
#locked$beta_0=TRUE
#locked$beta_1=TRUE
##locked$mus_0=TRUE
##locked$mus_1=TRUE
##locked$sig2_0=TRUE
##locked$sig2_1=TRUE
##locked$s=TRUE
##locked$eta_0=TRUE
##locked$eta_1=TRUE
#locked$Z=TRUE
#locked$lam=TRUE
#locked$W=TRUE

#state = last(out)
#B_gam = 200
#pp_obs = lapply(as.list(1:prior$I), function(i) matrix(0, prior$N[[i]], prior$J))
#pp_obs_mean = pp_obs
#
#for (b in 1:B_gam) {
#  cat('\rProgress: ', b, '/', B_gam)
#  if (b > 1) {
#    state = new_out
#  }
#  new_out = fit_cytof_cpp(y, B=1, burn=1, prior=prior, locked=locked, show_timings=FALSE,
#                          init=state, print_freq=0, normalize_loglike=TRUE)
#  new_out = last(new_out)
#
#  for (i in 1:I) {
#    for (j in 1:J) {
#      pp_obs[[i]][,j] = pp_rnorm(prior$N[[i]], )
#      pp_obs[[i]][is.na(y[[i]][,j]),j] = NA
#    }
#    pp_obs_mean[[i]] = pp_obs_mean[[i]] + pp_obs[[i]] / B
#  }
#}

#par(mfrow=c(4,2))
#for (i in 1:I) for (j in 1:J) {
#  yij = postpred_yij(out, i, j)
#  yij_up = sample(yij, prior$N[[i]], replace=TRUE)
#  yij_up_hist = hist(yij_up, plot=FALSE)
#  yij_hist = hist(y[[i]][,j], plot=FALSE)
#  h = max(yij_up_hist$count, yij_hist$count) * 1.2
#  hist(yij_up, ylim=c(0,h), col=rgb(0,0,1,.3), border='transparent', 
#       main=paste0('observed y: i=',i,', j=',j), xlab='yij', xlim=c(-10,10))
#  hist(y[[i]][,j], add=TRUE, col=rgb(0,0,0,.3), border='transparent')
#}
#par(mfrow=c(1,1))

pdf('pp_obs.pdf')
par(mfrow=c(4,2))
thresh = -0
for (i in 1:I) for (j in 1:J) {
  yij = postpred_yij(out, i, j)

  pp_den = density(yij[yij > thresh])
  dat_den = density(y[[i]][which(y[[i]][,j] > thresh) ,j])
  h = max(pp_den$y, dat_den$y)

  plot(pp_den, bty='n', col='blue', lwd=2, ylim=c(0,h), fg='grey',
       main=paste0('positive y: i=',i,', j=',j), xlim=c(thresh,7))
  lines(dat_den, col='grey', lwd=2)
}
par(mfrow=c(1,1))
dev.off()
