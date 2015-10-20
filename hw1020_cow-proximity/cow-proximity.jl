# Throughout the problem I maintain a hashtable mapping breed IDs to their location
# with at most K key-value pairs.
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
    elseif length(keys(dict)) >= K
      delete!(dict, sort(collect(dict), by = tuple -> last(tuple))[1][1])
    end
    dict[cow_list[ii]] = ii
  end
  return max_id
end

# Turns out I need to search through the dictionary in each iteration after the
# list is 'full'. This method takes up less space but is awfully inefficient.
# Revised solution below.


# Maintain a hashtable mapping a cow's breed ID to its location.
# It is always updated to reflect the location of the most recently seen
# cow of this breed. The max_id variable is updated if the appearance of
# this cow is seen twice within K distance.

function crowded_cows1(cow_list::Array, K::Integer)
  if length(cow_list) <= K
    throw(ArgumentError("Number of cows need to be bigger than K!"))
  end

  max_id = -1
  dict = [cow_list[1] => 1]
  for ii in 2:length(cow_list)
    if haskey(dict, cow_list[ii])
      if ii- dict[cow_list[ii]] <= K
        max_id = maximum([cow_list[ii], max_id])
      end
    end
    dict[cow_list[ii]] = ii
  end
  return max_id
end
