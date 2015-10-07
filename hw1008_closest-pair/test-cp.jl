using Base.Test
include("closest-pair.jl")

@test_throws ArgumentError ClosestPair([1.0],[2,3])
@test ClosestPair([1], [1])[1] == Inf
@test length(ClosestPair([1, 2, 3, 4], [0, 0, 0, 0])[2]) == 3
@test ClosestPair([1, 2, 3, 4], [0, 0, 0, 0])[1] == 1


dat = readdlm("closest-pairs1.txt")
println(string("Time used: ", ( @elapsed result = ClosestPair(dat[:, 1], dat[:, 2])), " seconds."))
# Time used: 3.003797431 seconds.
print_res(result)


## found 11 pairs of points that achieve the minimum distance

## testing in terminal:

## $ PATH="/Applications/Julia-0.3.7.app/Contents/Resources/julia/bin:$PATH"
## $ julia test_cp.jl
