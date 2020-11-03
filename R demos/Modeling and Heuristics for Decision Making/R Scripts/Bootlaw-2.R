#Bootstrap estimate of standard error
#install.packages("bootstrap") if you have not :- )
library(bootstrap)#for the "law" data which is a sample data set from law82 (82 law-schools)
law
law$LSAT#the $ tells it which section of the data to take :- )  
law$GPA
print(cor(law$LSAT,law$GPA))

#This is the sample correlation for these 15 schools.

print(cor(law82$LSAT, law82$GPA))
#This is the population correlation for the 82 schools.
#
#
#Let's look at the differences between the sample correlation and the population correlation.
print(cor(law82$LSAT, law82$GPA) - cor(law$LSAT,law$GPA))
#Notice it is about 1.6% and some change :- )



#We will use a bootstrap to estimate the standard error of the correlation cofficient
#from the sample of scores in "law" again from the "bootstrap" package.
#set up the bootstrap
B<- 200#The number of replicates for standard error is generlly pretty low and 200 should be fine.
n<- nrow(law)
n#sample size
R<- numeric(B)#A place to store the replicates.
R
#bootstrap estimate of standard error of R
for(b in 1:B){
  #randomly select the indices
  i<- sample(1:n, size = n, replace = T)
  LSAT<- law$LSAT[i]
  GPA<- law$GPA[i]#i is a vecor of indices
  R[b]<- cor(LSAT,GPA)
}
R  #Here are our 200 random sample correlations we just constrcted.

se.R<- sd(R)
#Here is the dtandard deviation of this bootstrapped sample set.
se.R
#This s the bootstrap estimate for the se(R).  The theoritical value is 0.115
hist(R, prob=T)
#Let's do this again with a different package.
#install.packages("boot") if necssary.
library(boot)

r<- function(x,i){
  #we want correlations of columns 1 and 2
  cor(x[i,1], x[i,2])
}
obj<- boot(data=law, statistic = r, R = 200)# 200 replications of the function we created "r"
obj
#This is an ordinary nonparametric bootstrap

#The observed value of theta_hat of the correlation statistic is labeled t1*.  


