using Distributions
using Base.Test

include("das-blinkenlights.jl")

@test_throws ArgumentError blink([1,0,0,0,0], 1.5)

for i in 1:2000
  x = [rand(Binomial(1, 0.5)) for i in 1:11]
  @test rep_toggle(x, i) == blink(x, i)
end
