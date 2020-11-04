library(Rglpk)

######## QUESTION 1

## [i] Develop a model and solve with R to prescribe the integer number of pilots to hire and fire each month to minimize total staffing
##      cost - salary, hiring, firing

rows = c('sini','sm1','sm2','sm3','sm4','sm5','sm6')

### Build the first matrix, with the number of hires
hires<- matrix(0, nrow=7, ncol=6)
for(i in 1:6){
  hires[i+1, c(i)]<- 1
}
colnames(hires) = c('h1','h2','h3','h4','h5','h6')
rownames(hires) = rows
hires_types <- rep("I", 6)

### Make sure my first matrix hires looks good
hires
hires_types

### Build the second matrix, with how many to fire each month
fires <- matrix(0, nrow=7, ncol=6)
for(i in 1:6){
  fires[i+1, i]<- -1
}

colnames(fires) = c('f1','f2','f3','f4','f5','f6')
rownames(fires) = rows
fires_types <- rep("I", 6)

## check the output to make sure fires/types looks good
fires
fires_types

### Build the third matrix, with the number of staff required
staff <- matrix(0,nrow=7, ncol=7)
for (i in 1:6){
  staff[1,1] <- 1
  staff[i+1, i+1]<- -1
}
for (i in 1:6){
  staff[i+1, i]<- 1
}
colnames(staff) = c('s0','s1','s2','s3','s4','s5','s6')
rownames(staff) = rows
staff_types <- rep("I", 7)
staff

##### build the entire constraint matrix by combining my three matrices above
constraint_matrix <- cbind(hires, fires, staff)
constraint_matrix

### Build the objective function that we want to minimize
obj_hires <- rep(5, 6)
obj_fires <- rep(10, 6)
obj_staff <- c(9, 7, 8, 6, 6, 9)

### Combine all my objective functions into one for solver
obj_func <- c(obj_hires, obj_fires, 0, obj_staff)
obj_func

#### This is my Right Hand Side - starts with 120 (for sini), zeros for the next five
rhs <- c(120, rep(0, 6))
rhs

#### Constraints direction - the first 7 rows are equal based on the parameters in objective function
constraints_direction <- c(rep("==", 7))
constraints_direction

#### We have to set the bounds for s1, s2, s3, s4, s5, s6
bounds <- list(lower = list(ind = c(14L, 15L, 16L, 17L, 18L, 19L), 
                            val = c(100, 110, 115, 140, 110, 200))
)

Rglpk_solve_LP(obj=obj_func, mat=constraint_matrix, dir=constraints_direction, rhs=rhs, bounds=bounds, types=types, max=FALSE)

# $optimum
# [1] 6710

# $solution
# [1]   0   0   5  25   0  60  10   0   0   0   0   0 120 110 110 115 140 140 200

## [ii] Develop a model and solve with R to prescribe the integer number of pilots to hire and fire each month with the new bounds

## I will use the same constraint matrix that was created above - I won't be needing binary variables since I found a different
## method to ensure that the first 120 pilots that were originally hired are in place - I will make s1, s2, s3 >= 120.
## This ensures that I have my original 120 pilots because they can't be fired in my solver.

##### build the entire constraint matrix by combining my three matrices
constraint_matrix <- cbind(hires, fires, staff)
constraint_matrix

### Build the objective function that we want to minimize - with updated values
## Hiring costs stay the same
## Firing costs are now lowered to $5
## Salary costs are also standardized to $7
obj_hires <- rep(5, 6)
obj_fires <- rep(5, 6)
obj_staff <- rep(7, 6)

### Combine all my objective functions into one for solver
obj_func <- c(obj_hires, obj_fires, 0, obj_staff)
obj_func

#### This is my Right Hand Side - starts with 20 (for sini), zeros for the next five
rhs <- c(120, rep(0, 6))
rhs

#### Constraints direction - the first 7 rows are equal based on the parameters in objective function
constraints_direction <- c(rep("==", 7))
constraints_direction

### We have to set the bounds for s1, s2, s3, s4, s5, s6
### I change the first three bounds so that we HAVE to have the original 120 pilots for the first three months
### The rest stay the same as the original problem
bounds <- list(lower = list(ind = c(14L, 15L, 16L, 17L, 18L, 19L), 
                            val = c(120, 120, 120, 140, 110, 200))
)

Rglpk_solve_LP(obj=obj_func, mat=constraint_matrix, dir=constraints_direction, rhs=rhs, bounds=bounds, types=types, max=FALSE)

# $optimum
# [1] 6280

# $solution
# [1]   0   0   0  20   0  60   0   0   0   0   0   0 120 120 120 120 140 140 200