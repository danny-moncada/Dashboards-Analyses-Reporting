library(bayesAB)
##install.packages("tidyverse") ##if you have already not :- )
require("MASS")
library(tidyverse)
#install.packages("ggplot")
library(ggplot2)
A_binom <- rbinom(250, 1, .25)#Let's do this with 15, 100, and 250

A_binom <- rbinom(250, 1, .21)#Let's do this with 15, 100, and 250


B_binom <- rbinom(250, 1, .2)
#We would expect the mode to be between .2 and .25
A_binom
B_binom
hist(A_binom)
hist(B_binom)
plotBeta(100, 200) # looks a bit off, shifted to the right maybe just a bit.
plotBeta(65, 200) # Better.  Notice 65/(65 + 200) is about 25%

AB1 <- bayesTest(A_binom, B_binom, priors = c('alpha' = 65, 'beta' = 200), n_samples = 1e5, distribution = 'bernoulli')
print(AB1)
summary(AB1)
plot(AB1)

### the mode is the highest peak on Beta PDF, this means it should be in there