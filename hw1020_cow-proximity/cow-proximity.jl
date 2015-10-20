using Base.Test

# Throughout the problem I maintain a hashtable mapping with at most K key-value pairs.
# With each new now coming in, if its breed id is a key of the hashtable, then
# it is within K of the last cow of the same breed. If its breed id isn't a key,
# then either the hashtable isn't full (has K pairs) and this cow and its location is
# inserted, or the hashtable is full and this cow is put in and the cow K locations
# before it is thrown out from the hashtable.

function crowded_cows(cow_list::Array, K::Integer)
  if length(cow_list) <= K
    throw(ArgumentError("Number of cows need to be bigger than K!"))
  end

  max_id = -1
  dict = [cow_list[1] => 1]
  for ii in 2:length(cow_list)
    if haskey(dict, cow_list[ii])
      max_id = maximum([cow_list[ii], max_id])
      delete!(dict, cow_list[ii])
      dict[cow_list[ii]] = ii
    elseif length(keys(dict)) < K
      dict[cow_list[ii]] = ii
    else
      dict[cow_list[ii]] = ii
      delete!(dict, cow_list[ii-K])
end
  end
  return max_id
end


@test_throws ArgumentError crowded_cows([7,3,4,2,3,10,4], 10)
@test crowded_cows([7,3,4,2,3,10,4], 3) == 3
@test crowded_cows([7,3,4,2,3,4], 3) == 4
@test crowded_cows([7,3,1,0,4,2,16,28,3,4],3) == -1


cows = int(readdlm("cows.txt"))
@elapsed crowded_cows(cows, 25000)
# The maximm breed id of a pair of crowded cows is 999893.
# It takes Julia within 0.1 second to get this result.

