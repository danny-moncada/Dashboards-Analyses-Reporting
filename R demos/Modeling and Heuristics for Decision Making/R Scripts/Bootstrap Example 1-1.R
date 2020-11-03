#An example population
Population<- rnorm(100000)#Here is a PRNG of 100,000 from N(0,1)
hist(Population)


#A random sample of 15
Sample<-sample(Population,15, replace=FALSE)#in this particular example they are not 
#replacing the draw each time as we are not yet doing the bootstrap. 
#Also, 15 data points is not that much :- )
Sample
hist(Sample)


#The mean of the sample
mean(Sample) #Note, the actual mean is 0.
sd(Sample) #Actual is 1 :- )


#Use replicate to do something lots of times
r<- replicate(1000, mean(sample(Population,15, replace=FALSE)))#Here we're drawing a sample of 15 from
#the Population of 100,000 a total of 1000 times.
r
hist(r)#Let's look at the histogram of our samples and what do you notice?
mean(r)
sd(r)#Why is this not close to 1?
#Think about what we're doing.  We're averaging the the means of 1000 samples from our
#original Population with draws of 15 without replacment, which is fixed. 
se<- 1/sqrt(15)
se
#Hummmm, are you thinking of anything interesting yet?
#Now, we got a pretty good estimate by going back into or Population 1000 times.
#Probably VERY costly in real life :- )



#Now to the bootstrap.  The simple idea of the bootstrap is that we can resample
#the sample itself - with replacement.
#Resample our sample 1000 times and calculate the mean of each.
boot<- replicate(1000,mean(sample(Sample, replace=TRUE)))
mean(boot)
sd(boot)
hist(boot)
#Holy Cow Batman!  We got pretty close for just playing with 15 pieces of info!

#Let's see what upping the number of replications does :- )  
boot<- replicate(2000,mean(sample(Sample, replace=TRUE)))
mean(boot)
sd(boot)
hist(boot)


#And yet higher *LOL*
boot<- replicate(3000,mean(sample(Sample, replace=TRUE)))
mean(boot)
sd(boot)
hist(boot)

#Higher!
boot<- replicate(5000,mean(sample(Sample, replace=TRUE)))
mean(boot)
sd(boot)
hist(boot)

#This is work in progress *LOL*
boot<- replicate(10000,mean(sample(Sample, replace=TRUE)))
mean(boot)
sd(boot)
hist(boot)
#A BIG thing to notice about Bootstrap.  It cannot realy improve on the mean. Why?
#It did do MUCH better on the standard error though.  Why?
sd(boot)- 1/sqrt(15)





