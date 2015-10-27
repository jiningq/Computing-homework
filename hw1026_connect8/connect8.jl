using DataStructures
using DataFrames

# found the following function for locating matrix indices given predicate function from
# http://stackoverflow.com/questions/26196733/julia-find-in-matrix-with-row-col-instead-of-index
# use this function to identify indices of matrix cells that is above the threshold
function findmat(f, A::AbstractMatrix)
  m,n = size(A)
  out = (Int,Int)[]
  for i in 1:m, j in 1:n
    f(A[i,j]) && push!(out,(i,j))
  end
  out
end

# the neighbourhood argument is a function which given the index of a matrix cell and
# the size of the matrix, returns its neighbour under the specified neighbouring rule
function getNeighbour8(index, size)
  list = []
  for i in max(index[1] - 1, 1): min(index[1] + 1, size[2])
    for j in max(index[2] - 1, 1): min(index[2] + 1, size[1])
      list = [list, (i,j)]
    end
  end
  deleteat!(list, find(list .== index))
  list
end


# implementing the 'one component at a time' algorithm in wikipedia page for
# connected-component labeling
# https://en.wikipedia.org/wiki/Connected-component_labeling#One_component_at_a_time
# Go through pixels above the threshold in the following way:
#  Set current label to 1
#  If the pixel isn't labeled already, label it with the current label. Put the pixel into a queue.
#  Dequeue an element from the queue, get its neighbours, if its above the threshold and
#     not labeled, label with current label, put its neighbours into the queue.
#  Increment the current label by 1.

# Recursive element in the algorithm is that we are looking at neighbour of a pixel, then
# neighbour of neighbour, then neighbour of neighbour of neighbour and so on.

function findContiguousClumps(image, thres, connectRule = getNeighbour8)
  curLab = 1
  pointLab = Dict()
  pointList = findmat(x -> x > thres, image)
  pointQueue = Queue((Int,Int))

  for ii in pointList
    if !haskey(pointLab, ii)
      pointLab[ii] = curLab
      enqueue!(pointQueue, ii)
      while length(pointQueue) > 0
        jj = dequeue!(pointQueue)
        for kk in intersect(getNeighbour8(jj, size(image)), pointList)
          if !haskey(pointLab, kk)
            enqueue!(pointQueue, kk)
            pointLab[kk] = curLab
          end
        end
      end
      curLab = curLab + 1
    end
  end

  n = length(keys(pointLab))
  result = DataFrame(x_pixel = int(zeros(n)), y_pixel = int(zeros(n)), clump_id = int(zeros(n)))

  ii = 0
  for key in keys(pointLab)
    ii = ii + 1
    result[ii, :] = convert(DataFrame, [key[1] key[2] pointLab[key]])
  end
  return result
end

test = reshape(readdlm("connect8.txt"), 20, 20)

df1 = findContiguousClumps(test, 0.5)
maximum(df1[:clump_id])
# 1
# i.e. at 0.5 threshold level, there is only one connected component
# consisting of 91 pixels

print(df1)
# 91x3 DataFrame
# | Row | x_pixel | y_pixel | clump_id |
# |-----|---------|---------|----------|
# | 1   | 10      | 5       | 1        |
# | 2   | 6       | 9       | 1        |
# | 3   | 9       | 4       | 1        |
# | 4   | 8       | 9       | 1        |
# | 5   | 8       | 11      | 1        |
# | 6   | 10      | 14      | 1        |
# | 7   | 7       | 16      | 1        |
# | 8   | 9       | 9       | 1        |
# ⋮
# | 83  | 7       | 3       | 1        |
# | 84  | 5       | 11      | 1        |
# | 85  | 9       | 11      | 1        |
# | 86  | 10      | 3       | 1        |
# | 87  | 6       | 14      | 1        |
# | 88  | 6       | 15      | 1        |
# | 89  | 7       | 14      | 1        |
# | 90  | 8       | 10      | 1        |
# | 91  | 9       | 5       | 1        |

df2 = findContiguousClumps(test, 0.8)
maximum(df2[:clump_id])
# 2
# i.e. under 0.8 threshold level, there are 2 connected components

print(by(df2, :clump_id, nrow))
# 2x2 DataFrame
# | Row | clump_id | x1 |
# |-----|----------|----|
# | 1   | 1        | 13 |
# | 2   | 2        | 17 |
# 13 pixels are in the first component and 17 are in the second

print(df2)
# 30x3 DataFrame
# | Row | x_pixel | y_pixel | clump_id |
# |-----|---------|---------|----------|
# | 1   | 9       | 6       | 1        |
# | 2   | 9       | 7       | 1        |
# | 3   | 6       | 13      | 2        |
# | 4   | 8       | 12      | 2        |
# | 5   | 7       | 13      | 2        |
# | 6   | 8       | 6       | 1        |
# | 7   | 9       | 13      | 2        |
# | 8   | 6       | 12      | 2        |
# ⋮
# | 22  | 7       | 7       | 1        |
# | 23  | 8       | 14      | 2        |
# | 24  | 6       | 14      | 2        |
# | 25  | 9       | 14      | 2        |
# | 26  | 6       | 6       | 1        |
# | 27  | 7       | 14      | 2        |
# | 28  | 6       | 11      | 2        |
# | 29  | 7       | 12      | 2        |
# | 30  | 9       | 5       | 1        |

image = [0 1 2; 0 0 1; 1 0 0]
print(findContiguousClumps(image, 0.5))
# 4x3 DataFrame
# | Row | x_pixel | y_pixel | clump_id |
# |-----|---------|---------|----------|
# | 1   | 1       | 2       | 1        |
# | 2   | 2       | 3       | 1        |
# | 3   | 3       | 1       | 2        |
# | 4   | 1       | 3       | 1        |

# function gives the expected outcome on the sample input



