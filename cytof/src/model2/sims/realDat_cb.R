library(cytof2)
library(rcommon)

#transform_data <- function(dat, co) {
#  y <- as.matrix(t(log(t(dat) / co)))
#  ifelse(y == -Inf, NA, y)
#}
#
#PATH <- "../../../dat/cytof_data_lili/cytof_data_lili/"
#
#cbs <- read.expression.in.dir(paste0(PATH,"cb/"))
#cbs_cutoff <- read.cutoff.in.dir(paste0(PATH,"cb/"))
#
#J <- NCOL(cbs[[1]])
#I <- length(cbs)
#
#y <- lapply(as.list(1:I), function(i) transform_data(cbs[[i]], cbs_cutoff[[i]]))

### Read in y
load("cytof_cb.RData")
I <- length(y)
J <- ncol(y[[1]])

missing_count = sapply(y, function(yi)
  #apply(yi, 2, function(col) sum(col==-Inf))
  apply(yi, 2, function(col) sum(is.na(col)))
)

set.seed(1)

plot.histModel2(y, xlim=c(-6,6))
for (i in 1:I) {
  my.image(y[[i]], mn=-3, mx=3, col=blueToRed(), addLegend=TRUE, 
           main=paste0("Data: y", i), ylab="N", xlab="", xaxt="n", f=label_markers)
}


truth = list(K=10)
system.time(out <- cytof_fix_K_fit(y, truth=truth, B=200, burn=100, thin=5))

### Loglike
ll <- sapply(out, function(o) o$ll)
plot(ll <- sapply(out, function(o) o$ll), type='l',
     main='log-likelihood', xlab='mcmc iteration', ylab='log-likelihood')


### Z
Z <- lapply(out, function(o) o$Z)
Z_mean <- matApply(Z, mean)
Z_sd <- matApply(Z, sd)
my.image(Z_sd, main="Z: posterior sd")
my.image(Z_mean, main="Z: posterior mean")

save.image()
