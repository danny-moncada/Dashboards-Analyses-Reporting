# BMI example
# Code below is used to generate simulated dataset

set.seed(1000)
gender=sample(0:1,10000,TRUE)
weight=rnorm(10000, mean = 180, sd = 40) + gender*rnorm(10000,mean=-30,sd=10) #weight in lb for men and women
height=rnorm(10000, mean = 60, sd = 1) + gender*rnorm(10000,mean=-6,sd=0.5) #height in in for men and women
bmi=(weight*703)/(height*height)+rnorm(10000, mean=0, sd = 3) #using general formula

Data<-data.frame(gender, weight, height, bmi)


hist(Data$weight[Data$gender==1],col=rgb(1,0,0,.5),ylim=c(0,1000),xlim=c(0,350))
hist(Data$weight[Data$gender==0],col=rgb(0,0,1,.5),add=T)
abline(v=mean(Data$weight[Data$gender==1]),col="red")
abline(v=mean(Data$weight[Data$gender==0]),col="blue")

# check averages
summary(lm(weight~1))
summary(lm(weight~gender)) #average weight
summary(lm(height~gender)) #average height

# BMI as a function of weight and height
summary(lm(log(bmi)~log(weight)+log(height))) #general formula
summary(lm(log(bmi)~log(weight)*gender+log(height)*gender)) #adjusted for men and women
