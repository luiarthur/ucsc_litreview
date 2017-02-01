include("Purity.jl")

using RCall
R"library(rcommon)";
R"source('../../model3/plotPurity.R')";

R"""
set.seed(1)
source("../../model3/gendata.R")
dat <- genData(phi_mean=0, phi_var=.1, mu=.8, sig2=.1,
               meanN0=30, minM=1.5, maxM=2.5, 
               w2=.01, set_v=c(.1,.5,.9), v_sd=.03, numLoci=100)

obs <- dat$obs
param <- dat$param

n1 <- obs$n1
N1 <- obs$N1
N0 <- obs$N0
M <- obs$M
""";

@rget n1 N1 N0 M
n1 = Vector{Int}(n1)
N1 = Vector{Int}(N1)
N0 = Vector{Int}(N0)


@time out = Purity.fit(n1,N1,N0,M,2000,10000, s2_phi=1.,
                       cs_m=1E-3,cs_mu=5E-1,cs_v=2.0,
                       printFreq=1000);

v = hcat(map(o->o.v, out)...)
phi = hcat(map(o->o.phi,out)...)
m = hcat(map(o->o.m,out)...)
mu = map(o->o.mu, out)
sig2 = map(o->o.sig2, out)
w2 = map(o->o.w2, out)

R"pdf('../../model3/output/multivariate.pdf',w=13,h=8)"
R"out <- list(v=$v,phi=$phi,m=$m,mu=$mu,sig2=$sig2,w2=$w2)";
R"plotPurity(out,dat)";
R"dev.off()"

#=
include("test.jl")
=#
