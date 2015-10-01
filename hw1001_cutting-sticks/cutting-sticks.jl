## 36-750
## Homework for Oct 1
## Jining Qin

# Cutting stick

using Base.Test

## It seems Julia doesn't have the syntax supporting subsetting like vector[-i]
## so I implemented it naively myself
function exclude_i(vector, i)
  if i == 1
    return vector[2 : end]
  elseif i == length(vector)
    return vector[1 : end - 1]
  else
    return vector[[1 : i-1, i + 1 : end]]
  end
end


## best cuts helper function using dynamic programming
## takes the stick length and cut points as input and
## outputs the minimum cost and the order of cutting
function best_cuts_h(stick_length, cuts)
  @assert stick_length > 0 "Negative stick length"
  @assert maximum(cuts) <= stick_length "Cut point over stick length"
  @assert length(cuts) == 1 || all([ cuts[i] < cuts[i + 1] for i = 1 : length(cuts) - 1 ]) "Cut points not sorted"
  if length(cuts) == 1
    return (stick_length, cuts)
  else
    cuts_ext=[0, cuts, stick_length]
    cost = [best_cuts_h(stick_length, exclude_i(cuts, i))[1] + cuts_ext[i + 2] - cuts_ext[i]
            for i = 1 : length(cuts)]
    min_id = findmin(cost)[2]
    return (minimum(cost), [ best_cuts_h(stick_length,exclude_i(cuts, min_id))[2], cuts[min_id]])
  end
end

