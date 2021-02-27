# Author: Gordon Burtch and Gautam Ray
# Course: MSBA 6440
# Session: Regression Discontinuity
# Topic: Fuzzy RDD Example
# Lecture 8

suppressWarnings(suppressPackageStartupMessages({library(MASS)
library(ggplot2)
library(rdrobust)
library(AER)
}))

# We are going to simulate some data that we can use for a fuzzy RDD analysis.
# We will first draw Y and X as continuous values, with a 70% correlation.
# Both values are mean 0.
set.seed(1234)
d <- as.data.frame(mvrnorm(2000, c(0,0), matrix(c(1, 0.7, 0.7, 1), ncol = 2)))
colnames(d) <- c("forcing", "outcome")

# introduce fuzziness - you are not guaranteed to get the treatment policy if you exceed the threshold... 
d$treatProb <- ifelse(d$forcing < 0, 0, 0.8)

# This is our "fuzzy" treatment assignment
d$fuzz <- rbinom(2000, 1, prob = d$treatProb)

# being treated adds "2" to your mean value of Y, i.e., the treatment effect is "2". 
d$outcome <- d$outcome + d$fuzz * 2

# Let's plot the data now to make sure everything worked. 
ggplot(d, aes(y=outcome,x=forcing,col=fuzz)) + geom_point(show.legend = FALSE) + geom_vline(xintercept=0,linetype="dashed",color="red") 

attach(d)

# Let's first see how well we do when we ignore the fuzzy aspect... we get an estimate of 1.58 (the true effect is 2!)
robust_naive_rdd <- rdrobust(outcome,forcing,c=0)
summary(robust_naive_rdd)
rdplot(outcome,forcing)

# Now, let's try it accounting for fuzziness... much improved! Estimate = 1.989
robust_fuzzy_rdd <- rdrobust(outcome,forcing,c=0,fuzzy=fuzz)
summary(robust_fuzzy_rdd)

# In case you want to see what the package is actually doing, I will run the linear RDD specification first
# and then the Fuzzy RDD specification (IV regression) second...

# Make treatment and deviation variable Z and (X-c)... note: X-c = X because c = 0.
d$treat <- (forcing>0)
lm_rdd <- lm(data=d,outcome ~ treat + forcing) 
lm_frdd <- ivreg(data=d, outcome ~ fuzz + forcing |.-fuzz + treat)
summary(lm_rdd)
summary(lm_frdd)
