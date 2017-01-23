set.seed(1)
require('devtools')
if ( !("rcommon" %in% installed.packages()) ) {
  devtools::install_github('luiarthur/rcommon')
}
library(rcommon)

source("gendata.R")
source("plotPurity.R")
library(Rcpp)
sourceCpp("purity3.cpp")

library(doMC)
registerDoMC(8)

sim <- function(mu) {

  dat <- genData(phi_mean=3, phi_var=3, mu=mu, sig2=.1,
                 meanN0=30, minM=1.5, maxM=2.5, c=.5,
                 w2=.001, set_v=c(.1,.5,.9), numLoci=100)

  obs <- dat$obs
  param <- dat$param

  mod <- fit(obs$n1, obs$N1, obs$N0, obs$M,
                         m_phi=0, s2_phi=100, 
                         #a_sig=2, b_sig=2,
                         a_sig=2, b_sig=.1,
                         a_mu=1, b_mu=1, cs_mu=.05,
                         a_m=2,b_m=1, cs_m=1,
                         a_w=2001,b_w=2,
                         alpha=.1, a_v=1, b_v=1, cs_v=.4,
                         B=20000,burn=50000,printEvery=1000)

  list("mod"=mod, "dat"=dat)
}


system.time( l <- foreach(mu=(1:9)/10) %dopar% sim(mu) )

pdf("output/sim.pdf",w=13,h=7)
for (i in 1:length(l)) {
  plotPurity(l[[i]]$mod,l[[i]]$dat,rgba_level=.1)
}
dev.off()

