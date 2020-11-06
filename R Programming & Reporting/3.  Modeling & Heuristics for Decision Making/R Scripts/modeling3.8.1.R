Assignment01 <- function(c) {
  n <- dim(c)[1]
  coef <- as.vector(t(c))
  rhs <- rep(1, 2*n)
  
  Amatrix <- matrix(0, 2*n, n*n)
  
  for (i in 1:n){
    for (j in 1:n){
      Amatrix[i, n*(i-1)+j] <-1
    }
  }
  
  for(i in 1:n){
    for(j in 1:n){
      Amatrix[n+i, n*(j-1)+i] <- 1
    }
  }

signs <- rep("==", 2*n)
var_type <- rep("B", 2*n)
library(Rglpk)

solution <- Rglpk_solve_LP(obj=coef, mat=Amatrix, dir=signs, types=var_type, rhs=rhs, max=TRUE)
return(solution)

}

set.seed(1)
c <- matrix(sample(10:100, 25), 5, 5)
c

solAss01 <- Assignment01(c)
m.01 <- matrix(solAss01$solution[1:25], 5, 5, byrow = TRUE)
m.01