library(ggplot2)
library(reshape2)
# generating a random input

A=matrix(rbinom(100,1,0.3),10,10)


# generating the example input
A=matrix(0,8,7)
A[1,2]=1
A[2,c(1,3)]=1
A[2:4,6]=1
A[6,2:4]=1
A[5:7,3]=1
write.table(A,'input.txt')

# function for evolution of each cell

evolve.cell=function(A,i,j){
	alive=0
	for ( a in max(i-1,1):min(i+1,nrow(A))){
		for ( b in max(j-1,1):min(j+1,ncol(A))){
			alive=alive+A[a,b]
		}
	}
	alive=alive-A[i,j]
	if ( A[i,j]==0 & alive==3){return(1)}
	if ( A[i,j]==1 & (alive==2|alive==3)){return(1)}
	else{return(0)}
}

# function for whole map evolution after one generation

evolve.map=function(A){
	B=matrix(NA,nrow(A),ncol(A))
	for ( i in 1:nrow(A)){
		for (j in 1:ncol(A)){
			B[i,j]=evolve.cell(A,i,j)
		}
	}
	B
}

#evolve.map(A)

# function that takes in text file and number of generations and gives the state after specified generations

evolve.gen=function(file,n){
	A=read.table(file)
	for ( i in 1:n){
		A=evolve.map(A)
	}
	A
}


A=matrix(rbinom(100,1,0.7),10,10)
write.table(A,'input.txt')
evolve.gen('input.txt',50)
grid_to_ggplot <- function(grid) {
  # Permutes the matrix so that melt labels this correctly.
  colnames(grid)=rownames(grid)
  grid$y=rownames(grid)
  grid <- melt(grid,variable.name="x")
  grid$value <- factor(ifelse(grid$value, "Alive", "Dead"))
  p <- ggplot(grid, aes(x=x, y=y, z = value, color = value))
  p <- p + geom_tile(aes(fill = value))
  p  + scale_fill_manual(values = c("Dead" = "white", "Alive" = "black"))
}

drawit=function(x)
{
	grid=read.table(paste("o",x,".txt",sep=""))
	p=grid_to_ggplot(grid)
}

finaldraw=function(a=1,b=100){
		for (i in 1:10)
		print(drawit(a))
	for (i in a:b)
		print(drawit(i))
	for (i in 1:10)
		print(drawit(b))
}

#finaldraw(1800,2009)


require(animation)

#sett ffmpeg in Windows = =||
oopts = ani.options(ffmpeg =  "/Users/jiningqin/Dropbox/ffmpeg/ffmpeg")

#Use the function from animation to make the final movie
saveVideo({
    finaldraw(0,100)
	ani.options(interval = 0.1, nmax = 230)
}, video.name = "1.mp4", other.opts = "-b 500k")