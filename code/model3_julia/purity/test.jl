include("Purity.jl")

using RCall
R"library(rcommon)";
R"source('../../model3/plotPurity.R')";

R"""
set.seed(1)
source("../../model3/gendata.R")
dat <- genData(phi_mean=0, phi_var=.1, mu=.8, sig2=.1,
               meanN0=30, minM=1.5, maxM=2.5, 
               w2=.01, set_v=c(.8), v_sd=0, numLoci=100)

obs <- dat$obs
param <- dat$param

n1 <- obs$n1
N1 <- obs$N1
N0 <- obs$N0
M <- obs$M

v_truth <- param$v
phi_truth <- param$phi
m_truth <- param$m
mu_truth <- param$mu
w2_truth <- param$w2
sig2_truth <- param$sig2
""";

@rget n1 N1 N0 M v_truth phi_truth m_truth mu_truth w2_truth sig2_truth
n1 = Vector{Int}(n1)
N1 = Vector{Int}(N1)
N0 = Vector{Int}(N0)


@time ll,out = Purity.fit(n1,N1,N0,M,50000,20000, s2_phi=1.,
                          cs_m=5E-4,cs_mu=.1,cs_v=1.9,
                          #cs_m=5E-4,cs_mu=1E-2,cs_v=2E-2,
                          printFreq=1000, 
                          truth=Purity.State([0.],phi_truth,m_truth,
                                             0.,w2_truth,sig2_truth));

v = hcat(map(o->o.v, out)...);
phi = hcat(map(o->o.phi,out)...);
m = hcat(map(o->o.m,out)...);
mu = map(o->o.mu, out);
sig2 = map(o->o.sig2, out);
w2 = map(o->o.w2, out);

R"pdf('../../model3/output/multivariate.pdf',w=13,h=8)"
R"out <- list(v=$v,phi=$phi,m=$m,mu=$mu,sig2=$sig2,w2=$w2)";
R"plotPurity(out,dat)";
R"plot(tail($ll,length($mu)),type='l',main='Log likelihood after burn-in',ylab='log likelihood')"
R"plot($ll,type='l',main='Log likelihood with burn-in',ylab='log likelihood')"
R"abline(v=length($ll)-length($mu),col='grey')"
R"dev.off()"


#=
include("test.jl")
=#
