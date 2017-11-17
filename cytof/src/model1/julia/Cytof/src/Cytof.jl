__precompile__()
module Cytof

using Distributions

#export posterior_fixed_K, posterior

include("MCMC.jl")
include("State.jl")
include("Prior.jl")

include("posterior_fixed_K.jl")
include("posterior.jl")

### Include all files in param_updates dir
const PARAM_UPDATES_DIR = "param_updates/"
all_files = split(readstring(`ls $PARAM_UPDATES_DIR`),"\n")
all_files = filter(x -> contains(x, ".jl"), all_files)

for f in all_files
  include(PARAM_UPDATES_DIR * f)
end

end # module Cytof
