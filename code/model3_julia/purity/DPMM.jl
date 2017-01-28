module DPMM

import StatsBase.countmap
import Distributions.wsample
import Distributions.Normal
import Distributions.MvNormal

include("MCMC.jl")
include("neal8.jl")

end
