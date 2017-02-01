module DPMM

import StatsBase.countmap
import Distributions: wsample, Normal, MvNormal, InverseGamma, Gamma, Logistic, logpdf

include("MCMC.jl")
include("neal8.jl")

end
