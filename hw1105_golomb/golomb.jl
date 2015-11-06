#using Memoize
using StatsBase
using Base.Test

# Naive implementation based on recursion.
# Takes 2 seconds to evaluate 60. Takes 21 seconds to evaluate 70.
function golomb(n)
  n == 1 ? 1 : 1 + golomb(n - golomb(golomb(n-1)))
end


# Using the memoize package to get a memoized version of the function
# Weird 'stack overflow' problem for large n's, 1e6 for example
# The odd thing is, if we grow the value of n gradually, it wouldn't
#give the same stack overflow error anymore.

# @memoize function golomb1(n)
#   n == 1 ? 1 : 1 + golomb1(n - golomb1(golomb1(n-1)))
# end

# For example
# golomb1(1e6)
# gives 'stack overflow', but

# for ( i in 1:50)
#   println(golomb1(20000 * i))
# end

# would work normally.

# Also for some reason running the test from terminal never finish
# 'include'ing this script file if I use the memoize package.( Comment
# out the first line and everything is fine).

# so I wrote a memoized version myself
function golomb2(n)
  cache = [1 => 1, 2=> 2, 3 => 2]
  if haskey(cache, n)
    return cache[n]
  else
  tail = 2
    while maximum(keys(cache)) < n
      keyChain = collect(keys(cache))
      cache[maximum(keyChain) + cache[minimum(keyChain[keyChain .>= tail + 1])]] =
        tail + 1
      tail = tail + 1
    end
    return cache[maximum(keys(cache))]
  end
end

# @time golomb2(1e6)
# @time golomb2(1e7)

# Sadly this is still not fast enough ( I think), it takes 3 seconds to
# evaluate 1e6 and 50 seconds to evaluate 1e7. It seems the time complexity
# is growing linearly in n.


# This is written based on this answer on stackoverflow,
# http://stackoverflow.com/questions/12786087/golombs-sequence
# but it seems at large n value it still has O(n) complexity
function golomb3(n)
  if n < 1000
    return golomb2(n)
  else
    sumTemp = k = 0
    while sumTemp < n
      k += 1
      sumTemp += k * golomb2(k)
    end
    sumTemp -= k * golomb2(k)
    l = golomb2(sumTemp)
    while sumTemp <= n
      l += 1
      sumTemp += k
    end
    return l
  end
end


# the speed achieved by this algorithm is still only remote from solving
# problem 341 of Project Euler. Would you let me know what a faster ones
# would be like? Say a log time algorithm?
