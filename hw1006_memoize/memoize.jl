## 36-750 Homework for Oct 6
## Jining Qin


function fib(n)
  if n == 1 || n == 2
    return 1
  else return fib(n - 1) + fib(n - 2)
  end
end

function memoize(f)
  cache = [0 => 0, 1 => f(1), 2 => f(2)]
  function res(n)
    if haskey(cache, n)
      return cache[n]
    else
      for ii in maximum(keys(cache)) : n
        cache[ii] = cache[ii - 2] + cache[ii - 1]
      end
      return cache[n]
    end
  end
  return res
end


