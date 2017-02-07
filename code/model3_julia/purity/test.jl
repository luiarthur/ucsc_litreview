include("Purity.jl")

using RCall
R"library(rcommon)";
R"source('../../model3/plotPurity.R')";

R"""
set.seed(1)
source("../../model3/gendata.R")
dat <- genData(phi_mean=0, phi_var=.1, mu=.8, sig2=.1,
               meanN0=30, minM=1.5, maxM=2.5, m_sd=3,
               w2=.0001, set_v=c(.1,.5,.9), v_sd=0, numLoci=200)

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
#plot(M,N1/N0)
""";

@rget n1 N1 N0 M v_truth phi_truth m_truth mu_truth w2_truth sig2_truth
n1 = Vector{Int}(n1)
N1 = Vector{Int}(N1)
N0 = Vector{Int}(N0)


@time ll_truth, = Purity.fit(n1,N1,N0,M,2,0, s2_phi=1.,
                             cs_m=1.,cs_mu=.01,cs_v=.9,
                             a_mu=400., b_mu=100.,
                             printFreq=1000, 
                             truth=Purity.State(v_truth,phi_truth,m_truth,
                                                mu_truth,w2_truth,sig2_truth));

@time ll,out = Purity.fit(n1,N1,N0,M,2000,10000, s2_phi=1.,
                          #cs_m=.000005,cs_mu=.1,cs_v=.5,
                          cs_m=.000005,cs_mu=.0001,cs_v=.0005,
                          a_mu=.01, b_mu=.01,
                          a_w=20000., b_w=2.,
                          printFreq=1000, 
                          truth=Purity.State([0.],phi_truth,m_truth,
                                             0.,w2_truth,sig2_truth));

v = hcat(map(o->o.v, out)...);
phi = hcat(map(o->o.phi,out)...);
m = hcat(map(o->o.m,out)...);
mu = map(o->o.mu, out);
sig2 = map(o->o.sig2, out);
w2 = map(o->o.w2, out);

R"pdf('../../model3/output/multivariate.pdf',w=13,h=8)";
R"out <- list(v=$v,phi=$phi,m=$m,mu=$mu,sig2=$sig2,w2=$w2)";
R"plotPurity(out,dat,rgba_level=.1,v_acc=FALSE)";
R"plot($ll,type='l',main='Log likelihood with burn-in',ylab='log likelihood',
ylim=c(min($ll,$ll_truth),max($ll,$ll_truth)))";
R"abline(v=length($ll)-length($mu),col='grey', h=$ll_truth)"
R"plot(tail($ll,length($mu)),type='l',main='Log likelihood after burn-in',ylab='log likelihood')";
R"abline(h=$ll_truth,col='grey')";
R"dev.off()";


#=
include("test.jl")
Purity.DPMM.acceptance_rate(map(o -> o.mu, out))
=#
