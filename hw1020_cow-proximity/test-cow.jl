using Base.Test
include("cow-proximity.jl")

@test_throws ArgumentError crowded_cows([7,3,4,2,3,10,4], 10)
@test crowded_cows([7,3,4,2,3,10,4], 3) == 3
@test crowded_cows([7,3,4,2,3,4], 3) == 4
@test crowded_cows([7,3,1,0,4,2,16,28,3,4],3) == -1
println("All unit tests passed.")

# cows = int(readdlm("cows.txt"))
println("Testing on input file...")
cows = int(readdlm(ARGS[1]))
println(string("Time used: ", ( @elapsed crowded_cows(cows, 25000)), " seconds."))
println(string("Maximum breed id of a pair of crowded cows: ",crowded_cows(cows, 25000)))
# The maximum breed id of a pair of crowded cows is 999893.
# It takes Julia within 0.1 second to get this result.

## testing in terminal:

## $ PATH="/Applications/Julia-0.3.7.app/Contents/Resources/julia/bin:$PATH"
## $ julia test-cow.jl cows.txt
