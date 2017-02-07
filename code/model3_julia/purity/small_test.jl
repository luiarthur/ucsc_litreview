include("DPMM.jl")

using RCall, Distributions
R"library(rcommon)";

N = 100
M = 30
mu = .8
p(mu::Float64,m::Vector{Float64}) = mu * m ./ (2*(1-mu) + mu*m)
m = rand( Gamma(2/.1,.1), N)
n = map(ps -> rand( Binomial(M,ps) ), p(mu,m))

p_dat = p(mu, m)

function fit(n::Vector{Int}, cs::Float64, B::Int, burn::Int; printEvery::Int=0)

  function ll(mu::Float64)
    const p_vec = p(mu, m)
    #return sum( logpdf(Binomial(M, p_vec[i]), n[i]) for i in 1:N )
    return sum( n[i]*log(p_vec[i]) + (M-n[i])*log(1-p_vec[i]) for i in 1:N )
  end
  lp(mu::Float64) = 0.0

  update(mu::Float64) = DPMM.metLogit(mu, ll, lp, cs)

  DPMM.gibbs(.5, update, B, burn, printFreq=printEvery)
end

out = fit(n, .1, 2000, 10000, printEvery=1000)

R"plotPost($out, xlab=paste('Acceptance Rate:', length(unique($out)) / length($out)))";

#=
include("small_test.jl")
=#
