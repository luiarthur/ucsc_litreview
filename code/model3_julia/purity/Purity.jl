module Purity

include("DPMM.jl")

using Distributions

immutable State 
  v::Vector{Float64}
  phi::Vector{Float64}
  m::Vector{Float64}
  mu::Float64
  w2::Float64
  sig2::Float64
end

const null_state = State([0.0], [0.0], [0.0], 0.0, 0.0, 0.0)

function fit(n₁::Vector{Int}, N₁::Vector{Int}, N₀::Vector{Int}, M::Vector{Float64},
             B::Int, burn::Int; 
             m_phi::Float64=0.0, s2_phi::Float64=10.0,
             a_sig::Float64=2.0, b_sig::Float64=1.0,
             a_mu::Float64=1.0, b_mu::Float64=1.0, cs_mu::Float64=1.0,
             a_m::Float64=1.0, b_m::Float64=1.0, cs_m::Float64=1.0,
             a_w::Float64=200.0, b_w::Float64=2.0,
             a_v::Float64=1.0, b_v::Float64=1.0, cs_v::Float64=1.0,
             alpha::Float64=1.0, printFreq::Int=0,
             truth=null_state)
  
  const numLoci = length(n₁)
  const Iₛ = eye(numLoci)
  #const cs_mu_and_m = Matrix(Diagonal([cs_mu; fill(cs_m,numLoci)]))

  # Helper Fn
  function p(mu::Float64, v::Vector{Float64}, m::Vector{Float64})
    return (mu * v .* m) ./ (2.0*(1.0-mu) + mu*m)
  end

  function ps(mu::Float64, vs::Float64, ms::Float64)
    return (mu * vs * ms) / (2.0*(1.0-mu) + mu*ms)
  end

  function z(mu::Float64, m::Vector{Float64})
    return (2N₁) ./ (N₀ .* (2*(1-mu) + mu*m))
  end

  function ss(mu::Float64, phi::Vector{Float64}, m::Vector{Float64})
    return sum( (log(z(mu,m)) .- phi) .^ 2 )
  end

  function loglike(state::State)
    const zz = z(state.mu, state.m)
    const pp = p(state.mu, state.v, state.m)

    const ll1 = sum(n₁ .* log(pp) + (N₁-n₁) .* log(1-pp))
    const ll2 = -sum( (log(zz)-state.phi).^2 ) / (2*state.sig2) - (numLoci/2)*log(state.sig2)
    const ll3 = -sum(log(M ./ state.m).^2) / (2*state.w2) - (numLoci/2)*log(state.w2)

    return ll1 + ll2 + ll3
  end

  #const ll_vec = Vector{Float64}(B)
  const ll_vec = Vector{Float64}(B+burn-1)
  it = 0

  function update(curr::State)

    # Update σ²
    const sig2_new = if truth.sig2 != null_state.sig2
      truth.sig2
    else
      rand(InverseGamma(a_sig + numLoci/2, 
                        b_sig + ss(curr.mu, curr.phi, curr.m)/2))
    end

    # Update ϕ
    const phi_new = if truth.phi != null_state.phi
      truth.phi
    else
      const phi_denom = sig2_new + s2_phi
      const phi_mean = ( log(z(curr.mu,curr.m)*s2_phi) + m_phi*sig2_new) / phi_denom
      const phi_var = sig2_new*s2_phi / phi_denom
      rand( MvNormal(phi_mean, phi_var * eye(numLoci)) )
    end

    # Update w² # messing up the loglike
    const w2_new = if truth.w2 != null_state.w2
      truth.w2
    else
      const ssM = sum(log(M ./ curr.m) .^ 2)
      rand( InverseGamma(a_w+numLoci/2, b_w+ssM/2) )
    end

    # Update v
    #const v_tmp = begin
    const v_new = if truth.v != null_state.v
      truth.v
    else
      function lf(vs::Float64, s::Int)
        const pss = ps(curr.mu, vs, curr.m[s])
        return n₁[s]*log(pss) + (N₁[s]-n₁[s])*log(1-pss)
      end
      
      lg0(vs::Float64) = (a_v-1)*log(vs) + (b_v-1)*log(1-vs)
      rg0() = rand(Beta(a_v, b_v))

      DPMM.neal8(alpha,curr.v,lf,lg0,rg0,DPMM.metLogit,cs_v,
                 numClusterUpdates=1)
    end

    # Update v and mu
    #const (mu_new,v_new) = begin
    #  const v_star = unique(v_tmp)
    #  const K = length(v_star)

    #  # getting cluster membership
    #  const idx = Dict{Int,Int}()
    #  for i in 1:numLoci
    #    j = 1
    #    while v_tmp[i] != v_star[j]
    #      j += 1
    #    end
    #    assert(j <= K)
    #    idx[i] = j
    #  end

    #  lp_logit_muv(logit_muv::Vector{Float64}) = sum(DPMM.lp_logit_unif.(logit_muv))

    #  function ll_logit_muv(logit_muv::Vector{Float64})
    #    const muv = DPMM.inv_logit.(logit_muv)
    #    const mu = muv[1]
    #    const v_unique = muv[2:end]
    #    const v = v_unique[[idx[i] for i in 1:numLoci]]

    #    const ll1 = -ss(mu,phi_new,curr.m) / (2*sig2_new)
    #    const pp = p(mu, v, curr.m)
    #    const ll2 = sum( n₁.*log(pp) + (N₁-n₁).*log(1-pp) )
    #    return ll1 + ll2
    #  end

    #  const logit_muv = DPMM.logit.([curr.mu; v_star])
    #  const cs_mu_and_v = Matrix(Diagonal([cs_mu; fill(cs_v,K)]))
    #  const muv_new = DPMM.inv_logit.(DPMM.metropolis(logit_muv,
    #                                                  ll_logit_muv,lp_logit_muv,
    #                                                  cs_mu_and_v))

    #  const v_new = [ muv_new[idx[i]+1] for i in 1:numLoci ]

    #  (muv_new[1], v_new)
    #end

    ## Update μ
    const mu_new = if truth.mu != null_state.mu
      truth.mu
    else
      function llMu(mu::Float64)
        const ll1 = -ss(mu,phi_new,curr.m) / (2*sig2_new)
        const pp = p(mu, v_new, curr.m)
        const ll2 = sum( n₁.*log(pp) + (N₁-n₁).*log(1-pp) )
        return ll1 + ll2
      end

      lpMu(mu::Float64) = (a_mu-1)*log(mu) + (b_mu-1)*log(1-mu)

      DPMM.metLogit(curr.mu, llMu, lpMu, cs_mu)
    end

    # Update m
    const m_new = if truth.m != null_state.m
      truth.m
    else
      function lp_log_m(log_m::Vector{Float64})
        return sum( DPMM.lp_log_gamma(lm, a_m, b_m) for lm in log_m )
      end

      function ll_log_m(log_m::Vector{Float64})
        const m = exp(log_m)
        const zz = z(mu_new, m)
        const pp = p(mu_new, v_new, m)
        const ll1 = sum(n₁ .* log(pp) + (N₁-n₁) .* log(1-pp))
        const ll2 = -sum( (log(zz)-phi_new).^2 ) / (2*sig2_new)
        const ll3 = -sum(log(M ./ m).^2) / (2*w2_new)
        return ll1 + ll2 + ll3
      end

      exp(DPMM.metropolis(log(curr.m), ll_log_m, lp_log_m, cs_m*Iₛ))
    end

    const new_state = State(v_new, phi_new, m_new, mu_new, w2_new, sig2_new)

    # Compute ll. Comment this out when done testing.
    it += 1
    #if it >= burn 
    #  ll_vec[it-burn+1] = loglike(new_state)
    #end
    if it < B+burn
      ll_vec[it] = loglike(new_state)
    end
    # end of compute ll

    return new_state
  end

  const init = State(fill(.5,numLoci),fill(0.,numLoci),fill(2.,numLoci),.5,1.,1.)

  return (ll_vec, DPMM.gibbs(init, update, B, burn, printFreq=printFreq))
  #return DPMM.gibbs(init, update, B, burn, printFreq=printFreq)
end

end
