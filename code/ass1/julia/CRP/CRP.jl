module CRP

import Distributions, StatsBase.countmap

export crp


# scala was 23s at school 33s at home for 100 loci
function crp(t::Vector{Float64}, c::Vector{Int64}, alpha::Float64, 
             fi, log_fI, rg0, log_g0)

  const n = length(t)

  for i in 1:n
    for j in 1:n
      if j != i
      end
    end
  end

end # crp

end # module CRP
