# Author: Gordon Burtch and Gautam Ray
# Course: MSBA 6440
# Session: Selection and Measurement Error
# Topic: Measurement Error

suppressWarnings(suppressPackageStartupMessages({
library(MASS)
library(AER)
library(stargazer)
}))


# X and Y have classical measurement error. The true value are Xt and Yt, but they are meas-
# ured with error.
# X is measured as true X (Xt) plus error (ex)
# Y is measured as true Y (Yt) plus error (ey)
# The mean of Yt, Xt, ey and ex is (10, 7, 0, 0)
# The standard deviation of Yt, Xt, ey, and ex is (4, 8, 3, 6)
# The correlation of Yt and Xt is 0.7; Yt and Xt are uncorrelated with ey and ex; and ey and 
# ex are uncorrelated with each other. 

set.seed(1234)


Yt_Xt_ey_ex <- (mvrnorm(10000, c(10, 7, 0, 0), matrix(c(16, 22.4, 0.0, 0.0, 22.4, 64,0, 0, 0, 
                                                        0, 9,0, 0, 0, 0, 36), ncol = 4)))
Yt <- Yt_Xt_ey_ex[,1]
Xt <- Yt_Xt_ey_ex[,2]
ey <- Yt_Xt_ey_ex[,3]
ex <- Yt_Xt_ey_ex[,4]

Y <- Yt + ey
X <- Xt + ex


# Check everything worked as expected. 

cov(Yt_Xt_ey_ex)
cor(Yt_Xt_ey_ex)
sd(ey)
sd(ex)
sd(Yt)
sd(Xt)

mean (Yt)
mean(Xt)
mean(ey)
mean(ex)



#1. Measurement error in X, underestimates the effect of X on Y. The reliability of mismea-
# surement is the magnitude of the mismeasurement. 

summary(lm(Yt~Xt))

summary(lm(Yt~X))

Reliability <- var(Xt)/var(X)

Reliability

summary(lm(Yt~X))$coefficients[2,1]/ summary(lm(Yt~Xt))$coefficients[2,1]


#2. Measurement error in Y, does not influence the coefficient of X, but exaggerartes the 
# standard error of the regression coefficient. 

summary(lm(Yt~Xt))
summary(lm(Y~Xt))

#3. Given that the measurement error in Y is more innocuous than the measurement error in 
# X, we might run the reverse regression. 
# The coefficient of the regular regression and the inverse of the coefficient of the rev-
# erse regression, bracket the true coefficient. 

regular_reg <- (lm(Yt~X))
b <- summary(regular_reg)$coefficients[2,1]


reverse_reg <- (lm(X~Yt))
reverse_reg_coeff <- summary(reverse_reg)$coefficients[2,1]

g <- 1/(summary(reverse_reg)$coefficients[2,1])

b/g

summary((lm(Yt~X)))


#4. If there is a good instrument for Xt, then the true estimate can be recovered.
# Lets say that Z is a good instrument for Xt. Like Xt, Z has a mean of 7 and a sd of 8. Z 
# has a correlation of 0.5 with Xt, and Z is uncorrelated with ey and ex. 
# Z has a correlation of 0.35 with Yt which is the product of 0.7 and 0.5 i.e, the correl-
# ation between Yt and Xt and the correlation between Xt and Z.  


Yt_Xt_ey_ex_Z <- (mvrnorm(10000, c(10, 7, 0, 0, 7), matrix(c(16, 22.4, 0.0, 0.0, 11.2, 22.4, 
                    64,0, 0, 32, 0, 0, 9,0, 0, 0, 0, 0, 36, 0, 11.2, 32, 0, 0, 64), ncol = 5)))

Yt <- Yt_Xt_ey_ex_Z[,1]
Xt <- Yt_Xt_ey_ex_Z[,2]
ey <- Yt_Xt_ey_ex_Z[,3]
ex <- Yt_Xt_ey_ex_Z[,4]
Z <- Yt_Xt_ey_ex_Z[,5]

Y <- Yt + ey
X <- Xt + ex

cov(Yt_Xt_ey_ex_Z)
cor(Xt, Z)
cor(X, Z)
cor(Yt, Z)
cor(Y, Z)

ols_true <- lm((Yt~Xt))

ivreg1 <- ivreg(formula=Yt ~ X | Z)

ivreg2 <- ivreg(formula=Y ~ X | Z)

stargazer(ols_true,ivreg1, ivreg2,type="text",title="True vs.Instrumented",
          column.labels = c("True","IV1", "IV2"))


