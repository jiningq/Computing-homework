include("memoize.jl")

fibonacci = memoize(fib)
fibonacci(10)

function test_memoize(x)
  for jj in 1 : integer(x)
  @assert fib(jj) == fibonacci(jj)
  end
  return(string("First ", x, " values match for two versions of the function."))
end

print(map(x-> test_memoize(x), ARGS))

# testing in Terminal:
# $ PATH="/Applications/Julia-0.3.7.app/Contents/Resources/julia/bin:$PATH"
# $ julia test_memoize.jl 40