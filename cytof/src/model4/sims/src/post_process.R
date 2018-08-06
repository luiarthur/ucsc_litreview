post_process = function(samps, N, J, K, L, is.simdat=FALSE) {
  I = length(N)

  samples = samps$mvSamples
  samples2 = samps$mvSamples2

  # TODO: reimplement cytof3 functions in cytof4
  # Plot log-likelihood
  ll.cols = get_param('logProb_y', samples)
  ll = rowSums(samples[, ll.cols]) / sum(N)
  plot(ll, type='o')

  Z.cols = get_param('Z0', samples)
  Z.post = samples[, Z.cols]
  Z.mean = matrix(colMeans(Z.post), J, K)
  cytof3::my.image(Z.mean, addL=T, col=cytof3::greys(11))

  mus.cols = get_param('mus', samples)
  mus.post = samples[, mus.cols]
  mus.mean = matrix(colMeans(mus.post), 2, L)
  plot(c(mus.mean[1,], mus.mean[2,]))
  abline(h=0, v=L+.5, lty=2, col='grey')

  y.cols = get_param('y', samples2)
  y.post = matrix(samples2[, y.cols], sum(N), J)
  hist(y.post[,4])
  cytof3::my.image(y.post, col=cytof3::blueToRed(7), addL=TRUE, zlim=c(-3,3))
  #cytof3::my.image(Reduce(rbind, dat$y), col=cytof3::blueToRed(7), addL=TRUE, zlim=c(-3,3), na.col='black')
}
