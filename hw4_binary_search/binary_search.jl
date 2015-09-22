# 36-750 Statistical Computing
# Homework 4
# Jining Qin

# Binary search
# (1)
using Base.Test

@test_throws ErrorException binary_search_w(1, [2,3,4], 4, 1)
@test_throws ErrorException binary_search_w(1, [3,2,4], 1, 4)
@test binary_search_w(1, [-1,0,1], 1, 4)==3
@test binary_search_w(1, [2,3,4], 1, 4)=="Not found!"
@test binary_search_w(1, [-1,0,1], 1, 3)=="Not found!"
@test binary_search_w(4, [1,2,3,5,6], 1, 6)=="Not found!"
@test binary_search_w(2, [1,2], 1, 3)==2
@test binary_search_w(2, [1,2], 1, 2)=="Not found!"
@test binary_search_w(4, linspace(1, 100, 100), 1, 100)==4
@test binary_search_w(100, linspace(1, 100, 100), 1, 100)=="Not found!"
@test binary_search_w(99, linspace(1, 100, 100),1 , 100)==99


function midpoint(a, b)
  return floor((a + b) / 2)
end

function binary_search_w(query, seq, first, last)
  if first > last - 1
    error("Invalid input: empty range between bounds.")
  end
  if all([seq[ii] < seq[ii + 1] for ii in first : last - 2]) == false
    error("Sequence not sorted!")
  end

  if query < seq[first] || query > seq[last - 1]
    return "Not found!"
  end

  while first < last - 1
    imid = midpoint(first , last - 1)
    if seq[imid] < query
      first = imid + 1
    else last = imid + 1
    end
  end
  if first == last - 1 && seq[first] == query
    return first
  else
    return "Not found!"
  end
end
