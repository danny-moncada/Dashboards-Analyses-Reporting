library(Rglpk)

mat1<- matrix(0,nrow=17, ncol=6)
mat1
for(i in 1:7){
  mat1[i+1, c(i)]<- 1
}
for(i in 1:5){
  mat1[i+7, c(i)]<- 1
}
mat1

mat2 <- matrix(0,nrow=17, ncol=6)
for(i in 1:6){
  mat2[i+1, c(i)]<- -1
  mat2[i+12, c(i+1)] <- 1
}
mat2

mat3 <- matrix(0,nrow=17, ncol=6)
for (i in 1:6){
  mat3[i+1, c(i)]<- -1
  mat3[i+1, c(i-1)]<- 1
}
mat3

mat4 <- matrix(0,nrow=17, ncol=6)
mat4[1, 1] <- 1
mat4[2, 1] <- 1
for (i in 2:6){
  mat4[i+6, c(i)] <- -1000
  mat4[i+11, c(i)] <- 1000
}
mat4

A <- cbind(mat1, mat2, mat3, mat4)
A

h1 <- rep(5, 6)
f1 <- rep(10, 6)
s1 <- rep(8, 6)
b1 <- rep(0, 6)

C <- c(h1, f1, s1, b1)
C

B <- c(20, rep(0, 11), rep(1000, 5))
B

constraints_direction <- c(rep("==", 7), rep("<=", 10))
constraints_direction

types= c(rep("I", 17*18), rep("B", 17*6))
types

sol <- Rglpk_solve_LP(obj=C, mat=A, dir=constraints_direction, rhs=B, types=types, max=FALSE)

matrix(sol$solution[1:(18*18)], 18, 18, byrow=TRUE)
