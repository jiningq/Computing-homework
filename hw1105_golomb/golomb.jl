#using Memoize
using StatsBase
using Base.Test
using PyPlot

# Naive implementation based on recursion.
# Takes 2 seconds to evaluate 60. Takes 21 seconds to evaluate 70.
function golomb(n)
  n == 1 ? 1 : 1 + golomb(n - golomb(golomb(n-1)))
end


# Using the memoize package to get a memoized version of the function
# Weird 'stack overflow' problem for large n's, 1e6 for example
# The odd thing is, if we grow the value of n gradually, it wouldn't
# give the same stack overflow error anymore.

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
# It is very fast with lower n value. The time complexity seems
# to be O(log(n)) at smaller n (<1e5, e.g.) with several spikes,
# the spikes become much more frequent and the time is starting
# to look like growing linearly.

# I attached a plot produced.

function golomb3(n)
  if n <= 3
    return n == 1 ? 1: 2
  end
  i = 1
  G = [0 => 1, 1 => 2, 2=> 4]
    while G[G[i]-1] < n + 1
    for j in G[i]:G[i+1] - 1
      G[j] = G[j - 1] + i + 1
      if G[j] >= n + 1
        return j
      end
    end
    i = i + 1
  end
end

# function for measuring the time
function time_f(f, x, leng = x, omit = false, Log = false)
    Range = int(linspace(1, x, int(leng)))
  time_naive = zeros(length(Range))
  for jj in 1:length(Range)
    tic()
    f(Range[jj])
    time_naive[jj] = toq()
#     tic()
#     golomb2(jj)
#     time_mem[jj] = toq()
  end
  println(sum(time_naive .> 0.02))
  if(omit)
    Range = Range[time_naive .< 0.02]
    time_naive = time_naive[time_naive .< 0.02]

  end
  Log ? PyPlot.plot(log(Range)/log(10),time_naive):PyPlot.plot(Range,time_naive)
  Log ? PyPlot.xlabel("lg(n)"): PyPlot.xlabel("n")
  PyPlot.ylabel("Time (seconds)")
  PyPlot.legend()
  show()
end

@time time_f(golomb3, 5e5, 1e4, true, true)
@time time_f(golomb3,5e7, 2e3, false, false)

i = 2
10^i
function t(n)
  tic()
  golomb3(n)
  return(toq())
end


# Attempt to use the asymptotic formula for the sequence, no good so far.

i = 1000
1e6 == 10^6
while t(i^3) <
  println(i)
  i = i + 1
end
phi = (sqrt(5)+1)/2
function f(n)
  (phi^(2-phi) * n^(phi - 1)) # +n^(phi-1)/log(n)
end
@time golomb3(1e8)

function err(n)
  n^(phi-1)/log(n)
end


@time errar = [f(n)-golomb3(n) for n in 1e8:1e8+1e3]
PyPlot.plot(1e8:1e8+1e3, errar)
show()

f(100)-golomb3(100)

i = 1
Min = Max = 0
while max(-Min, Max) < 50
  i = i + 1
  if f(i) - golomb3(i) < Min
    Min = f(i) - golomb3(i)
    println(Max)
  elseif f(i) - golomb3(i) > Max
    Max = f(i) - golomb3(i)
    println((i, Max))
  end
end




# http://www.sciencedirect.com/science/article/pii/0022314X9290024J
