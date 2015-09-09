## 36-750 homework 1

# trying to change the representation of game of life
# maintaining only a list of live cells, adding the
# game on hexagonal plane


using Distributions

# generating a list of vectors, which are the coordinates of live cells
A=[tuple(sample(-15:15,1)[1],sample(-15:15,1)[1]) for i=1:100]
print(A)

#print(A)

# function that checks whether a cell(given its coordinates) is alive currently
# it is a list of tuples
function check_stat(x,y,A)
  if (x,y) in A
    return 1
  else return 0
  end
end

#check_stat(8,-25,A)

# function that returns all neighbours of a cell given its
# input: x, y coordinate of cell, and geometry, "sq" for square grids
#        "hex" for hexagons
function get_neighbour(x,y,dim="sq")
  B=(setdiff([(i,j) for i=x-1:x+1, j=y-1:y+1],[(x,y)]))
  if dim=="sq"
    return B
  elseif dim=="hex"
    return(setdiff(B,[(x-1,y-1),(x-1,y+1)]))
  end
end


#print(get_neighbour(0,0,"sq"))

## cell evolution function for the game
function cell_evol(x,y,A)
  l=0
  for ii in get_neighbour(x,y)
    l=l+check_stat(ii[1],ii[2],A)
  end
  if check_stat(x,y,A)==1 && (l==2||l==3)
    return 1
  elseif check_stat(x,y,A)==0 && l==3
    return 1
  else return 0
  end
end

#print(cell_evol(0,2,A))


## map evolution function, iterating through all live cells and their neighbours
function map_evol(A,dim="sq")
  map=A
  res=[]
  for ii in A
    map=union(map,get_neighbour(ii[1],ii[2],dim))
  end
  for jj in map
    if cell_evol(jj[1],jj[2],A)==1
      res=[res,jj]
    end
  end
  return res
end

#print(map_evol(A,"hex"))

## takes in list of live cells and output the result of evolution after n generations
function gen_evol(A,n::Integer,dim="sq")
  for i in 1:n
    A=map_evol(A,dim)
  end
  A
end

#gen_evol(A,1)

## took 200 iterations from random starting point to visualize the game

A=[tuple(sample(-15:15,1)[1],sample(-15:15,1)[1]) for i=1:160]
writedlm("o0.txt",A)

for  ii in 1:200
  A=map_evol(A,"sq")
  writedlm("o"*string(ii)*".txt",A)
end
