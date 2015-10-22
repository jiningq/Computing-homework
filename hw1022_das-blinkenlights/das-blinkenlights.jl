# defining the update step
function toggle(x)
  x $ [x[end], x[1:end-1]]
end

# Naive implementation of repeated updating
function rep_toggle(x::Array, B::Integer, update::Function = toggle)
  y = copy(x)
  for i in 1:B
    y = update(y)
  end
  y
end

# @time rep_toggle([1, 0, 0, 0, 0], 10^6)
# takes 10 seconds for 10^6 iterations, will take 10^10 seconds for 10^15 iterations


# the operation has to be periodic with period no greater than 2^n
# now we iterate as keeping track of each step, if there is repetition
# then we can find the period and we only need to run the rest number
# of steps mod the period.

function blink(x::Array, B::Integer, update = toggle)
  i = 0
  y = copy(x)
  period = 0
  dict = [x => 0]
  while i <= min(2^length(x), B - 1)
    i = i + 1
    y = update(y)
    if haskey(dict, y)
      period = i - dict[y]
      break
    end
  dict[y] = i
  end

  if i <= B - 1
    n = mod(B - i, period )
    for ii in 1:n
      y = update(y)
    end
  end
  return y
end


# @time print(blink([1,0,0,0,0], 10^15))
# takes less than one second to evaluate 10 ^ 15 steps
