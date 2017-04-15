# load rcommon
require('devtools')
if ( !("rcommon" %in% installed.packages()) ) {
  devtools::install_github('luiarthur/rcommon')
}
library(rcommon)

source("gendata.R")
source("plotPurity.R")

library(Rcpp)
sourceCpp("purity3.cpp")

#set.seed(1)
dat <- genData(phi_mean=0, phi_var=.1, mu=.8, sig2=.1,
               meanN0=30, minM=0, maxM=4, m_mean=2, m_sd=.5,
               w2=.01, set_v=c(.1,.5,.9), v_sd=.0, numLoci=200)

obs <- dat$obs
param <- dat$param

# To do: See where the performance bottlenecks are in the cpp version
system.time(out <- fit(obs$n1, obs$N1, obs$N0, obs$M,
            m_phi=0, s2_phi=1,  #Normal
            #a_sig=2, b_sig=.1, #IG
            a_sig=2, b_sig=1, #IG
            a_mu=1, b_mu=1, cs_mu=.3, #Beta
            a_m=2,b_m=1, cs_m=.7, #Gamma
            a_w=200,b_w=2, #IG basically fixing w2
            alpha=1, a_v=1, b_v=1, cs_v=1,
            B=2000,burn=20000,printEvery=1000))


# 2.78s: 100obs, bigHPElite, B=2000, burn=10000
pdf("output/datviz.pdf",w=13,h=7)
plotPurity(out,dat,rgba_l=.5)

par(mfrow=c(2,3))
plot(param$m, obs$M, xlab="m Truth", ylab="M Truth",pch=20,
     main="M Truth vs m Truth"); abline(0,1)
hyp_dat <- genData(phi_mean=0, phi_var=.1, mu=.8, sig2=.1,
               meanN0=30, minM=0, maxM=4, m_mean=2, m_sd=.001,
               w2=.01, set_v=c(.1,.5,.9), v_sd=.03, numLoci=100)
plot(hyp_dat$obs$N0, hyp_dat$obs$N1, xlab="N0", ylab="N1",pch=20,
     main="N1 vs N0 when m == 2")
plot(dat$obs$N0, dat$obs$N1, xlab="N0", ylab="N1",pch=20,
     main="N1 vs N0 when m <> 2")
par(mfrow=c(1,1))
dev.off()

### Scala:
library(rscala)

s <- scala(classpath="jar/purity-assembly-0.3.0.jar")

s %~% '
import purity.util._
import purity.data._
import purity.model
'

scalaSet(s, "n1", obs$n1)
scalaSet(s, "N1", obs$N1)
scalaSet(s, "N0", obs$N0)
scalaSet(s, "M",  obs$M)
s %~% 'val obs = new Obs(n1.map(_.toInt).toVector,
                         N1.map(_.toInt).toVector,
                         N0.map(_.toInt).toVector,
                         M.toVector)'

s %~% '
val prior = new model.Prior(mPhi=0,s2Phi=100,
                            aSig=2,bSig=.1,
                            aMu=1,bMu=1,csMu=.3,
                            aM=2,bM=1,csM=1,
                            aW=200,bW=2,alpha=.1,csV=.4)
val out = timer { model.fit(obs,prior,B=2000,burn=10000,printEvery=1000) }
'

out_scala <- list(mu= s %~% 'out.map(_.mu).toArray',
                  sig2= s %~% 'out.map(_.sig2).toArray',
                  w2= s %~% 'out.map(_.w2).toArray',
                  phi= t(s %~% 'out.map(_.phi.toArray).toArray'),
                  m= t(s %~% 'out.map(_.m.toArray).toArray'),
                  v= t(s %~% 'out.map(_.v.toArray).toArray'))

# plot
pdf("output/compare.pdf",w=13,h=7)
plotPurity(out,dat,rgba_l=.5)
plotPurity(out_scala, dat)
dev.off()
