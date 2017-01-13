# load rcommon
require('devtools')
if ( !("rcommon" %in% installed.packages()) ) {
  devtools::install_github('luiarthur/rcommon')
}
library(rcommon)

source("gendata.R")
source("plotPurity.R")
"%btwn%" <- function(elem, rng) rng[1] <= elem && elem <=rng[2]
library(Rcpp)
sourceCpp("purity3.cpp")

dat <- genData(phi_mean=0, phi_var=3, mu=.8, sig2=.1,
               meanN0=30, minM=0, maxM=3, c=.5,
               w2=.01, set_v=c(.1,.5,.9), numLoci=100)

obs <- dat$obs
param <- dat$param

# To do: See where the performance bottlenecks are in the cpp version
system.time(out <- fit(obs$n1, obs$N1, obs$N0, obs$M,
            m_phi=0, s2_phi=100,  #Normal
            a_sig=2, b_sig=2, #IG
            a_mu=1, b_mu=1, cs_mu=.3, #Beta
            a_m=2,b_m=2, cs_m=1, #Normal
            #a_w=2,b_w=.01, #IG this is a very flat prior for w2
            a_w=200,b_w=2, #IG basically fixing w2
            alpha=.1, a_v=1, b_v=1, cs_v=.4,
            B=2000,burn=10000,printEvery=1000))

# plot
plotPurity(out,dat)

