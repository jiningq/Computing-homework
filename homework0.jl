# 36-750 Statistical Computing
# Homework 0
# Jining Qin
# jiningq

cd("dropbox/computing")
pwd()
# generating input
using Distributions


# generating random input
A=[rand(Binomial(1,0.2)) for i = 1:100, j = 1:100]

# creating the sample input
A=zeros(8,7)
A[1,2]=1
A[2,[1,3]]=1
A[2:4,6]=1
A[6,2:4]=1
A[5:7,3]=1
print(A)

# generating the text input file
writedlm("inputJL.txt",A)

function gen(i,j,p=0.5)
  if max(i,j)<65 && min(i,j)>35
    print("ah")
    return rand(Binomial(1,p))
  else return 0
  end
end

# cell evolution function
function cell_evol(A,i,j)
  # this function gives the outcome of one particular cell after one generation in Game of Life
  # given its coordinate and the whole input matrix
  alive=-A[i,j]
  for a in max(i-1,1):min(i+1,size(A,1))
    for b in max(j-1,1):min(j+1,size(A,2))
      alive=alive+A[a,b]
    end
  end
  if A[i,j]==1 && (alive==2||alive==3)
    return 1
  elseif A[i,j]==0 && alive==3
    return 1
  else return 0
  end
end




function map_evol(A::Array)
  # this function gives the outcome of Game of Life after one generation from the given matrix input
  B=zeros(size(A))
  for i in 1:size(A,1)
    for j in 1:size(A,2)
      B[i,j]=cell_evol(A,i,j)
    end
  end
  B
end

function gen_evol(file::ASCIIString,n::Integer)
  # this function takes in name of the file in working directory (named "inputJl.txt" in our case) and the number of generations n
  # and output the outcome of Game of Life starting from the state specified in the file after n generations
  A=int(readdlm(file))
  for i in 1:n
    A=map_evol(A)
  end
  A
end


A=[gen(i,j) for i = 1:100, j = 1:100]
writedlm("o0.txt",A)
for  ii in 1:100
  A=gen_evol("inputJl.txt",ii)
  writedlm("o"*string(ii)*".txt",A)
end

# you can substitute the input text file name to any other input file name


pwd()

"a"*string(12)*"b"
