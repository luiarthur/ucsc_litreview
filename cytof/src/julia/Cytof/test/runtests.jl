# When publishing, uncomment this:
#using Cytof

# When publishing, comment this out:
include("../src/Cytof.jl")

using Base.Test

@testset "Test MCMC being loaded" begin
  @test string(Cytof.MCMC.logit) == "Cytof.MCMC.logit"
end
