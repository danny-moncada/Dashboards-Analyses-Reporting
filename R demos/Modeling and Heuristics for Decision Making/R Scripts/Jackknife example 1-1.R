#Jackkinfing pre-dates bootstrap by something like 20 years. It is a "leave one out cross-validation."
#The Jackknife estimate of bias is (n-1)(theta_hat_bar[i]- theta_hat) where theta_hat_bar[i] is 
#the mean of the leave  out estimates and theta_hat(x) is the estimate computed from the original example.
#It has been shown that the jackknife is a linear
#approximation to the bootstrap

#Here is how you leave one out :- )

x<- 1:5
x
for (i in 1:5){
  print(x[-i])
}
#Let's compute the bias of our heights data set.
US<- c(71,66,67,72,66,72,64,74,70,64,63,71,64,60,73)#Until we load our actual data *LOL*

#lets look a these
US

#Easy!!!!
n<- length(US)
n
theta.hat<- mean(US)
print(theta.hat)



theta.jack.hat<- numeric(n)#storage :- )
theta.jack.hat
#compute the Jackkinfe replicates, leave one out estimates
for(i in 1:n){
  theta.jack.hat[i]<- mean(US[-i])
}
theta.jack.hat
bias<- (n-1)*(mean(theta.jack.hat)-theta.hat)
print(bias)
#basically "it" ,Jack thinks this came from a sample 
#draw and Jack thinks it is underestimating the mean.
#Let's play with this some more before we fill in our data.

US[-1]
mean






x<- rnorm(19)#Let's check out this sample of 9 from N(0,1)
x

sd(x)# This should be 1.
n<- length(x)
n
theta.hat<- mean(x)# this is the mean of x and it should be 0.
print(theta.hat)



theta.jack.hat<- numeric(n)#storage :- )
theta.jack.hat
#compute the Jackkinfe replicates, leave one out estimates
for(i in i:n){
  theta.jack.hat[i]<- mean(x[-i])
}
theta.jack.hat
mean(theta.jack.hat)
bias<- (n-1)*(mean(theta.jack.hat)- theta.hat)
print(bias)

