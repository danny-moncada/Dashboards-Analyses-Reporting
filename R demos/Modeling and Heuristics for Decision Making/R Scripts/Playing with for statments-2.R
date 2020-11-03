#Playing with for statments whilst coding up matrices :- )
mat1<- matrix(0, nrow=7, ncol=7)
mat1
for(i in 1:7){
  mat1[i, 1]<- 1
}
mat1
mat2<- matrix(0, nrow=7, ncol=7)
mat2
for(i in 1:7){
  mat2[i, c(i)]<- 1
}
mat2
mat3<- matrix(0, nrow=7, ncol=7)
mat3
for(i in 1:7){
  mat3[i, c(i,i+1)]<- 1
}
mat3
#Note the i+ 1 is out of bounds at

mat3<- matrix(0, nrow=7, ncol=7)
mat3
for(i in 1:6){
  mat3[i, c(i,i+1)]<- 1
}
mat3
mat4<- matrix(0,nrow=10, ncol=10)
mat4
for(i in 1:2){
  mat4[i, c(i, i+1, i+2, i+3, i+4)]<- 1
}
mat4
mat5<- matrix(0,nrow=10, ncol=10)
mat5
for(i in 1:2){
  mat5[i, c(5*i-4, 5*i-3, 5*i-2, 5*i-1, 5*i)]<- 1
}
mat5

