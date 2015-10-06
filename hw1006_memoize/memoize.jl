## 36-750 Homework for Oct 6
## Jining Qin


function fib(n)
  if n == 1 || n == 2
    return 1
  else return fib(n - 1) + fib(n - 2)
  end
end

function memoize(f)
  cache = Dict()
  function res(n)
    if !haskey(cache, n)
      cache[n] = f(n)
    end
    return cache[n]
  end
  return res
end

fib = memoize(fib)

## http://johnsjulia.blogspot.com/2013/10/problem-set.html

## There was someone else who experienced similar difficulty as I did. In Julia,
## function names are constants and redefinition isn't allowed. That also leads to
## the original function still being recursively called (instead of looking up in
## the cache), thus no speeding is achieved.

## The memoize package for Julia does the work automatically but I doubt that would
## satisfy the requirement of this homework. I'll leave the solution using that
## package here and please let me know what you think.

Pkg.add("Memoize")

using Memoize
@memoize function fib2(n)
  if n == 1 || n == 2
    return 1
  else return fib2(n - 1) + fib2(n - 2)
  end
end


