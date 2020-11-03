


library(DAAG)

#As we will see in a moment the scatter plot of this data look positively correlated, 
#but possibly not linearly. 
#Let's propose 4 models.
#Linear: Y = B0 + B1x + e #(e is for error)
#Quadratic:  Y = B0 + B1X + B2X^2 + e
#Exponential:  log(Y) = log(B0) + B1X + e #(why is this called exponential?)
#Log-Log:  log(Y) = B0 + log(B1X) + e

trueA <- 5
trueB <- 0
trueSd <- 10
sampleSize <- 31

# create independent x-values 
X <- (-(sampleSize-1)/2):((sampleSize-1)/2)#Notice this creates [-15, 15] in Z.
X
# create dependent values according to ax + b + N(0,sd)
Y <-  trueA * X + trueB + rnorm(n=sampleSize,mean=0,sd=trueSd)
Y
plot(X,Y, main="Test Data")
a<- seq(-80,80,.1)#Sequence for plotting fits starts at -80 goes to 80 by .1 installments :- )
#along the "x" axis. The independent variable axis.  We will have to change it every time "mostly"
a


L1<-lm(Y ~ X)
plot(X, Y, main="Linear", pch = 16)
yhat1<- L1$coef[1]+L1$coef[2]*a
lines(a, yhat1,lwd=2)
#
L2<-lm(Y ~ X + I(X^2))
plot(X, Y, main="Quadratic", pch = 16)
yhat2<- L2$coef[1]+L2$coef[2]*a + L2$coef[3]*a^2
lines(a, yhat2,lwd=2)
#
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
#

L4<-lm(log(Y) ~ log(X))
plot(log(X), log(Y), main="Log-Log", pch = 16)
logyhat4<- L4$coef[1]+L4$coef[2]*log(a) #Since 0 could be in the data set we could have a slight problem :- )
lines(log(a), logyhat4,lwd=2)
#For a=0 if will have a problem, but not to worry :- )
#Next we do an "n-fold" cross validation.  
#Essentually, this is a Jackknife - leave one out kind of thng :- _
#1.  For k = 1,2,3...,n, let observation(x(k),y(k)) be the test point.
#  We will use te remaining observations to fit the model.
#  Fit the models using only n-1 observations in the training set.
#  Compute the predicted response yhat(k) = B0hat + B1hatx(k) for the test oint.
#  Compute the prediced error e(k) = y(k) - yhat(k).
#  Estimate the mean of the square prediction errors.
#OK, let's do it!
n= length(X)#Data in X
n
e1<- e2<- e3<- e4<- numeric(n)#Creating a place to store our calculations.
#For a n-fold cross validation.
#Fit models on a one left out samples.
for (k in 1:n){
  y<- Y[-k]
  x<- X[-k]
  J1<- lm(Y~X)
  yhat1<- J1$coef[1]+ J1$coef[2]*X[k]
  e1[k]<- Y[k]- yhat1
  
  J2<- lm(y~x + I(x^2))
  yhat2<- J2$coef[1]+ J2$coef[2]*X[k] + J2$coef[3]*X[k]^2 
  e2[k]<- Y[k]- yhat2
  
  J3<- lm(log(y)~x)
  logyhat3<- J3$coef[1]+ J3$coef[2]*X[k]
  yhat3<- exp(logyhat3)
  e3[k]<- Y[k]- yhat3
  
  J4<- lm(log(y)~log(x))
  logyhat4<- J4$coef[1]+ J4$coef[2]*log(X[k])
  yhat4<- exp(logyhat4)
  e4[k]<- Y[k]- yhat4
}
c(mean(e1^2),mean(e2^2),mean(e3^2),mean(e4^2))

L1
L2
L3
L4
plot(L1$fit, L1$res)#residuals vs fitted values for best mosel - in this case L2
abline(0,0)#Put in a reference line :- )
qqnorm(L1$res)#Normal probability plot....pattern or???
qqline(L1$res)#reference line
######################################################
plot(L2$fit,L2$res)
abline(0,0)
qqnorm(L2$res)
qqline(L2$res)
######################################################
plot(L3$fit,L3$res)
abline(0,0)
qqnorm(L3$res)
qqline(L3$res)
######################################################
plot(L4$fit,L4$res)
abline(0,0)
qqnorm(L4$res)
qqline(L4$res)
######################################################
summary(L1)
summary(L2)
summary(L3)
summary(L4)
#Remember - we want BIG F statistic and small p-value :- )
