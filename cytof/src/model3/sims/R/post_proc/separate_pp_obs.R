#!/usr/bin/env Rscript
library(rcommon)
library(cytof3)

set.seed(1)
SOME = 4


args = commandArgs(trailingOnly=TRUE)
OUTDIR = ifelse(length(args) == 0, '../../out/cb_locked_beta1_K20/', args[1])
y = readRDS('../../data/cytof_cb.rds')

miss_prop = get_missing_prop(y)

fileDest = function(filename) paste0(OUTDIR, filename)

out = unshrinkOut(readRDS(fileDest('out.rds')))
B = length(out)
prior = last(out)$prior

I = prior$I
N = prior$N
J = prior$J

pz0_missy = matrix(NA, I, J)
f = function(i,j,b) {
  lami = out[[b]]$lam[[i]] + 1
  lami = lami[which(is.na(y[[i]][,j]))]
  mean(out[[b]]$Z[j,lami] == 0)
}
for (i in 1:I) for (j in 1:J) {
  println(i,j)
  pz0_missy_ij = sapply(1:B, function(b) f(i,j,b))
  pz0_missy_ij_mean = mean(pz0_missy_ij)
  pz0_missy[i,j] = pz0_missy_ij_mean
}

### Density of positive data and posterior predictive ###

set.seed(4)
idx = which(pz0_missy > -Inf, arr.ind=T)
idx_min = which(pz0_missy == min(pz0_missy), arr.ind=TRUE)
idx_max = which(pz0_missy == max(pz0_missy), arr.ind=TRUE)[1,]

rec.find.idx = function(idx_some=matrix(1, SOME, 2)) {
  idx_some = idx[sample(NROW(idx), SOME-2), ]
  idx_some = rbind(idx_some, idx_min, idx_max)
  invalid = length(unique(idx_some[,1])) < I ||
            length(unique(idx_some[,2])) < SOME
  if (invalid) rec.find.idx(idx_some) else idx_some
}
idx_some = rec.find.idx()


apply(idx_some, 1, function(indices) {
  i = indices[1]
  j = indices[2]
  pdf(fileDest(paste0('pp_obs_i',i,'_j',j,'.pdf')))

  yij = postpred_yij_obs(out, i, j)

  pp_den = density(yij)
  dat_den = density(y[[i]][which(!is.na(y[[i]][,j])) ,j])
  h = max(pp_den$y, dat_den$y)

  xmag = 7
  plot(dat_den, bty='n', col='grey', lwd=2, ylim=c(0,h*1.3), fg='grey',
       #xlab=paste0('observed y  (sample ',i,', marker ',j,')'),
       xlab='observed y', cex.lab=1.4,
       xlim=c(-xmag,xmag) * 1.2, main='')
  lines(pp_den, col='blue', lwd=2)

  pz0 = paste0('posterior prob. of non-expression for missing y: ', 100*round(pz0_missy[i,j],2), '%')
  pm = paste0('proportion of data missing: ', 100*round(miss_prop[j,i],4), '%')

  x_pos = xmag * .1
  y_pos = h * 1.2
  text(x_pos, y_pos, pz0, cex=1.3)
  text(x_pos, h * 1.05, pm, cex=1.3)
  dev.off()
})


### Q hist (Histogram of P(Z=0) for missing y) ###
pdf(fileDest('pz0_missy.pdf'))
hist(pz0_missy, main='',
     xlab='histogram of missing y',
     col='grey', border='white', prob=FALSE)
dev.off()
