## 36-750 Homework 3
## Test this #1
## Jining Qin

# Unit test for function findInterval

@test findInterval(mean(intervals[ end-1 : end ]), intervals) == (length(intervals)-1)
@test findInterval(intervals[ 1 ], intervals) == 1
@test findInterval(intervals[ 1 ] - 0.5, intervals) == 0
@test findInterval(intervals[end], intervals) == length(intervals)
@test findInterval(intervals[end] + 1, intervals) == length(intervals)