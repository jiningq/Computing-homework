## 36-750 Heomwork for Tuesday, Sep 29
## Jining Qin

# The function is trying to find the u row vectors in
# matrix X such that they are the closest to vector y
# in terms of L2 distance. It then ouputs a list containing
# the minimum L2 distance, the distance of the u vectors 
# from y and the row numbers of these vectors

library(testthat)
rm(list=ls())

find.it <- function(x, y, u)
{
	if( ncol( x) != length( y) ) stop("Dimension doesn't match.")
	if( u >= nrow(x) ) stop("U is too big.")
	k = c( rep(NA, u-1) , 1e6)
	j = rep(NA,u)
	d = 1e6
	for ( i in 1: nrow( x) )
	{  
		prod = crossprod(x[i, ], x[i, ] - 2 * y)
		d = min( prod, d, na.rm = T)
		if ( prod <= max(k, na.rm = T) || sum(is.na(k))!=0)
		{
			max.id = max( which.max( k ), which( is.na( k) )  ) 
			k[ max.id ] = prod
			j[ max.id ] = i
			j = j[ order(k) ]
			k = k[ order(k) ]
		}
	}
	k = k + y %*% y
	d = as.numeric(d + y %*% y) 
    return(list(d=d,k=k,j=j))
}

expect_error( find.it( diag( 3 ), 1:2, 1))
expect_error( find.it( diag( 3 ), 1:3, 4))
for ( ii in 1:50){
	x = matrix( rnorm(10000), 100, 100)
	y = rnorm( 100)
	u = sample( 5:25, 1)
	distance = apply(x, 1, function(t) (t-y)%*%(t-y))
	expect_equal( find.it(x,y,u)$k, head( sort( distance), u))
	expect_equal( find.it(x,y,u)$d, min(distance) )
	expect_equal( distance[find.it(x,y,u)$j], head( sort( distance), u))
}