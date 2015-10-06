using PyPlot

# have the call the function one time so that Julia 'compiles' it

include("memoize.jl")
fib(5)
fibonacci = memoize(fib)
fibonacci(10)

function time_memoize(x)
  n = integer(x)
  time_naive = zeros(n)
  time_mem = zeros(n)
  for jj in 1 : n
    time_naive[jj] = (@elapsed fib(jj))
    time_mem[jj] = (@elapsed fibonacci(jj))
  end
  plot(1:n, log(time_naive))
  plot(1:n, log(time_mem))
  legend()
  show()
end

print(map(x-> time_memoize(x), ARGS))

# testing in Terminal:
# $ PATH="/Applications/Julia-0.3.7.app/Contents/Resources/julia/bin:$PATH"
# $ julia time_memoize.jl 35


## On the logarithmic scale the time of the naive fibonacci sequence is
## linear (indicating exponential time complexity) while the memoized version
## is almost constant (since it's a linear time algorithm)



