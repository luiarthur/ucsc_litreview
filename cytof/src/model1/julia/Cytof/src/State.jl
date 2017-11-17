mutable struct State
  mus::Matrix{Float64}          # J x K
  psi::Vector{Float64}          # J
  tau2:: Vector{Float64}        # J
  pi_param::Matrix{Float64}     # I x J
  c::Vector{Float64}            # J
  d::Float64                    # scalar
  sig2::Vector{Float64}         # I
  v::Vector{Float64}            # K
  H::Matrix{Float64}            # J x K
  lam::Array{Array{Int32}}      # I x N_i
  W::Matrix{Float64}            # I x K
  Z::Matrix{Int8}               # J x K
  e_param::Array{Matrix{Int8}}  # I x N_i x J
  K::Int32                      # scalar
end
