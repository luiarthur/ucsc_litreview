module CRP

import Distributions

export crp


"""
    table(x::Vector{Float64})

    returns a Dict{Float64 => Int64} of the unique values in `x` and the number of occurences.
"""
function table(x::Vector{Float64})
  const dict = Dict{Float64, Int64}() # parameter to size

  for u in x
    if haskey(dict, u)
      dict[u] += 1
    else
      dict[u] = 1
    end
  end

  return dict
end



function crp(t::Vector{Float64}, c::Vector{Int64}, alpha::Float64, 
             fi, log_fI, rg0, log_g0)
  const n = length(t)

  for i in 1:n
    for j in 1:n
      if j != i
        p 
      end
    end
  end

end # crp

end # module CRP
