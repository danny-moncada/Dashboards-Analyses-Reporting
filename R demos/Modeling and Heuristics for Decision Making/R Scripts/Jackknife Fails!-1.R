#When Jackknife goes WRONG! You get F!  I mean, F-! Ha!
n<- 10
x<- sample(1:100, size = 10)#We're picking 10 numbers at suedo-random from 1 - 100
#x<-c(29, 79, 41,86,91,5,50,83,51,42) We'll just this next :- )
mean(x)
median(x)
sd(x)
hist(x)
#Jackknife estimate of standard error
M<- numeric(n)#Creating a storage vector.
M
for(i in 1:10){
  y<- x[-i]#This leaves the i^th component of x out.
  M[i]<- median(y)
}
M #Here are the Jackknife medians.

Mbar<- mean(M)
Mbar
Jackknife_se <-print(sqrt((n-1)/n*sum((M - Mbar)^2)))#This is the Jackknife standard error.
sd(M)#Notice that the Jackknife standard error and 
#the standard deviation of the set M of Jackknifed sets are very different.

#Jackknife will often under estimate the standard error of the median 
#because "median" is not a smooth function. This is accordig to Maria Rizzo in 
#Statistical Computing in R.  The "new" x<- is from their example.
#####################################################################################3

#Now let's look at a bootstap standard error estimate.
B<-1000
Mb<-replicate(B, expr = {#expr = is the expression of interest.
  y<- sample(x, size=n,replace=T)
  median(y) })
Mb
Mb_bar<-mean(Mb)
Mb_bar
Bootstrap_se <-print(sqrt(1/(B-1)*sum((Mb - Mb_bar)^2)))
sd(Mb)
#Notice that the bootstrap standard error is the same as the standard deviation.....Why? *LOL*
#Hint: Look at the formula :- )

Jackknife_se
#Notice the difference between these two estimates. 
#In all of the random examples I ran Jackknife actually over estimated the standard error -
#except for Rizzo's specific example :- ) ???

