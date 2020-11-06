#So, Mike's got some chickens and I'm selling eggs to buy my first spaceship.
#Needless to say - I'll need to get and sell a LOT of eggs!!!
#Mike buys some special chicken food the is supposed to make the chickens produce more eggs.
#Ofthen time when you are modelling things which are modest positive integers - 
#we use the Possion function with lambda = mean of the distribution.
library(tidyverse)
library(bayesAB)
plotPoisson(2) #lambda = 2 is the mean of the Possion distribution.
plotPoisson(5)#lambda = 5 would be the mean of this Possion distribution.

#The conjugate prior for the Possion distribution is the Gamma distribution.
#Note: We use the shape/rate parametrization of Gamma. 
#See https://en.wikipedia.org/wiki/Gamma_distribution for details.
#Let s stand for 'shape' and r stand for rate.  Then the mean mu = s/r and mode 
# w = (s - 1)/r for s > 1

plotGamma(5,2)#Here the 'shape' = 5 and rate = 2 so w = (5 - 1)/2 = 2.
#Notice the mode IS 2 hurray!!!
plotGamma(10,2)#Here 'shape' = 10, rate = 2 so, the mean mu = 10/2 = 5.  Let's take a look.
#Notice the mode w = (10 - 1)/2 = 4.5 and it shows hopefully :- )
plotGamma(20,2)#Here 'shape' = 20 and rate = 2, so mu = 20/2 = 10.
plotGamma(2,10)#Here the "shape' = 2 and rate = 10, so mu = .2 and w = .1.

#Some other importants numerical facts :- )
# s = mu^2/sigma^2 and r = mu/sigma^2


diet_eggs<- c(6,4,2,3,4,3,0,4,0,6,3)#Number of eggs from the  chickens who ate the special food.
normal_eggs<- c(4,2,1,1,2,1,2,1,3,2,1)#Number of eggs from normal/regular food.
ave_mu <-mean(diet_eggs + normal_eggs)
ave_mu
#recall that if X ad Y are not correlated then var(X + Y) = var(X) + var(Y).
#Since we are assuming a Possion I think it s safe to use this but....let's look.
cor(diet_eggs, normal_eggs)
#pretty slight :- )

Var<- var(diet_eggs)+ var(normal_eggs)
Var


#Doing some math we have s = mu^2/sigma^2 and r = mu/sigma^2.
s = (ave_mu^2)/(Var)
r = (ave_mu)/(Var)
s
r
plotGamma(5,1)#Let's call t s = 5 and r = 1.
#Looks good to me *LOL*.

AB1 <- bayesTest(diet_eggs, normal_eggs, priors = c('shape' = 5, 'rate' = 1), distribution = 'poisson')


#Let's do a bootstrap for the heck of it as well!  :- )

diet_eggs_boot<- sample(diet_eggs, 10000, replace=T)
normal_eggs_boot<- sample(normal_eggs, 10000, replace=T)
t.test(diet_eggs_boot, normal_eggs_boot)
#So, clearly - they are not the same :- )

summary(AB1)
plot(AB1)


