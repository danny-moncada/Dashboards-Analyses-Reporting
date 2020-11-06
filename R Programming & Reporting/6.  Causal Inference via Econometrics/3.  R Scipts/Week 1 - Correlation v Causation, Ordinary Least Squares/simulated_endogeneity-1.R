# Author: Gordon Burtch and Gautam Ray
# Course: MSBA 6440
# Session: Causality and Endogeneity
# Topic: Simulating Endogeneity

set.seed(100)

## Some examples of what happens when we ignore different kinds of endogeneity

# 1) Measurement Error

# We build our variable X, and then also an erroneously measured version of X. 
X <- rnorm(200, mean = 50, sd=7)
X_m <- X + rnorm(200,mean=4, sd=15)

# Now we simulate Y using the true data generating process (accurately measured X)
Y <- 0.5*X + rnorm(200,mean=0,sd=1)

# You can see that the estimate is hugely deflated when we ignore the measurement error.
summary(lm(Y~X))
summary(lm(Y~X_m))

# 2) Omitted Variables // Correlated Unobservable

# Let's add in a confounder for X that we will "not observe" in our regression and see what it does.

Z <- rnorm(200, mean=3, sd=.5) - X
Y <- 0.5*X + 2*Z + rnorm(200,mean=0,sd=1)

# You can see that ignoring Z causes X to be downward biased (because Z is negatively correlated with X)
summary(lm(Y~X))
summary(lm(Y~X+Z))
