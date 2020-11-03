##install.packages("boot")
library(boot)#To get boot and boot.ci
x<- rnorm(100000,72,3)#Creating 100,000 samples from N(72,3)
#After this lets load our heights in to x for the data.
data<-sample(x,10,replace = F)#Choosing 10 of 100,000 for our data sample. 
#We will experiment with lowering the number :- )
data#I've always got to see *LOL*
mean(data)#Should be 72.

sd(data)#Should be 3.
mu.boot<- function(data,i){
  #Create a function to compute the statistic.

  y<- data[i]#For every i between 1 and 2000 this will create a bootstrap of 10 from our data.
  #coded up by the boot.obj.
  mean(y)#This makes the mean.
  
  
  
  
}
mu
boot.obj<- boot(data, statistic = mu.boot, R= 2000)


print(boot.obj)

print(boot.ci(boot.obj, type =  c("basic", "norm", "perc", "bca")))

#Let's see it another way.

  
  

#Bootstrap estimate of mean and 95% C.I
mu<- replicate(2000, expr= {
  k<- sample(data,size = 10, replace = T)
  
      mean(k) })
print(mean(mu))


sd(mu)
quantile(mu, .05)
quantile(mu, .95)
CI<- c(mean(mu)-1.96*sd(mu), mean(mu)+ 1.96*sd(mu))#Note you don't divide the sd/sqrt(n)
#becaues when you do a bootstrap you are drawing with replacement 
#and the R.V. are not iid :- )
CI
hist(mu)

