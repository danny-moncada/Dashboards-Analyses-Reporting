## Part 2:
### CREATE THE CONSTRAINT MATRIX, MUCH FASTER TO DO IT PROGRAMMATICALLY
### 

### Here are my rows 
rows = c('sini','sm1','sm2','sm3','sm4','sm5','sm6',
         'hf1','hf2','hf3','fh4','hf5','hf6','hf7','hf8','hf9','hf10')

### Build the first matrix, with the number of hires - base this off of my CPLEX matrix
hires<- matrix(0, nrow=17, ncol=6)
for(i in 1:6){
  hires[i+1, c(i)]<- 1
}
for(i in 1:5){
  hires[i+7, c(i)]<- 1
}

colnames(hires) = c('h1','h2','h3','h4','h5','h6')
rownames(hires) = rows
hires_types <- rep("I", 6)

### Make sure my first matrix hires looks good
hires
hires_types

fires <- matrix(0, nrow=17, ncol=6)
for(i in 1:6){
  fires[i+1, i]<- -1
  fires[i+12, i+1] <-1
}

colnames(fires) = c('f1','f2','f3','f4','f5','f6')
rownames(fires) = rows
fires_types <- rep("I", 6)

## check the output to make sure fires/types looks good
fires
fires_types


### Build the third matrix, with the number of staff required - base this off of my CPLEX matrix
staff <- matrix(0,nrow=17, ncol=7)
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

## check the output to make sure fires/types looks good
staff
staff_types

### Build the fourth matrix, for the binary var required - base this off of my CPLEX matrix
binary_var <- matrix(0,nrow=17, ncol=5)
for (i in 1:6){
  binary_var[i+7, c(i)] <- -1000
  binary_var[i+12, c(i)] <- 1000
}

colnames(binary_var) = c('b1','b2','b3','b4','b5')
rownames(binary_var) = rows
bin_types <- rep("B", 5)

### print out the binary matrix and binary types to confirm
binary_var
bin_types

##### build the entire constraint matrix by combining my four matrices above
constraint_matrix <- cbind(hires, fires, staff, binary_var)
constraint_matrix

### Build the objective function based on CPLEX code
obj_hires <- rep(5, 6)
obj_fires <- rep(10, 6)
obj_staff <- rep(8, 6)
obj_binary <- rep(0, 5)

### Combine all my objective functions into one for solver
obj_func <- c(obj_hires, obj_fires, 0, obj_staff, obj_binary)
obj_func

#### This is my Right Hand Side - starts with 20 (for sini), zeros for the next five, 1000 for the last set of rows
rhs <- c(20, rep(0, 11), rep(1000, 5))
rhs

#### Constraints direction - the first 7 rows are equal based on the parameters in objective function
constraints_direction <- c(rep("==", 7), rep("<=", 10))
constraints_direction

### Combine all my types into one output at the end for the Solver
types <- c(hires_types, fires_types, staff_types, bin_types)
types

#### Here is the missing link to this entire equation. We have to set the bounds for s1, s2, s3, s4, s5, s6
#### These were never set in the matrix in CPLEX, hence my output being incorrect
bounds <- list(lower = list(ind = c(14L, 15L, 16L, 17L, 18L, 19L), 
                            val = c(30,60,55,40,45,50))
)

Rglpk_solve_LP(obj=obj_func, mat=constraint_matrix, dir=constraints_direction, rhs=rhs, bounds=bounds, types=types, max=FALSE)

#Mth0----1----2----3----4----5----6
### 20 - 30 - 60 - 60 - 45 - 45 - 50
## Hire 10 in the first month, 30 in the second month, zero in third, fourth, fifth, and 5 at the end
## Fire 15 in the fourth month