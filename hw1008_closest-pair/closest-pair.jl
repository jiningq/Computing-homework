## 36-750 Homework for Oct 9
## Jining Qin

using Distances

## Ideally we want to output all pairs of points that achieves the minimum distance, which
## is why we should try to combine optima from different subproblems such that if they have
## the same minimum distance, the point pairs from both solutions should be retained.

## the following function combines solutions from three subproblems (left half, right half, and split pairs)
## in such way.

function optim_merge(d1, d2, d3)
  @assert minimum([length(d1), length(d2), length(d3)]) == 2
  @assert maximum([length(d1), length(d2), length(d3)]) == 2
  min_d = minimum([d1[1], d2[1], d3[1]])
  if (sum([d1[1], d2[1], d3[1]] .== min_d) == 1)
    min_id = findmin([d1[1], d2[1], d3[1]])[2]
    return [d1, d2, d3][min_id]
  else
    best_pair = []
    for dd in [d1, d2, d3][ [d1[1], d2[1], d3[1]] .== min_d]
      best_pair = [best_pair, dd[2]]
    end
    return (min_d, unique(best_pair))
  end
end


## the function takes two vectors, the x-coordinates of points and y-coordinates of points as input
## the function outputs a tuple, the first element being the minumum distance
## the second element is a vector of points pairs, each being a tuple consisting of two vector
## I defined the ClosestSplitPair function insie the ClosestPair function since Julia uses lexical scoping
## and I need the variables defined within function ClosestPair


function ClosestPair(X, Y)
  if length(X) != length(Y)
    throw(ArgumentError("X Y coordinate vectors not of same length!"))
  end

  Px = float(X)
  Py = float(Y)

  order_y = sortperm(Py)
  order_x = sortperm(Px)

  function ClosestSplitPair(Px:: Array{Float64, 1}, Py:: Array{Float64, 1}, delta::Float64, med_id:: Integer)
    Sy_id = order_y[ (Px .>= Px[order_x[med_id]] - delta) & (Px .<= Px[order_x[med_id]] + delta) ]
    best = Inf
    best_pair = []
    if length(Sy_id) > 7
      ceil_i = length(Sy_id) - 7
    else
      ceil_i = length(Sy_id) - 1
    end
    for i in 1 : ceil_i
      for j in 1 : minimum([7, length(Sy_id)-i])
        p = [Px[Sy_id[i]], Py[Sy_id[i]]]
        q = [Px[Sy_id[i + j]], Py[Sy_id[i + j]]]
        if euclidean(p, q) <= delta
          best_pair = [best_pair, (p, q)]
          best = euclidean(p, q)
        end
      end
    end
    return (best, best_pair)
  end

  if length(Px) == 1
    return (Inf, [([0, 0], [0, 0])])
  elseif length(Px) == 2
    return (euclidean([Px[1], Py[1]],[Px[2], Py[2]]), [([Px[1], Py[1]], [Px[2], Py[2]])])
  else
    med_id = integer(floor(length(Px) / 2))
    d1 = ClosestPair(Px[order_x[1 : med_id]],
                      Py[order_x[1 : med_id]])
    d2 = ClosestPair(Px[order_x[(med_id + 1) : end]],
                      Py[order_x[(med_id + 1) : end]])
    d3 = ClosestSplitPair(Px, Py, minimum([d1[1], d2[1]]), med_id)
    return optim_merge(d1,d2,d3)
  end
end


function print_res(result)
  println(string("Minimum distance: ", result[1]))
  println("Closest Pairs:")
  for i in result[2]
    println(i)
  end
end

