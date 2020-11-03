##install.packages("bayesAB")

library("bayesAB")
library("ggplot2")

A_binom <- rbinom(100, 1, .5)
B_binom <- rbinom(100, 1, .6)

print(A_binom)
print(B_binom)

AB1 <- bayesTest(A_binom, B_binom, priors = c('alpha' = 1, 'beta' = 1), distribution = 'bernoulli')
print(AB1)

binomialBandit <- banditize(AB1)
binomialBandit$serveRecipe()
binomialBandit$setResults(list('A' = c(1, 0 , 1, 0, 0), 'B' = c(0, 0, 0, 0, 1)))

##############################

A_binom <- rbinom(100, 1, .5)
B_binom <- rbinom(100, 1, .6)

print(A_binom)
print(B_binom)

A_norm <- rnorm(100, 6, 1.5)
B_norm <- rnorm(100, 5, 2.5)

print(A_norm)
print(B_norm)

AB1 <- bayesTest(A_binom, B_binom,
                 priors = c('alpha' = 1, 'beta' = 1),
                 distribution = 'bernoulli')

AB2 <- bayesTest(A_norm, B_norm,
                 priors = c('mu' = 5, 'lambda' = 1, 'alpha' = 3, 'beta' = 1),
                 distribution = 'normal')

print(AB1)
summary(AB1)

summary(AB2)

## Create a new variable that is the probability multipled
## by the normally distributed variable (expected value of something)
AB3 <- combine(AB1, AB2, f = `*`, params = c('Probability', 'Mu'), newName = 'Expectation')

print(AB3)
summary(AB3)
plot(AB3)

A_pois <- rpois(100, 5)
B_pois <- rpois(100, 4.7)

AB1 <- bayesTest(A_pois, B_pois, priors = c('shape' = 25, 'rate' = 5), distribution = 'poisson')
AB2 <- bayesTest(A_pois, B_pois, priors = c('shape' = 25, 'rate' = 5), distribution = 'poisson')

c(AB1, AB2)

A_binom <- rbinom(100, 1, .5)
B_binom <- rbinom(100, 1, .6)

A_norm <- rnorm(100, 6, 1.5)
B_norm <- rnorm(100, 5, 2.5)

AB1 <- bayesTest(A_binom, B_binom,
                priors = c('alpha' = 1, 'beta' =1),
                distribution = 'bernoulli')

AB2 <- bayesTest(A_norm, B_norm,
                 priors = c('mu' = 5, 'lambda' = 1, 'alpha' = 3, 'beta' = 1),
                 distribution = 'normal')

AB3 <- combine(AB1, AB2, f = `*`, params = c('Probability', 'Mu'), newName = 'Expectation')
## Equivalent to
AB3 <- AB1 * grab(AB2, 'Mu')

# To get same posterior name as well
AB3 <- rename(AB3, 'Expectation')

# Dummy example
weirdVariable <- (AB1 + AB2) * (AB2 / AB1)
weirdVariable <- rename(weirdVariable, 'confusingParam')

print(AB3)
summary(AB3)
plot

###### Plot bayesTest objects #######
A_pois <- rpois(100, 5)
B_pois <- rpois(100, 4.7)

AB1 <- bayesTest(A_pois, B_pois, priors = c('shape' = 25, 'rate' = 5), distribution = 'poisson')

plot(AB1)
plot(AB1, percentLift = 5)

p <- plot(AB1)
p$posteriors$Lambda

## modify chart title (if needed/wanted)
p$posteriors$Lambda + ggtitle('New Title Here')

###### Plot the Probability Distributuion Function of a Beta distribution
plotBeta(1, 1)
plotBeta(2, 5)

plotGamma(1, 1)
plotGamma(2, 5)

plotInvGamma(2, 4)
plotInvGamma(1, 17)

plotLogNormal(1, 1)
plotLogNormal(2, .5)

plotNormal(1, 1)
plotNormal(2, 5)

plotNormalInvGamma(3, 1, 1, 1)

plotPareto(1, 1)
plotPareto(5, 3)

plotPoisson(1)
plotPoisson(5)

######## Summary method for BayesTest

A_pois <- rpois(100, 5)
B_pois <- rpois(100, 4.7)

AB1 <- bayesTest(A_pois, B_pois, priors = c('shape' = 25, 'rate' = 5), distribution = 'poisson')

summary(AB1)
summary(AB1, percentLift = 10, credInt = .95)