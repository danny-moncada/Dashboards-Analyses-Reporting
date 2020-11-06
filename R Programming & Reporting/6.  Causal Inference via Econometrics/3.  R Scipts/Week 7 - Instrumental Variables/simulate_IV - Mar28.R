# Author: Gordon Burtch and Gautam Ray
# Course: MSBA 6440
# Session: Instrumental Variables
# Topic: Simulating Instruments
# Lecture 7

library(MASS)
library(stargazer)
library(AER)
library(lfe)

# We will first simulate our treatment variable x, endogenous portion of x and its confounder, c
# Here, we refer to the endogenous variation in x as x*
# An easy way to make them confounded is to use the multivariate normal draw function, mvnorm.
xStarAndC <- mvrnorm(1000, c(20, 15), matrix(c(1, 0.5, 0.5, 1), 2, 2))
xStar <- xStarAndC[, 1]
c <- xStarAndC[, 2]

# If you are curious about syntax for mvnorm... ??MASS::mvnorm
# We pass it the number of obs to draw, the means of the two variables, and a covariance matrix.
# In this case, we simulated 1000 draws for two variables, mean 20 and 15, which are 50% correlated. 
cov(xStar,c)

# Now let's simulate our instrument, and make observed X a function of good variation (random stuff)
# and the bad variation, x*.
# By construction, z is a valid instrument for X now, because it is only correlated with the
# good variation, and it has no direct relationship on our eventual y (except through x).
z <- rnorm(1000)
x <- xStar + z

# Now let's simulate the data-generating process to recover y, 
# a function of observed x, its confounder and an error term.
# Here, the true marginal effect of x on y is 2. 
y <- 1 + 2*x + 10*c + rnorm(1000, 0, 0.5)

# Now lets check to make sure we have a problem of confounding.
cor(x, c)
cor(y, c)

# And let's check that the instrument is valid...
cor(x,z)
cor(c,z)

# Okay, let's run the 'true' regression first, controlling for the confounder.
ols_true <- lm(y ~ x + c)
# ... and let's run the endogenous regression, ignoring the confounder.
ols_endog <- lm(y ~ x)
stargazer(ols_true,ols_endog,type="text",title="True vs. Endogenous Regression",column.labels = c("True","Endogenous"))

# Okay, so let's start working toward IV reg. Let's do the first stage regression and use its predictions in the second stage.
xHat <- lm(x ~ z)$fitted.values
ols_corrected <- lm(y ~ xHat)
stargazer(ols_true,ols_endog,ols_corrected,type="text",title="True vs. Endogenous vs. Instrumented",column.labels = c("True","Endogenous","Manual"))

# Note that the beta is correctly estimated but the standard errors are not if we use this approach.
# The ivreg package will calculate not only this beta, but the right standard errors.
ivreg <- ivreg(formula=y ~ x | z)
stargazer(ols_true,ols_endog,ols_corrected,ivreg,type="text",title="True vs. Endogenous vs. Manual vs. Instrumented",column.labels = c("True","Endogenous","Manual","IV"))

summary(ivreg,diagnostics=TRUE)

# If you have multiple endogenous and instrumental variables in a single regression, you can tell R explicitly which variables to "remove" and what variables to "include" as instruments 'in its place'
# This syntax means "remove" x and include z. 
# Any variables not mentioned after the pipe instrument for themselves (perfect predictors). 
#ivreg <- ivreg(formula=y ~ x | .-x + z)

# Okay, now let's see what happens if we use instruments that are too weak in their association with x. 
x1 <- xStar + 0.9*z
x2 <- xStar + 0.8*z
x3 <- xStar + 0.7*z
x4 <- xStar + 0.6*z
x5 <- xStar + 0.5*z
x6 <- xStar + 0.4*z
x7 <- xStar + 0.3*z
x8 <- xStar + 0.2*z
x9 <- xStar + 0.1*z
x10 <- xStar + 0.01*z

# Now let's simulate the data-generating process to recover y, 
# a function of observed x, its confounder and an error term.
# Here, the true marginal effect of x on y is 2. 
y1 <- 1 + 2*x1 + 10*c + rnorm(1000, 0, 0.5)
y2 <- 1 + 2*x2 + 10*c + rnorm(1000, 0, 0.5)
y3 <- 1 + 2*x3 + 10*c + rnorm(1000, 0, 0.5)
y4 <- 1 + 2*x4 + 10*c + rnorm(1000, 0, 0.5)
y5 <- 1 + 2*x5 + 10*c + rnorm(1000, 0, 0.5)
y6 <- 1 + 2*x6 + 10*c + rnorm(1000, 0, 0.5)
y7 <- 1 + 2*x7 + 10*c + rnorm(1000, 0, 0.5)
y8 <- 1 + 2*x8 + 10*c + rnorm(1000, 0, 0.5)
y9 <- 1 + 2*x9 + 10*c + rnorm(1000, 0, 0.5)
y10 <- 1 + 2*x10 + 10*c + rnorm(1000, 0, 0.5)

ivreg_weak1 <- ivreg(formula=y1 ~ x1 | z)
ivreg_weak2 <- ivreg(formula=y2 ~ x2 | z)
ivreg_weak3 <- ivreg(formula=y3 ~ x3 | z)
ivreg_weak4 <- ivreg(formula=y4 ~ x4 | z)
ivreg_weak5 <- ivreg(formula=y5 ~ x5 | z)
ivreg_weak6 <- ivreg(formula=y6 ~ x6 | z)
ivreg_weak7 <- ivreg(formula=y7 ~ x7 | z)
ivreg_weak8 <- ivreg(formula=y8 ~ x8 | z)
ivreg_weak9 <- ivreg(formula=y9 ~ x9 | z)
ivreg_weak10 <- ivreg(formula=y10 ~ x10 | z)

# The weaker our instrument, the less accurate our final estimate of X's effect becomes.
stargazer(ivreg_weak1,ivreg_weak2,ivreg_weak3,ivreg_weak4,ivreg_weak5,ivreg_weak6,ivreg_weak7,ivreg_weak8,ivreg_weak9,ivreg_weak10,type="text")

# Let's plot it for interests sake... 
# First we pull out all the beta estimates, and we make a vector of the correlations we used (strength of IVs)
betas <- rep(NA,10)
for (i in 1:10){
  betas[i] <- get(paste0('ivreg_weak',i))$coefficients[2]
}
weakness <- c(.9,.8,.7,.6,.5,.4,.3,.2,.1,.01)

# Now let's plot our recovered betas, against their strength, and include a ref line for true value of 2.0.
library(lattice)
p <- xyplot(betas~weakness,xlab="Corr(X,Z)",ylab="Beta",ylim=c(1,15),type="b")
update(p, panel=function(...){ 
  panel.xyplot(...) 
  panel.abline(h=2,lty=2,col="red") 
} ) 

# Okay, now let's see what happens as we violate exclusion 
# That is, as we allow z to be correlated to an increasing degree with the confounders in the error term.
# To make this work, we now need to draw all three variables from a joint distribution (good x, z and confounder)
x_C_Z_1 <- mvrnorm(1000, c(20, 15, 10), matrix(c(1,0.5,0.9,0.5,1,.1,.9,.1,1), 3, 3))
x_C_Z_2 <- mvrnorm(1000, c(20, 15, 10), matrix(c(1,0.5,0.9,0.5,1,.2,.9,.2,1), 3, 3))
x_C_Z_3 <- mvrnorm(1000, c(20, 15, 10), matrix(c(1,0.5,0.9,0.5,1,.3,.9,.3,1), 3, 3))
x_C_Z_4 <- mvrnorm(1000, c(20, 15, 10), matrix(c(1,0.5,0.9,0.5,1,.4,.9,.4,1), 3, 3))
x_C_Z_5 <- mvrnorm(1000, c(20, 15, 10), matrix(c(1,0.5,0.9,0.5,1,.5,.9,.5,1), 3, 3))

x11 <- x_C_Z_1[, 1]
x12 <- x_C_Z_2[, 1]
x13 <- x_C_Z_3[, 1]
x14 <- x_C_Z_4[, 1]
x15 <- x_C_Z_5[, 1]
c1 <- x_C_Z_1[, 2]
c2 <- x_C_Z_2[, 2]
c3 <- x_C_Z_3[, 2]
c4 <- x_C_Z_4[, 2]
c5 <- x_C_Z_5[, 2]
z1 <- x_C_Z_1[, 3]
z2 <- x_C_Z_2[, 3]
z3 <- x_C_Z_3[, 3]
z4 <- x_C_Z_4[, 3]
z5 <- x_C_Z_5[, 3]

# What are we doing here? Making versions of z that are increasingly correlated with c.
# Let's store those correlations for our plot later.
exclusion <- rep(NA,5)
for (i in 1:5){
  exclusion[i] <- cor(get(paste0("c",i)),get(paste0("z",i)))
}

# Okay, now let's simulate our Y's
y11 <- 1 + 2*x11 + 10*c1 + rnorm(1000, 0, 0.5)
y12 <- 1 + 2*x12 + 10*c2 + rnorm(1000, 0, 0.5)
y13 <- 1 + 2*x13 + 10*c3 + rnorm(1000, 0, 0.5)
y14 <- 1 + 2*x14 + 10*c4 + rnorm(1000, 0, 0.5)
y15 <- 1 + 2*x15 + 10*c5 + rnorm(1000, 0, 0.5)

ivreg_endog1 <- ivreg(formula=y11 ~ x11 | z1)
ivreg_endog2 <- ivreg(formula=y12 ~ x12 | z2)
ivreg_endog3 <- ivreg(formula=y13 ~ x13 | z3)
ivreg_endog4 <- ivreg(formula=y14 ~ x14 | z4)
ivreg_endog5 <- ivreg(formula=y15 ~ x15 | z5)

stargazer(ivreg_endog1,ivreg_endog2,ivreg_endog3,ivreg_endog4,ivreg_endog5,type="text")

# Let's plot it again...
# As you can see, as Z becomes less "excluded" we see it yields worse and worse estimates of X's marginal
# Effect on Y. 
betas <- rep(NA,5)
for (i in 1:5){
  betas[i] <- get(paste0('ivreg_endog',i))$coefficients[2]
}
p <- xyplot(betas~exclusion,xlab="Corr(Z,C)",ylab="Beta",ylim=c(1,10),type="b")
update(p, panel=function(...){ 
  panel.xyplot(...) 
  panel.abline(h=2,lty=2,col="red") 
} ) 

# Okay let's do a real example here...
# This dataset is state-level data on cigarette sales, prices
# and taxes. Taxes are used as an instrument for prices here.
data("CigarettesSW")
sales <- lm(log(packs) ~ log(price) + year + state, data=CigarettesSW)
sales_iv <- ivreg(log(packs) ~ log(price) + year + state | .-log(price) + tax, data = CigarettesSW)
stargazer(sales,sales_iv,title="OLS vs. IV",type="text",column.labels = c("OLS","IV"),omit=c("state","year"))

# Setting "diagnostics = TRUE" let's us assess a hausman test, weak IV stats and overidentifying tests of instrument exclusion.
summary(sales_iv,diagnostics=TRUE)


