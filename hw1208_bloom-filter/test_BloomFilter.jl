using Base.Test
include("BloomFilter.jl")

(NumberOfHashes, NumberOfBits, NumberOfObjects, Iterations) = map(x -> parse(Int, x), ARGS)

# testing functions for getting number of bits and number of hash functions
BF = build_bloom_filter(NumberOfBits, NumberOfHashes)
@test get_number_of_bits(BF) == NumberOfBits
@test get_number_of_hashes(BF) == NumberOfHashes
println("Functions for getting number of bits/hashes work.")

# testing that no false negatives exist

RandomStrings = [randstring(5) for i in 1:NumberOfObjects]
for i in 1:NumberOfObjects
	insert!(BF, RandomStrings[i])
end

@test all(i -> is_element(BF, RandomStrings[i]) == true, 1:NumberOfObjects)
println("No false negatives in bloom filter with ", NumberOfObjects, " objects.")

# test the false positive rates
FalsePositives = 0
for i in 1:Iterations
	FalsePositives += is_element(BF, randstring(3))
end
println(string("False positive rate in ", Iterations, " runs: ", FalsePositives/Iterations))
println(string("Theoretical false positive rate: ", 
	error_rate(NumberOfHashes, NumberOfBits, NumberOfObjects)))

# running the test script from command line using 5 hash functions,
# 1000 bits in the array, 100 objects and 10000 iterations for calculating
# false positive rate

# cd github/gol/hw1208_bloom-filter
# PATH="/Applications/Julia-0.4.1.app/Contents/Resources/julia/bin:$PATH"
# julia test_BloomFilter.jl 5 1000 100 10000

# output:
# Functions for getting number of bits/hashes work.
# No false negatives in bloom filter with 100 objects.
# False positive rate in 10000 runs: 0.0094
# Theoretical false positive rate: 0.009449125254343013

# The two error rates are not always so close, running it several times give results
# between 0.0067 to 0.0129 
