## create the coefficient matrix - to mimic problem #3.8 Assignment maximizing minimal quality

r1 = c(34,87,26,47,76)
r2 = c(43,90,24,63,97)
r3 = c(60,65,64,83,54)
r4 = c(89,62,39,37,18)
r5 = c(27,15,69,93,96)
c <- rbind(r1, r2, r3, r4, r5)
c
## get the number of rows of matrix
n <- dim(c)[1]
n

## convert my matrix into coefs to solve for maximizing
coef <- as.vector(t(c))
coef

## since this is a binary problem, each row AND column must equal 1
rhs <- rep(1, 2*n)
rhs

## create an empty matrix that is 10 x 5, this will allow for getting the right
## values at the end
ones_matrix <- matrix(0, 2*n, n*n)
ones_matrix

## populate 1s in every row 
for (i in 1:n){
  for (j in 1:n){
    ones_matrix[i, n*(i-1)+j] <-1
    }
  }

## populate 1s in every column 
for(i in 1:n){
  for(j in 1:n){
    ones_matrix[n+i, n*(j-1)+i] <- 1
    }
  }

## print the identity matrix at the end to confirm 1s were populated in the right spots
ones_matrix

## each row and column MUST equal 1, since only one course can be assigned to one teacher
## and each course is only taught by one teacher
signs <- rep("==", 2*n)
signs

## variable type is "binary" for all of them, because we can only assign 1 to 1 course,
## and zeros for all other.
var_type <- rep("B", 2*n)
var_type

## pull in Rglpk to solve this piece
library(Rglpk)

## perform the calculation based on the criteria above
final_output <- Rglpk_solve_LP(obj=coef, mat=ones_matrix, dir=signs, types=var_type, rhs=rhs, max=TRUE)
final_output

## get the final matrix output to display the solution
m.01 <- matrix(final_output$solution[1:25], 5, 5, byrow = TRUE)
m.01