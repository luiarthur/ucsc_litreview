mus_inspect = function(i, out, y) {
  #' @export
  J = ncol(y[[i]])

  mus0 = lapply(out, function(o) matrix(c(o$mus[,,1]), ncol=J))
  mus1 = lapply(out, function(o) matrix(c(o$mus[,,2]), ncol=J))
  m0 = matApply(mus0, mean)
  m1 = matApply(mus1, mean)

  v = c(m0[i,], m1[i,])
  label = rep(1:J, 2)
  plot(v, type='n', xlab='markers', ylab='mus', fg='grey',
       main=paste0('mu* for sample: ', i), xaxt='n')
  abline(v=(J+J+1)/2,h=0, lty=2, col='grey')
  #axis(1, at=1:length(v), label=label)
  text(1:length(v), v, label=label, cex=.8)
}
