# data vectors
valuesInt <- c(0, 1, 2)
probs <- c(.05, .10, .25)
# Binomial distribution: n = 15, p = .25

# P(X = Value)
dbinom(valuesInt, 15, .25)
## [1] 0.01336346 0.06681731 0.15590705

# Cumuluative distribution function
## this gives the P (X <= Value)
## this is probabilitiy associated with a RANGE of values
pbinom(valuesInt, 15, .25)
##      P(<=0)        P(<=1)      P(<=2)
## [1] 0.01336346 0.08018077 0.23608781

# X value to obtain at least the given cumulative probability
qbinom(probs, 15, .25)
## to get .05, you need X = 1, to get .10 you need x = 2 (because 1
## only gives you .08, and you  need X = 3 to get to .25 because 2
## only reaches to .23)
## [1] 1 2 3

# data vectors
valuesInt <- c(0, 1, 2)
probs <- c(.05, .10, .25)
# Normal distribution with mean = 4, stdev = 3
# Standard normal (z) is the default
# Standard normal is mean = 0, stdev = 1

# cumulative probability associated with a value
pnorm(valuesInt, 4, 3)
##      P(<=0)        P(<=1)     P(<=2)
# [1] 0.09121122 0.15865525 0.25249254

# X value for a given cumulative probability
qnorm(probs, 4, 3)
# P(X<=-0.9346 is 0.5)  P(X<=.1553 is .10)    P(X<=1.9766 is .25)
# [1] -0.9345609        0.1553453             1.9765307

# data vectors
values <- c(-5, -3, -1, 0, 1, 3, 5)
valuesPos <- c(.1, 1, 5, 10)
valuesInt <- c(0, 1, 2, 3, 4, 5, 10)
probs <- c(.05, .10, .25, .5, .75, .9, .95)

# Binomial distribution: n = 15, p = .25
  # P(X = Value)
dbinom(valuesInt, 15, .25)
        # P(0)        P(1)        P(2)          P(3)          P(4)
## [1] 0.0133634610 0.0668173051 0.1559070451 0.2251990652 0.2251990652 
        # P(5)        P(10)
## [6] 0.1651459811 0.0006796131

  # Cumulative distribution function
pbinom(valuesInt, 15, .25)
        # P(0)        P(1)      P(2)      P(3)        P(4)       P(5)
## [1] 0.01336346 0.08018077 0.23608781 0.46128688 0.68648594 0.85163192 
        # P(10)
## [7] 0.99988466

  # X value to obtain at least the given cumulative probability
qbinom(probs, 15, .25)
   #    P(.05) P(.10)  P(.25)  P(.5)  P(.75)  P(.9)  P(.95)  
## [1]    1       2       3       4     5       6       7

# Normal distribution fucntion
  # Standard normal (z) is the default
    # Distribution function for finding cumulative probability associated with a value
pnorm(values)

## [1] 2.866516e-07 1.349898e-03 1.586553e-01 5.000000e-01 8.413447e-01
## [6] 9.986501e-01 9.999997e-01

  # X value for a given cumulative probability
qnorm(probs)

## [1] -1.6448536 -1.2815516 -0.6744898  0.0000000  0.6744898  1.2815516
## [7] 1.6448536

# create random draws from a normal distribution
random_normal <- rnorm(10)
  # Normal distribution with mean 4, sd 3
    # cumulative probability associated with a value
pnorm(valuesInt, 4, 3)

## [1] 0.09121122 0.15865525 0.25249254 0.36944134 0.50000000 0.63055866
## [7] 0.97724987

  # X value for a given cumulative probability
qnorm(probs, 4, 3)

## [1] -0.9345609  0.1553453  1.9765307  4.0000000  6.0234693  7.844654
## [7] 8.9345609

# Other distributions of interest later in the course
# t distribution: 5df
pt(values, 5)

## [1] 0.002052358 0.015049624 0.181608734 0.500000000 0.818391266 0.984950376 
## [7] 0.997947642

qt(probs, 5)

## [1] -2.0150484 -1.4758840 -0.7266868  0.0000000  0.7266868  1.4758840  
## [7] 2.0150484

# Chi-squared distribution: 1 df
pchisq(valuesPos, 1)

## [1] 0.2481704 0.6826895 0.9746527 0.9984346

qchisq(probs, 1)

## [1] 0.00393214 0.01579077 0.10153104 0.45493642 1.32330370 2.70554345 
## [7] 3.84145882

#F distribution: 1, 15 df
pf(valuesPos, 1, 15)

## [1] 0.2438126 0.6668299 0.9590310 0.9935575

qf(probs, 1, 15)

## [1] 0.004065868 0.016334440 0.105335900 0.477753222 1.432065243 3.073185550
## [7] 4.543077165