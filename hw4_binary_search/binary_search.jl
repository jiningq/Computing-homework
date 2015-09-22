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
@test binary_search_w(1,[-1,0,1],1,3)=="Not found!"
@test binary_search_w(4,[1,2,3,5,6],1,6)=="Not found!"
@test binary_search_w(2,[1,2],1,3)==2
@test binary_search_w(2,[1,2],1,2)=="Not found!"
@test binary_search_w(4,linspace(1,100,100),1,100)==4
@test binary_search_w(100,linspace(1,100,100),1,100)=="Not found!"
@test binary_search_w(99,linspace(1,100,100),1,100)==99


function midpoint(a,b)
  return floor((a+b)/2)
end

function binary_search_w(key, A, imin, imax)
  if imin>imax-1
    error("Invalid input: empty range between bounds.")
  end
  if all([A[ii]<A[ii+1] for ii in imin:imax-2])==false
    error("Sequence not sorted!")
  end

  if key < A[imin] || key > A[imax-1]
    return "Not found!"
  end

  while imin<imax-1
    imid=midpoint(imin,imax-1)
    if A[imid]<key
      imin=imid+1
    else imax=imid+1
    end
  end
  if imin==imax-1 && A[imin]==key
    return imin
  else
    return "Not found!"
  end
end
