module DPMM

import StatsBase.countmap
import Distributions.wsample
import Distributions.Normal
import Distributions.MvNormal
import Distributions.Beta

include("MCMC.jl")
include("neal8.jl")

end
