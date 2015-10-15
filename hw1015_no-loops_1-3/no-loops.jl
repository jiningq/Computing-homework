using Base.Test

# 1.
function listsum(list::Array)
  reduce(+, list)
end

@test listsum(linspace(1,10,10)) == 55


# 2.

function get_preceding_neg(list::Array)
  [ii for ii in list[find(list[1:end-1] .< 0) .+ 1] ]
end

@test get_preceding_neg([-1,1,2,-2,-3,3,-4,4,5]) == [1, -3, 3, 4]

# 3.
# I was using the fact that matrix multiplication isn't commutative.
# I mapped each left delimiter to a 2 by 2 integer matrix and its right
# counterpart to its inverse ( not integer). If there is order problem,
# then the product of the corresponding matrix array (from 1 to i) would be
# non-integer at one point. And if no order problem exists, the product of
# the whole matrix array is identity only if the nesting is legal.


function check_nesting(string::String)
  dict = [ "(" => [1 2; 0 2], "[" => [1 3; 0 3], "{" => [1 5; 0 5],
          ")" => inv([1 2; 0 2]), "]" => inv([1 3; 0 3]), "}" => inv([1 5; 0 5]) ]
  delim = filter( x -> haskey(dict, x), split(string,""))
  if length(delim) == 0
    return true
  else
    delim_n = [dict[ii] for ii in delim]
    prod_n = [reduce(*, delim_n[1:ii]) for ii in 1:length(delim)]
    return all([sum(Pn .% 1)==0 for Pn in prod_n]) == true && reduce(*, delim_n) == eye(2)
  end
end



@test check_nesting("a") == true
@test check_nesting("[(a)]{[b]}") == true
@test check_nesting("{a}[(b])") == false
@test check_nesting("][][") == false
println("All tests passed for task 1-3!")

# commandline testing
## $ PATH="/Applications/Julia-0.3.7.app/Contents/Resources/julia/bin:$PATH"
## $ julia no-loops.jl
