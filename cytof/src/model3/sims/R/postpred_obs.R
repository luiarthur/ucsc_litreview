library(cytof3)
library(rcommon)
load('checkpoint.rda')

post_missing_y = FALSE

if (post_missing_y) {
  B = length(out)

  locked$beta_0=TRUE
  locked$beta_1=TRUE
  #locked$mus_0=TRUE
  #locked$mus_1=TRUE
  #locked$sig2_0=TRUE
  #locked$sig2_1=TRUE
  #locked$s=TRUE
  #locked$eta_0=TRUE
  #locked$eta_1=TRUE
  locked$Z=TRUE
  locked$lam=TRUE
  locked$W=TRUE

  B_y = 200
  some = 20
  missing_idx = which(is.na(y[[1]]), arr.ind=TRUE)
  missing_idx_some = missing_idx[sample(1:prior$N[[1]], some),]
  state = last(out)
  y_miss = matrix(NA, B_y, some)

  for (b in 1:B_y) {
    cat('\rProgress: ', b, '/', B_y)
    new_out = fit_cytof_cpp(y, B=1, burn=1, prior=prior, locked=locked, show_timings=FALSE,
                            init=state, print_freq=0, normalize_loglike=TRUE)
    state = last(new_out)
    y_miss[b, ] = state$missing_y[[1]][missing_idx_some]
  }

  plotPosts(y_miss[,1:5])
}

#pdf('pp_obs.pdf')
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
#dev.off()

par(mfrow=c(4,2))
thresh = -0
y_preimpute = preimpute(y)
for (i in 1:I) for (j in 1:J) {
  yij = postpred_yij(out, i, j)

  pp_den = density(yij)
  dat_den = density(y_preimpute[[i]][,j])
  h = max(pp_den$y, dat_den$y)

  plot(pp_den, bty='n', col='blue', lwd=2, ylim=c(0,h), fg='grey',
       main=paste0('positive y: i=',i,', j=',j), xlim=c(-7,7))
  lines(dat_den, col='grey', lwd=2)
}
par(mfrow=c(1,1))

