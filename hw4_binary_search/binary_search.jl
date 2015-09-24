# 36-750 Statistical Computing
# Homework 4
# Jining Qin

# Binary search
# (1)
using Base.Test

@test_throws ErrorException binary_search(1, [2,3,4], 4, 1)
@test_throws ErrorException binary_search(1, [3,2,4], 1, 4)
@test binary_search(1, [-1,0,1], 1, 4) == (true, 3)
@test binary_search(1, [2,3,4], 1, 4) == (false, 0)
@test binary_search(1, [-1,0,1], 1, 3) == (false, 0)
@test binary_search(4, [1,2,3,5,6], 1, 6) == (false, 0)
@test binary_search(2, [1,2], 1, 3) == (true, 2)
@test binary_search(2, [1,2], 1, 2) == (false, 0)
@test binary_search(1, linspace(1, 100, 100), 1, 2) == (true, 1)
@test binary_search(100, linspace(1, 100, 100), 1, 100) == (false, 0)
@test binary_search(99, linspace(1, 100, 100),1 , 100) == (true, 99)






function binary_search(query, seq, first, last, partition_point = partition_point)
  if first > last - 1
    error("Invalid input: empty range between bounds.")
  end
  if all([seq[ii] < seq[ii + 1] for ii in first : last - 2]) == false
    error("Sequence not sorted!")
  end

  if query < seq[first] || query > seq[last - 1]
    return (false,0)
  end

  while first < last - 1
    imid = partition_point(first , last - 1)
    if seq[imid] < query
      first = imid + 1
    else last = imid + 1
    end
  end
  if first == last - 1 && seq[first] == query
    found = true
    bound = first
    return (true,bound)
  else
    return (false,0)
  end
end


#(2)
# writing the partition point function
# Assuming we have general iterators instead of integers, I use linear scan for finding the partition point

function partition_point(pred, seq, first, last)
  it = seq[ first]
  while pred( seq [it]) == true
    it=advance( it)
  end
  return it
end


# Assuming integer indices then the partition point would be much simpler
# Use multiple dispatch for this particular case
# In fact, the integer case would be equivalent to setting
# pred = ( x -> x < floor ( (first + last )/2 ) )
# advance = ( it -> it + 1)


@test partition_point(1, 3) == 2
@test partition_point(4, 81) ==  42

partition_point(a::Number,b::Number) = floor( (a + b)/2 )

# Honestly I am a bit confused about this question. Is what I did what you wanted?
# I am not exactly sure whether I should sacrifice performance for generality here
# in the integer index case. Also, I'm not sure how I can test the general iterator
# version partition_point function I wrote above.

