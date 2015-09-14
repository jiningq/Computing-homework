## 36-750 Statistical computing
## Jining Qin

## HW 2

# maximum subarray problem

## I implement Kadane's algorithm here, keeping track of a current maximum
## and a global maximum, the task is done within one linear scan of the whole
## array.
## Time complexity : O(n), space complexity: O(1)
## Informal test was written for several cases and the function passed.


using Base.Test

function maxSubSum(x)
  current_max=global_max=0
  for ii in x
    current_max=max(0,current_max+ii)
    global_max=max(current_max,global_max)
  end
  return global_max
end


@test maxSubSum([1,2,3,4])==10
@test maxSubSum([-1,-2,-3,-4])==0
@test maxSubSum([-1,1,-1,1,-1,1,-1,1])==1
@test maxSubSum([31,-41,59,26,-53,58,97,-93,-23,84])==187
@test maxSubSum([1.2,2.4,-3.6,4.8,6.0,-2.0,7.2,-9.6])==16.0

