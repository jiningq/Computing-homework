library(plotrix)

read_paren=function(string){
	eval(parse(text=paste("c",string,sep="")))
}


read_list=function(n){
	t(sapply(read.table(paste("o",n,".txt",sep=""),stringsAsFactors=F)[,1],read_paren))
}



vec_scan=function(x,y,A){
	return(max(apply(A,1,function(l){return(all(l==c(x,y)))})))
}



plot_rect=function(x,y,fill=F){
	if(fill==F){
		rect(x-0.5,y-0.5,x+0.5,y+0.5)}
	if(fill==T){
		rect(x-0.5,y-0.5,x+0.5,y+0.5,col="black")
	}
}

plot(1:10,1:10,type="n")
plot_rect(2,4,vec_scan(2,4,A))

drawit=function(x)
{
	print(x)
	A=read_list(x)
	plot((min(A)-1):(max(A)+1),(min(A)-1):(max(A)+1),type="n")
	for ( i in min(A):max(A)){
		for ( j in min(A):max(A)){
			plot_rect(i,j,vec_scan(i,j,A))
		}
	}
}




finaldraw=function(a=1,b=100){
		for (i in 1:10)
		print(drawit(a))
	for (i in a:b)
		print(drawit(i))
	for (i in 1:10)
		print(drawit(b))
}

require(animation)

#sett ffmpeg in Windows = =||
oopts = ani.options(ffmpeg =  "/Users/jiningqin/Dropbox/ffmpeg/ffmpeg")

#Use the function from animation to make the final movie
a=proc.time()
saveVideo({
    finaldraw(0,200)
	ani.options(interval = 0.1, nmax = 230)
}, video.name = "2.mp4", other.opts = "-b 500k")
proc.time()-a



plot_hex=function(x,y,fill=F){
	if(fill==F){
		polygon(x+c(-sqrt(3)/2,-sqrt(3)/2,0,sqrt(3)/2,sqrt(3)/2,0),y+c(-0.5,0.5,1,0.5,-0.5,-1),angle=45)
	}
	if(fill==T){
		polygon(x+c(-sqrt(3)/2,-sqrt(3)/2,0,sqrt(3)/2,sqrt(3)/2,0),y+c(-0.5,0.5,1,0.5,-0.5,-1),density=30,angle=45)
	}
}

drawit=function(x)
{
	print(x)
	A=read_list(x)
	plot(round(sqrt(3)*(min(A)-1)):round(sqrt(3)*(max(A)-1)),round(sqrt(3)*(min(A)-1)):round(sqrt(3)*(max(A)-1)),type="n")
	for ( i in min(A):max(A)){
		for ( j in min(A):max(A)){
			if(j%%2==1){plot_hex(sqrt(3)*i+sqrt(3)/2,1.5*j,vec_scan(i,j,A))}else{plot_hex(sqrt(3)*i,1.5*j,vec_scan(i,j,A))}
		}
	}
}
drawit(2)