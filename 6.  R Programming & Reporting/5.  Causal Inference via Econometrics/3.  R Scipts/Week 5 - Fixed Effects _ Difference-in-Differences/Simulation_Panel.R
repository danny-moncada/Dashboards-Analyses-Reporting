# Lecture 5

library(plm)
library(dplyr)

set.seed(1001)

# We begin by simulating a panel dataset, with 500 individuals and 40 observations per individual
i = rep(1:500, each = 40)
t = rep(1:40, times = 500)
data = data.frame(i, t) %>%
  group_by(i) %>%
  mutate(weight = rnorm(1, mean = 180, sd=30)) %>%
  ungroup() 

# generate a treatment variables that is correlated with the individual-specific "weight"
data = data %>%
  mutate(X = round(weight/max(weight) + runif(20000,0,1) - 1,0))
cor(data$X, data$weight)

# generate the outcome
data = data %>%
  mutate(Y = 0.5 + 0.6*X + 0.3*weight + rnorm(20000,mean=0,sd=1))


# First, so let's start off by looking at the omitted variable bias again.
correct_reg = lm(Y ~ X + weight, data = data)
summary(correct_reg)

omitted_reg = lm(Y ~ X, data = data)
summary(omitted_reg)
     
# Now, let's take advantage of our panel data and try a fixed effect regression.   
# within estimator
within_reg = plm(Y ~ X, data = data, index=c("i"), effect="individual", model="within")
summary(within_reg)

# dummy variables - check if the results are identical to within estimator
dummy_reg = lm(Y ~ X + factor(i), data = data)
summary(dummy_reg)

# first differencing
fd_reg = plm(Y ~ X, data = data, index=c("i"), effect="individual", model="fd")
summary(fd_reg)

# Now, let's try a random effect model
random_reg = plm(Y ~ X, data = data, index=c("i"), effect="individual", model="random")
summary(random_reg)

# Hausman test
phtest(within_reg, random_reg)


# Next, let's simulate a case where the individual-specific weight is uncorrelated with X
set.seed(1001)
data2 = data.frame(i, t) %>%
  group_by(i) %>%
  mutate(weight = rnorm(1, mean = 180, sd=30)) %>%
  ungroup() %>%
  mutate(X = rbinom(n = 20000, size = 1, prob = 0.3)) %>%
  mutate(Y = 0.5 + 0.6*X + 0.3*weight + rnorm(20000,mean=0,sd=1))

cor(data2$X, data2$weight)

# fixed effect
within_reg2 = plm(Y ~ X, data = data2, index=c("i"), effect="individual", model="within")
summary(within_reg2)

random_reg2 = plm(Y ~ X, data = data2, index=c("i"), effect="individual", model="random")
summary(random_reg2)

# Hausman test
phtest(within_reg2, random_reg2)

