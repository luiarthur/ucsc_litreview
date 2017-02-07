# compare with the other gibbs
function gibbs{T}(init::T, update, B::Int, burn::Int; printFreq::Int=0)
  const out = Vector{T}(B)
  out[1] = init

  for i in 2:(B+burn)
    if i <= burn + 1
      out[1] = update(out[1])
    else
      out[i-burn] = update(out[i-burn-1])
    end

    if printFreq > 0 && i % printFreq == 0
      print("\rProgress: ",i,"/",B+burn)
    end
  end

  return out
end

"""
metropolis step with normal proposal
"""
function metropolis(curr::Float64, ll, lp, cs::Float64)

  const cand = rand(Normal(curr,cs))

  const new_state = if ll(cand) + lp(cand) - ll(curr) - lp(curr) > log(rand())
    cand
  else
    curr
  end

  return new_state
end




function metropolis(curr::Vector{Float64}, ll, lp, cs::Matrix{Float64})

  const cand = rand( MvNormal(curr,cs) )

  const new_state = if ll(cand) + lp(cand) - ll(curr) - lp(curr) > log(rand())
    cand
  else
    curr
  end

  return new_state
end


# For transforming bounded parameters to have infinite support

function lp_log_gamma(log_x::Float64, shape::Float64, rate::Float64)
  #shape*log(rate) - lgamma(shape) + shape*log_x - rate*exp(log_x)
  const log_abs_J = log_x
  return logpdf(Gamma(shape,1/rate), exp(log_x)) + log_abs_J
end

function lp_log_invgamma(log_x::Float64, a::Float64, b_numer::Float64)
  #a*log(b_numer) - lgamma(a) - a*log_x - b_numer*exp(-log_x)
  const log_abs_J = log_x
  return logpdf(InverseGamma(a,b_numer), exp(log_x)) + log_abs_J
end

#lp_logit_unif(logit_u::Float64) = logit_u - 2*log(1+exp(logit_u)) 
lp_logit_unif(logit_u::Float64) = logpdf(Logistic(), logit_u)

logit(p::Float64,a::Float64=0.0,b::Float64=1.0) = log( (p-a)/ (b-p) )
inv_logit(x::Float64,a::Float64=0.0,b::Float64=1.0) = (b*exp(x)+a) / (1+exp(x))

function metLogit(curr::Float64, ll, lp, cs::Float64)

  lp_logit(logit_p::Float64) = lp(inv_logit(logit_p)) + lp_logit_unif(logit_p)
  ll_logit(logit_p::Float64) = ll(inv_logit(logit_p))

  return inv_logit(metropolis(logit(curr),ll_logit,lp_logit,cs))
end

# Autotune MCMC candsig
"""
k = (window / 50) is good
Multiply this with the old cs to get a new cs
"""
function autotune(accept::Float64, target::Float64=.3, k::Float64=2.5)
  return (1+(cosh(accept-target)-1)*(k-1)/(cosh(target-
             ceil(accept-target))-1))^sign(accept-target)
end

function acceptance_rate{T}(samples::Vector{T})
  return mean(samples[i] == samples[i-1] for i in 2:length(samples))
end
