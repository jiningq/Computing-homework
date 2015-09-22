# 36-750 Statistical Computing
# Homework 4
# Jining Qin

# Binary search
# (1)
using Base.Test
using DataFrames


@test_throws ErrorException binary_search_w(1, [2,3,4], 4, 1)
@test_throws ErrorException binary_search_w(1, [3,2,4], 1, 4)
@test binary_search_w(1, [-1,0,1], 1, 4) == (true, 3)
@test binary_search_w(1, [2,3,4], 1, 4) == (false, 0)
@test binary_search_w(1, [-1,0,1], 1, 3) == (false, 0)
@test binary_search_w(4, [1,2,3,5,6], 1, 6) == (false, 0)
@test binary_search_w(2, [1,2], 1, 3) == (true, 2)
@test binary_search_w(2, [1,2], 1, 2) == (false, 0)
@test binary_search_w(4, linspace(1, 100, 100), 1, 100) == (true, 4)
@test binary_search_w(100, linspace(1, 100, 100), 1, 100) == (false, 0)
@test binary_search_w(99, linspace(1, 100, 100),1 , 100) == (true, 99)


function midpoint(a, b)
  return floor((a + b) / 2)
end

function binary_search_w(query, seq, first, last)
  found = false
  bound = 0
  if first > last - 1
    error("Invalid input: empty range between bounds.")
  end
  if all([seq[ii] < seq[ii + 1] for ii in first : last - 2]) == false
    error("Sequence not sorted!")
  end

  if query < seq[first] || query > seq[last - 1]
    return (found,bound)
  end

  while first < last - 1
    imid = midpoint(first , last - 1)
    if seq[imid] < query
      first = imid + 1
    else last = imid + 1
    end
  end
  if first == last - 1 && seq[first] == query
    found = true
    bound = first
    return (found,bound)
  else
    return (found,bound)
  end
end
