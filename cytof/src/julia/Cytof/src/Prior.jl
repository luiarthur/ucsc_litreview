struct Prior
  # mus
  mus_thresh::Float64 # default to log(2)
  cs_mu::Matrix{Float64}

  # psi
  m_psi::Float64
  s2_psi::Float64
  cs_psi::Vector{Float64}
  
  # tau2
  a_tau::Float64
  b_tau::Float64
  cs_tau2::Vector{Float64}

  # c
  s2_c::Float64
  cs_c::Float64

  # d
  m_d::Float64
  s2_d::Float64
  cs_d::Float64

  #sig2
  a_sig::Float64
  b_sig::Float64
  cs_sig2::Vector{Float64}

  # alpha
  alpha::Float64

  # v
  cs_v::Float64

  # H
  G::Matrix{Float64}
  R::Matrix{Float64}
  S2::Vector{Float64}
  cs_h::Float64

  # W
  a_w::Float64
  
  # K
  K_min::Int32  # 1?
  K_max::Int32  # 15?
  a_K::Int32    # constraint: 2 * a_K <= K_max - K_min + 1
end
