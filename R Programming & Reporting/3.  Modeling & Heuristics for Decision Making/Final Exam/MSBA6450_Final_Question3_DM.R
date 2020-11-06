## In the last question I will give you two sets x and y of 10 elements each and I'll ask you to develop a mathematical model 
## that fits this data as closely as is possible and then make a prediction for some theoretical value of x. 
## (I will model either a linear/quadratic/log/exponential function with a bit of noise) 

## NO PACKAGES NEEDED - WE'RE USING BASE R FOR THIS ANALYSIS BOO-YAH

## Generate my X values based on the problem
X = c(0.52933466, 0.15552968, 0.36581071, 0.45692039, 0.91465466, 0.08033931,
      0.76546048, 0.64505530, 0.62327284, 0.05966902)

## Generate my Y values based on the problem
Y = c(2.629730, 1.281666, 1.958268, 2.284790, 3.578952, 1.409117, 3.663195, 
      2.749400, 2.540583, 2.576510)

## Generate a distribution of the X values, 
## Not a normal distribution so have to be careful
h <- hist(X)
## Add normal curve
x <- X
xfit <- seq(min(x), max(x), length = 40)
yfit <- dnorm(xfit, mean = mean(x), sd = sd(x))
yfit <- yfit*diff(h$mids[1:2])*length(x)
lines(xfit, yfit, col = "blue")

## Generate a Linear model, based on X and Y
L1<-lm(Y ~ X)
plot(X, Y, main="Linear", pch = 16)
yhat1<- L1$coef[1]+L1$coef[2]*a
lines(a, yhat1, lwd=2, col = 'blue')

## Fits the line pretty nicely.

## Generate a Quadratic model, based on X and Y
L2<-lm(Y ~ X + I(X^2))
plot(X, Y, main="Quadratic", pch = 16)
yhat2<- L2$coef[1]+L2$coef[2]*a + L2$coef[3]*a^2
lines(a, yhat2, lwd=2, col = 'red')

## Also fits the line of the Quadratic curve nicely.

## Remove any negative values (which there are none)
## And normalize for our Expontential and Logirthmic models
X<- abs(X) + exp(-10)
Y<- abs(Y)
X
Y

## Generate a Exponential model, based on X and Y
L3<-lm(log(Y) ~ X)
plot(X, Y, main="Exponential", pch = 16)
logyhat3<- L3$coef[1]+L3$coef[2]*a
yhat3<- exp(logyhat3)
lines(a,yhat3,lwd=2, col = 'gold2')

## Generate a Logarithmic model, based on X and Y
## Eliminating log(Y) and log(X) since it doesn't really fit the pattern
## based on the graph output
L4<-lm(log(Y) ~ log(X))
plot(log(X), log(Y), main="Log-Log", pch = 16)
logyhat4<- L4$coef[1]+L4$coef[2]*log(a)
lines(log(a), logyhat4, lwd=2, col = 'darkgreen')

## Plot the residuals vs the fitted values for each model
## We want to see if they fit the patten of a linear model
plot(fitted(L1), residuals(L1), main = "Linear", xlab="Predicted scores", ylab="Residuals")
abline(0, 0, col = 'blue')

##  Now we plot a normal probability plot - is there a definitive patten for
##  the linear model?
qqnorm(residuals(L1))
qqline(residuals(L1), col = 'blue')

## Next up, we want to see if they fit the patten of a quadratic model
plot(fitted(L2), residuals(L2), main="Quadratic", xlab="Predicted scores", ylab="Residuals")
abline(0, 0, col = 'red') 

##  Now we plot a normal probability plot - is there a definitive patten for
##  the quadratic model? I repeat myself a lot, don't I?
qqnorm(residuals(L2))
qqline(residuals(L2), col = 'red')

## Next up, we want to see if they fit the patten of a exponential model
plot(fitted(L3), residuals(L3), main="Exponential", xlab="Predicted scores", ylab="Residuals")
abline(0, 0, col = 'gold2')

##  Now we plot a normal probability plot - is there a definitive patten for
##  the exponential model?
qqnorm(residuals(L3))
qqline(residuals(L3), col = 'gold2')

## Final set of plots, for the logarithmic function
plot(fitted(L4), residuals(L4), main="Logarithmic", xlab="Predicted scores", ylab="Residuals")
abline(0, 0, col = 'darkgreen')

##  Now we plot a normal probability plot - is there a definitive patten for
##  the exponential model?
qqnorm(residuals(L4))
qqline(residuals(L4), col = 'darkgreen')

## Here is where I will do the bulk of my interpretation.
## I've narrowed it down to two models: Linear vs. Exponential.
## I eliminated Logarithmic some time ago due to the first few plots.
## And I eliminate Quadratic because the standard residuals don't pass
## the eyeball test.  But I will run the summary function on them all anyways.

summary(L1)

## Residual standard error: 0.4746 on 8 degrees of freedom
## Multiple R-squared:  0.6787,	Adjusted R-squared:  0.6385 
## F-statistic:  16.9 on 1 and 8 DF,  p-value: 0.003388

summary(L2)

## Residual standard error: 0.4509 on 7 degrees of freedom
## Multiple R-squared:  0.7462,	Adjusted R-squared:  0.6737 
## F-statistic: 10.29 on 2 and 7 DF,  p-value: 0.008234

summary(L3)

## Residual standard error: 0.2202 on 8 degrees of freedom
## Multiple R-squared:  0.6439,	Adjusted R-squared:  0.5994 
## F-statistic: 14.47 on 1 and 8 DF,  p-value: 0.005211

summary(L4)

## Residual standard error: 0.2766 on 8 degrees of freedom
## Multiple R-squared:  0.438,	Adjusted R-squared:  0.3678 
## F-statistic: 6.235 on 1 and 8 DF,  p-value: 0.03711