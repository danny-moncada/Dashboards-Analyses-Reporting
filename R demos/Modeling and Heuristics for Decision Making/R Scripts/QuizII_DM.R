## DANNY MONCADA - MSBA 6450 - QUIZ II

## 186 Democrats were polled RANDOMLY - Mean: 15699 hot dogs, Standard Deviation: 8633 hot dogs
## 210 Republicans were polled RANDOMLY - Mean: 16215 hot dogs, Standard Deviation: 7301 hot dogs

## Import libraries

library("bayesAB")

## 1.  Use a standard frequentist method to show that these spreads are in fact too close to distinguish between.  
## Carefully state what you're doing and why is shows that these distributions are too close to distinguish from.  

##### ****FREQUENTIST METHOD****
## I decided to perform a simple t-test to show that the distributions are too close
## to distinguish.

## Create my normally distributed data sets using the info provided for Democrats & Republicans
dems <- rnorm(186, 15699, 8633)
dems#[0:20] ## print the first 20 to see what kind of data we're working with

reps <- rnorm(210, 16215, 7301)
reps#[0:20] ## print the first 20 to see what kind of data we're working with


## Run our t-test!
t.test(dems, reps)
## Let's interpret our results.

## Our p-value is pretty high.  Since this is a simulation, it can end up being anywhere.
## This time, we landed on a p-value of ~0.9 and change.
## Our alternative hypothesis is that true difference in means is not equal to 0.  We cannot reject the null
## hypothesis based on this result.

## We also look at our means compared to each other.  They look pretty close!
## Since we're being frequentists, this does enough for us to show that the distributions aren't distinguishable.

## 2.  Use any Monte Carlo method and see if in fact you can distinguish between these two data sets.

##### ****MONTE CARLO SIMULATION****

## Let's test this again, using a different methodology!

## The question is can we in fact distinguish between the two data sets?
## We're trying to prove definitively that Dems eat less than Republicans.  Let's see!

## Re-initialize our normal distributions, we want a new set of data!
dems <- rnorm(186, 15699, 8633)
reps <- rnorm(210, 16215, 7301)

## Set N to 10000, we're going to need many simulations based on the evidence above.
## Getting 15 random draws from the Democratic randomly polled distribution
## We'll use this to bootstrap the Democrat survey results
N = 10000
dem_boot <- replicate(N, mean(sample(dems,15, replace=TRUE)))

## Demonstrate what mean and SD of the random draws, we want to make sure we got close to our original mean
## and original SD
mean(dem_boot)
sd(dem_boot)

## Build a histogram to show the distribution of the means, we want to make sure it is normal
dem_h <- hist(dem_boot, col = "red", xlab = "Number of hot dogs eaten by Democrats")
xfit<-seq(min(dem_boot),max(dem_boot),length=40) 
yfit<-dnorm(xfit,mean=mean(dem_boot),sd=sd(dem_boot)) 
yfit <- yfit*diff(dem_h$mids[1:2])*length(dem_boot) 
lines(xfit, yfit, col="blue", lwd=2)

## She's a beaut!

### Get 15 random draws from the Republican randomly polled distribution
## We'll use this to bootstrap the Republican survery results
rep_boot <- replicate(N, mean(sample(reps,15, replace=TRUE)))

## Demonstrate what mean and SD of the random draws, we want to make sure we got close to our original mean
## And original SD
mean(rep_boot)
sd(rep_boot)

## Build a histogram to show the distribution of the means, we want to make sure it is normal
rep_h <- hist(rep_boot, col = "red", xlab = "Number of hot dogs eaten by Republicans")
xfit<-seq(min(rep_boot),max(rep_boot),length=40) 
yfit<-dnorm(xfit,mean=mean(rep_boot),sd=sd(rep_boot)) 
yfit <- yfit*diff(rep_h$mids[1:2])*length(rep_boot) 
lines(xfit, yfit, col="blue", lwd=2)

## Also quite lovely!

## The big KAHUNA - we'll test to see if our bootstrapped means for Democrats are less than Republicans
## In our original problem, we were told that Reps, on average, should eat more hot dogs
## than Democrats. Do our results prove that?
cf_value = dem_boot < rep_boot
head(cf_value)

## 50/50 split probability that Dems do in fact eat less hot dogs than Republicans.  Is this enough
## for us to say we can distinguish between the two data sets?

## One more thing we can check - what's the actual probability that Dems, on average, are in fact 
## eating less hot dogs than Republicans?

sum(cf_value) / 10000

cat(sum(cf_value) / 10000 * 100, "% chance that Dems on average are eating less hot dogs.")

## I am getting a pretty good probability.  So I can reasonably conclude that Dems are likely eating less
## on average, and that the two data sets are, in fact, different.

## 3.  Use Bayesian A/B testing to show that these are easily distinguishable.

#### ****BAYES A/B TESTING****

## Re-initialize our normal distributions, new set of data for our last set of tests.

dems <- rnorm(186, 15699, 8633)
reps <- rnorm(210, 16215, 7301)

## I am just going to grab the mean from my Democrats normal distribution and set it to mu.
## Grab the SD from my normal distro as well.
## Print them out to see how close I got to the actual mean 15699, and 16215.
mu = mean(dems)
mu
var=var(dems)^.5
var

## Set my variables for my AB test
A_norm <- dems
B_norm <- reps

## I went with an alpha and beta of 1 for my first AB test.
## I figured there's a 50% chance that Democrats eat more than Republicans.  And it's easier math :)
## A person's political party should have no relevance to their eating habits.
## (a / a + b) = .5, or a = .5a + .5b, .5a = .5b, a = b = 1 

AB1 <- bayesTest(A_norm, B_norm,
                 priors = c('mu' = mu, 'lambda' = 1, 'alpha' = 1, 'beta' = 1),
                 distribution = 'normal')
summary(AB1)
plot(AB1)

## After my first A/B testing, the P(A > B) or P(Dems > Reps) is really small.
## Seems pretty unlikely that Dems are eating more hot dogs.  I plot the distributions
## to make sure nothing weird is happening with the distributions.

A_norm_h <- hist(A_norm, col = "red", xlab = "Number of hot dogs eaten by Democrats")
xfit<-seq(min(A_norm),max(A_norm),length=40) 
yfit<-dnorm(xfit,mean=mean(A_norm),sd=sd(A_norm)) 
yfit <- yfit*diff(A_norm_h$mids[1:2])*length(A_norm) 
lines(xfit, yfit, col="blue", lwd=2)

B_norm_h <- hist(B_norm, col = "red", xlab = "Number of hot dogs eaten by Republicans")
xfit<-seq(min(B_norm),max(B_norm),length=40) 
yfit<-dnorm(xfit,mean=mean(B_norm),sd=sd(B_norm)) 
yfit <- yfit*diff(B_norm_h$mids[1:2])*length(B_norm) 
lines(xfit, yfit, col="blue", lwd=2)

## I go with one more A/B test, so I calculate a new alpha and beta

alpha=mu^2/var + 2
alpha
beta=mu*(mu^2/var + 1)
beta

AB2 <- bayesTest(A_norm, B_norm,
                 priors = c('mu' = mu, 'lambda' = 1, 'alpha' = alpha, 'beta' = beta),
                 distribution = 'normal')
summary(AB2)
## plot(AB2)

## For both of my AB tests, the P(A > B) or P(Dems > Reps), which is the probability that Dems, based on these two
## distributions, actually eat more, on average, are very small percentages.

## 4.  So, who eats more hot dogs?

## Frequentists would argue against that by saying the two distributions are too close to distinguish.  
## However, after going through different simulations, including Monte Carlo AND two forms of BayesA/B testing, 
## I can reasonably conclude two things:
## 
## 1.  The distributions are different enough that they can be assessed separately, as long as they are normally
## distributed.  The sample size for both distributions are big enough that we can assume these are two solid
## data sets.
##
## 2.  Republicans, on average, eat more hot dogs - when they aren't trying to make AMERICA GREAT AGAIN!