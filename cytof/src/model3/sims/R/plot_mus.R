library(rcommon)

get_mus = function(out, a=.05) {
  mus_0 = sapply(out, function(o) o$mus_0)
  mus_1 = sapply(out, function(o) o$mus_1)
  mus = rbind(mus_0, mus_1)
  ci_mus = apply(mus, 1, quantile, a/2, 1-a/2)
  L0 = NROW(mus_0)
  L1 = NROW(mus_1)

  list(mus=mus, ci_mus=ci_mus, L0=L0, L1=L1)
}

plot_mus = function(out, a=.05, col=rgb(0,0,1,.5), ...) {
  B = length(out)
  mus_stats = get_mus(out, a)
  mus = mus_stats$mus
  ci = mus_stats$ci_mus 
  plot(rowMeans(mus), col=col, pch=20, cex=1.5, ylim=range(ci), ...)
  abline(h=0, lty=2, col='grey')
  add.errbar(t(ci_mus), col='grey')
}
