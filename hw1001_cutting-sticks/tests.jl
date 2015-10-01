# tests for cutting stick problem
# Jining Qin

# the final best_cuts function only takes the first output of the helper function
best_cuts(stick_length, cuts) = best_cuts_h(stick_length, cuts)[2]

# haven't figured out how to test assertion error in Julia yet
# so did this part naively

best_cuts(-1, [2])
# gives message "negative stick length"

best_cuts(10, [3, 2])
# gives message "cut points not sorted"

best_cuts(10, [2, 11])
# gives message "cut points over stick length"



function best_cuts_tests()
  @test best_cuts(10, [2]) == [2]
  @test best_cuts(10, [2, 5]) == [5, 2]
  @test best_cuts(10, [2, 4, 7]) == [4, 7, 2]
  @test best_cuts_h(10, [2, 4, 7])[1] == 20
end


# I'm not exactly sure what you meant by 'run from command line'
# Please let me know if I got it wrong
best_cuts_tests()

