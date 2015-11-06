include("golomb.jl")

# The test is based on the fact the frequency table of the sequence is the same as
# the sequence itself.



# Check the first 1000 element if there is no specified upper limit and use the input as upper limit
# if there is.
# ARGS is the variable storing command line inputs. But it is defined here as UTF8String["52803","103"].
# I'm not sure why.

if length(ARGS) == 1
  n = int(ARGS)[1]
else
  n = 1000
end

a = map(golomb2, 1:n)
@test counts(a)[1:end-1] == a[1:length(counts(a))-1]
println(string("The frequency table of the first ",n," elements matches the sequence itself."))

# testing in command line
# $ PATH="/Applications/Julia-0.3.7.app/Contents/Resources/julia/bin:$PATH"
# $ julia test-golomb.jl 10000

# Output:
## The frequency table of the first 100 elements matches the sequence itself.
