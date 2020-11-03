library(Rglpk)
library(bayesAB)

######## QUESTION 1

## The LP section will be worth 50% of the exam and is a R coding problem very much like the hiring/firing problem 
## from Sallan. There will be two parts.

## There will be two more questions each worth 25% of the grade.

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

######## QUESTION 2

## In one question I will give you a 15 element data set drawn from a normal distribution with rnorm in R. 
## By whatever methods you feel appropriate- you are to determine as closely as is possible what the actual mean 
## was set to in the rnorm generator. Within 2.5% will be considered correct.

### Bootstrap and Monte Carlo sim

## INSERT DATA SET HERE

N = 100000

##var <- c(1, 10, 15, 16, 21, 8, 9, 200)

## remember to divide by n-1 and NOT N!!!!

nums <- c(10, 20 ,15, 32, 12, 18)
nums

mu = sum(nums) / (length(nums) - 1)
mu
sd = sd(nums)
sd

## 10 steps up (These are As)
x <- rnorm(20, mu, sd)

x1 <- rnorm(20, mu + .1*mu, sd)
x2 <- rnorm(20, mu + .2*mu, sd)
x3 <- rnorm(20, mu + .3*mu, sd)
x4 <- rnorm(20, mu + .4*mu, sd)
x5 <- rnorm(20, mu + .5*mu, sd)
x6 <- rnorm(20, mu + .6*mu, sd)
x7 <- rnorm(20, mu + .7*mu, sd)
x8 <- rnorm(20, mu + .8*mu, sd)
x9 <- rnorm(20, mu + .9*mu, sd)

## 10 steps down (These are Bs)
y1 <- rnorm(20, mu - .1*mu, sd)
y2 <- rnorm(20, mu - .2*mu, sd)
y3 <- rnorm(20, mu - .3*mu, sd)
y4 <- rnorm(20, mu - .4*mu, sd)
y5 <- rnorm(20, mu - .5*mu, sd)
y6 <- rnorm(20, mu - .6*mu, sd)
y7 <- rnorm(20, mu - .7*mu, sd)
y8 <- rnorm(20, mu - .8*mu, sd)
y9 <- rnorm(20, mu - .9*mu, sd)

AB1 <- bayesTest(x1, y1,
                 priors =  c("mu" = mu,"lambda"=1, "alpha" = 3, "beta" = 1), n_samples = 1e5,
                 distribution = "normal")

summary(AB1)

AB2 <- bayesTest(x5, y5,
                 priors =  c("mu" = mu,"lambda"=1, "alpha" = 3, "beta" = 1), n_samples = 1e5,
                 distribution = "normal")

summary(AB2)

## Do I test every single combination until I get close?  If I found a combo with a P(A > B) of 50%,
## that means they are even right?

#P(A > B) by (0, 0)%: 
  
#  $Mu
#[1] 0.94314 - this should be around 50

#Credible Interval on (A - B) / B for interval length(s) (0.9, 0.9) : 
  
 # $Mu
#5%          95% 
 # -0.006628091  0.379786304 ## This should center around 0 if they are close



#what <- mean(x5)
#what_2 <- mean(y5)
#what
#what_2
#plot(AB2)

## Look for the closest interval that will work

var_bootstrap <- replicate(N, mean(sample(var,15, replace=TRUE)))
mean(var_bootstrap)
sd(var_bootstrap)


########### SIFTER

######### QUESTION 3

linefit1 <- lm(Y ~ X)
linefit1.stres <- rstandard(linefit1)
plot(houses$Size, linefit1.stres, pch = 16, main = "Standardized Residual Plot", 
     xlab = "House Size (100s of square feet)", ylab = "Standardized Residuals")
abline(0,0, lty=2, col="red")

qqnorm(linefit1.stres, main = "Normal Probability Plot", xlab = "Normal Scores", ylab = "Standardized Residuals") qqline(linefit1.stres, col = "red")

L1<-lm(Y ~ X)
plot(X, Y, main="Linear", pch = 16)
yhat1<- L1$coef[1]+L1$coef[2]*a
lines(a, yhat1,lwd=2)

plot(X, Y, pch = 16, main = "Linear", 
     xlab = "X values", ylab = "Y values") 
abline(lm(Y ~ X), lty=2, col="red")

summary(L1)


L2<-lm(Y ~ X + I(X^2))
plot(X, Y, main="Quadratic", pch = 16)
yhat2<- L2$coef[1]+L2$coef[2]*a + L2$coef[3]*a^2
lines(a, yhat2,lwd=2)

X<- abs(X) + exp(-10)#Let's fix the negatives and a zero possibility :- )
Y<- abs(Y)
X
Y
#
L3<-lm(log(Y) ~ X)
plot(X, Y, main="Exponential", pch = 16)
logyhat3<- L3$coef[1]+L3$coef[2]*a
yhat3<- exp(logyhat3)
lines(a,yhat3,lwd=2)

L4<-lm(log(Y) ~ log(X))
plot(log(X), log(Y), main="Log-Log", pch = 16)
logyhat4<- L4$coef[1]+L4$coef[2]*log(a) #Since 0 could be in the data set we could have a slight problem :- )
lines(log(a), logyhat4,lwd=2)

use qqplot(), use 


### Find the equation, plug in value of X and get Y, there's your answer.