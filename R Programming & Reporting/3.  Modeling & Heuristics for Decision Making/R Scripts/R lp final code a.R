#install.packages("rmarkdown")

library(lpSolve)
f.obj<- c(5,0,0,3,0,2,1,
          0,5,3,0,2,1,0,
          0,5,0,3,0,2,1,
          3,0,5,0,2,1,0,
          0,1,0,2,5,0,3,
          3,0,2,5,0,0,1,
          0,2,0,0,5,3,1,
          5,0,3,1,0,2,0,
          3,0,5,0,1,2,0,
          0,0,0,5,3,1,2,
          3,0,5,0,0,1,2,
          1,0,5,3,0,2,0,
          1,0,2,0,0,3,5,
          1,0,2,5,0,3,0,
          5,0,3,0,2,1,0,
          1,2,0,0,0,3,5,
          1,0,0,5,0,3,2,
          2,0,1,0,3,5,0,
          5,1,3,2,0,0,0,
          5,0,3,1,0,2,0,
          0,5,1,3,0,0,2)
print(f.obj)
length(f.obj)
mat1<- matrix(0, nrow=21,ncol=length(f.obj))
mat1
dim(mat1)
for(i in 1:21){
  mat1[i, c(7*i-6, 7*i-5, 7*i-4, 7*i-3, 7*i-2, 7*i-1, 7*i)]<- 1
}
mat1

f.dir1<- rep("==", 21)
f.dir1

f.rhs1<- c(rep(2, 21))
f.rhs

mat2<- matrix(0, nrow=7, ncol= length(f.obj))
mat2
dim(mat2)
for(i in 1:7){
  mat2[i,c(i, i+7, i+14, i+21, i+28, i+35, i+42, i+49, i+56, i+63, i+70, i+77, i+84,
           i+91, i+98, i+105, i+112, i+119, i+126, i+133, i+140 )]<- 1
}
mat2
dim(mat2)

f.dir2<- rep(">=",7)
f.dir2
f.rhs2<- c(rep(2, 7))
f.rhs2

mat3<- matrix(0, nrow=7, ncol= length(f.obj))
mat3
dim(mat3)
for(i in 1:7){
  mat3[i,c(i, i+7, i+14, i+21, i+28, i+35, i+42, i+49, i+56, i+63, i+70, i+77, i+84,
           i+91, i+98, i+105, i+112, i+119, i+126, i+133, i+140 )]<- 1
}
mat3
dim(mat3)

f.dir3<- rep("<=",7)


f.rhs3<- c(rep(6, 7))
f.rhs3
#binding all constraints
f.con<- rbind(mat1, mat2, mat3)
f.rhs<- c(f.rhs1, f.rhs2, f.rhs3)
f.dir<- c(f.dir1, f.dir2, f.dir3)

answer<- lp("max", f.obj, f.con, f.dir, f.rhs, all.bin = TRUE)
answer