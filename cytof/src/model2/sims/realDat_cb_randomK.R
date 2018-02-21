library(cytof2)
library(rcommon)
set.seed(1)

args = commandArgs(trailingOnly=TRUE)
if (length(args) < 6) {
  stop('usage: Rscript realDat_cb.R DATA_DIR MCMC_K OUTDIR B BURN THIN')
}

### GLOBAL VARS ###
DATA_DIR = args[1]
MCMC_K <- as.integer(args[2])
OUTDIR <- args[3]
B <- as.integer(args[4])
BURN <- as.integer(args[5])
THIN <- as.integer(args[6])
PROP = as.numeric(args[7])
WARMUP = as.integer(args[8])
NCORES = as.integer(args[9])
RANDOM_K = (PROP > 0)
dat_lim = c(-7,7)

fileDest = function(name) paste0(OUTDIR, name)

### Read in CB Data 
system(paste0('mkdir -p ', OUTDIR))
load(DATA_DIR) # dat/cytof_cb.RData
system(paste0('cp realDat_cb_randomK.R ', fileDest('src.R')))

### Plotting Data ###
pdf(fileDest('data.pdf'))
### Prob Missing
sink(fileDest('missing_count.txt'))
cat("Missing count:\n")
print(get_missing_count(y))
sink()

missing_prop = get_missing_prop(y)
sink(fileDest('missing_prop.txt'))
cat("Missing proportion:\n")
print(missing_prop)
sink()

### Estimate of mu*
par(mfrow=c(4,2))
I = length(y)
J = NCOL(y[[1]])
for (i in 1:I) for (j in 1:J) {
  plot_dat(y, i, j, xlim=dat_lim, xlab=paste0('marker ',j))
  #Sys.sleep(1)
}
par(mfrow=c(1,1))

### Distribution of Data
plot.histModel2(y, xlim=dat_lim, main='Distribution of Data', quant=c(.05,.95))
for (i in 1:I) {
  plot.histModel2(list(y[[i]]), xlim=dat_lim, main='Distribution of Data')
}
dev.off()

png(fileDest('rawDat%03d.png'))
for (i in 1:I) {
  my.image(y[[i]], mn=dat_lim[1], mx=dat_lim[2], col=blueToRed(), addLegend=TRUE,
           main=paste0('y',i), xlab='j', ylab='n')
}
dev.off()

#### End of Plotting Data ###
init = NULL
truth = NULL

#prior = list(cs_v=4, cs_h=3, d_w=1/MCMC_K, a_beta=200000, b_beta=10000,
#             K_min=1, K_max=10, a_K=2)

bdat.prior = get_beta_new(y=c(-3, c0 <- -2, -1), p_tar=c(.1, .6, .01))
prior = list(cs_v=4, cs_h=3, d_w=1,
             m_betaBar=bdat.prior['b0'], s2_betaBar=.0001, s2_beta0=.0001, #b0
             a_beta=bdat.prior['b1'] * 100, b_beta=100, # b1
             c0=c0, a_x=bdat.prior['x'] * 100, b_x=100, # x
             K_min=1, K_max=16, a_K=2)

if (RANDOM_K) {
  init$K = MCMC_K
} else {
  truth$K = MCMC_K
  truth$beta_all = TRUE
  truth$beta_1 = rep(bdat.prior['b1'], J)
  truth$beta_0 = matrix(bdat.prior['b0'], I, J)
  truth$x =  rep(bdat.prior['x'], J)
}

print("Start MCMC")

sim_time <- system.time(
  out <- cytof_fix_K_fit(y, init=init, prior=prior, B=B, burn=BURN, thin=THIN,
                         warmup=WARMUP, thin_K=1, ncores=NCORES, truth=truth,
                         prop_for_training=PROP, print=1)
)
sink(fileDest('simtime.txt')); print(sim_time); sink()
save(y, out, file=fileDest('sim_result.RData'))

plot_cytof_posterior(out, y, outdir=OUTDIR, dat_lim=dat_lim, prior=prior)

### Plot Y by lambda ###
png(fileDest('Y%03dsortedByLambda.png'))
Z = lapply(out, function(o) o$Z)
idx = estimate_Z(Z, returnIndex=TRUE)
lam_est = out[[idx]]$lam
Z_est = out[[idx]]$Z
W_est = out[[idx]]$W
last_out = last(out)
layout(matrix(c(1,1,1,1,1,1,2,2,2), 3, 3, byrow = TRUE))
marker_names = colnames(y[[1]])
thresh = .1
for (i in 1:I) {
  lami_ord = order(lam_est[[i]])
  #my.image(y[[i]][lami_ord,],
  my.image(matrix(last_out$missing_y[[i]],ncol=J)[lami_ord,],
           mn=dat_lim[1], mx=dat_lim[2],
           ylab='obs', xlab='', col=blueToRed(), xaxt='n')#,addL=TRUE)
  ### TODO #####
  #  Add legend
  ##############
  axis(1, at=1:J, labels=marker_names, las=2, fg='grey')
  cell_types = which(W_est[i,] > thresh)
  my.image(t(Z_est[, cell_types]), xlab='markers', ylab='cell-types', axes=F)
  perc = paste0(round(W_est[i,cell_types],2) * 100, '%')
  axis(2, at=1:length(cell_types), label=perc, las=2, fg='grey', cex.axis=.8)
  axis(1, at=1:J, label=1:J, las=2, fg='grey')
}
par(mfrow=c(1,1))
dev.off()


### Kmeans ###
#yi = ifelse(is.na(y[[i]]), -3, y[[i]])
#ks = 2:16
#costs = double(length(ks))
#for (k in ks) {
#  print(k)
#  km = kmeans(yi, k)
#  costs[k-1] = km$tot.within
#}
#plot(costs, type='b')


### INSPECT MUS ###
mus0 = lapply(out, function(o) matrix(c(o$mus[,,1]), ncol=J))
mus1 = lapply(out, function(o) matrix(c(o$mus[,,2]), ncol=J))
m0 = matApply(mus0, mean)
m1 = matApply(mus1, mean)

pdf(fileDest('mus_inspect.pdf'))
for (i in 1:I) {
  v = c(m0[i,], m1[i,])
  plot(v, type='n', xlab='markers', ylab='mus', main=paste0('mus for sample: ', i))
  abline(h=0, lty=2, col='grey')
  text(1:length(v), v, label=rep(1:J,2), cex=.8)
}
dev.off()

