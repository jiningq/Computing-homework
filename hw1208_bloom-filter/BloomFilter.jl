type BloomFilter
	BitArray::BitArray{1}
	NumberOfBits::Int
	NumberOfHashes::Int
end

function build_bloom_filter(NumberOfBits::Integer, NumberOfHashes::Integer)
	BloomFilter(falses(NumberOfBits), NumberOfBits, NumberOfHashes)
end

function get_number_of_bits(BF::BloomFilter)
	return BF.NumberOfBits
end

function get_number_of_hashes(BF::BloomFilter)
	return BF.NumberOfHashes
end

# function for calculating optimal number of hash functions and bits
function optimal_bits_hashes(NumOfObjects::Number, ErrorRate::Number)
	if ErrorRate <= 0 || ErrorRate >= 1
		throw(ArgumentError("Error rate has to be between 0 and 1!"))
	end
	if NumOfObjects <= 0
		throw(ArgumentError("Number of objects has to be greater than 0!"))
	end

	BitsPerObject = Int(round(1.44 * log2(1/ErrorRate)))
	NumberofHashes = Int(round(log(2) * BitsPerObject))
	return [BitsPerObject * NumOfObjects, NumberofHashes]
end

# function for calculating theoretical false positive rates
function error_rate(NumberOfHashes::Integer, NumberOfBits::Integer, NumOfObjects::Integer)
	return (1 - ( 1 - 1 / NumberOfBits ) ^ (NumberOfHashes * NumOfObjects) )^NumberOfHashes
end


# get multiple hashes by taking linear combinations from two hash functions
# (which are the function hash with two different seeds)
# I read the Bloom Filter package source code before writing the following part.

function multi_hash(NumberOfHashes::Integer, NumberOfBits::Integer)
	function mhash(element)
		[mod(hash(element, UInt(i)), NumberOfBits) + 1 for i in 1:NumberOfHashes]
	end
	return mhash
end

function insert!(BF::BloomFilter, element)
	mhash = multi_hash(BF.NumberOfHashes, BF.NumberOfBits)
    hashes = mhash(element)
	BF.BitArray[hashes] = 1
end

function is_element(BF::BloomFilter, element)
	mhash = multi_hash(BF.NumberOfHashes, BF.NumberOfBits)
    hashes = mhash(element)
	return all(BF.BitArray[hashes])
end










