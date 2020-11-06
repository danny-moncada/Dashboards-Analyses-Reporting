library(bayesAB)
library(tidyverse)
#Farmer Mike has a huge number of cows.  Earlier this year he ran an experiment.
#He gave 10 cows a special diet which he heard could make them produce more milk.
#He recorded the liters of milk from those "diet" cows and from 15 "normal" cows,
#during one month.  Let's do some Baysian AB texting.


#For the bayesAB Normal distribution with unknown mu or sigma^2
#we're talking about an inverse gamma distribution for the Prior.
#Non-trivial *LOL*
####################################################################################
#for bayesAB normal - 
#mu, lambda, alpha, beta denote the (hyper)parameters of the priors 
#on (mu, sigma^2) of the normal distribution. 
#How to choose parameters for your priors is a very broad question, 
#and usually requires domain-specific knowledge. 
#What priors (and in turn which parameter values) to choose 
#is a critical question in Bayesian inference, and you can find 
#a plethora of literature on this.
#######################################################################################
#Now in "Estimating an Inverse Gamma distribution", by A. Llera, C. F. Beckmann
#we are given these approximations.  mu is the sample mean, lambda = 1, and 
#alpha = mu^2/s^2 + 2, and beta = mu(mu^2/s^2 + 1) where s^2 is the sample varience.


diet_milk <- c(651, 679, 374, 601, 401, 609, 767, 709, 704, 679)
normal_milk <- c(798, 1139, 529, 609, 553, 743, 151, 544, 488, 555, 257, 692, 678, 675, 538)

mu=mean(normal_milk)
mu
var=var(normal_milk)
var
#Computing our parameters
alpha=mu^2/var + 2
alpha
beta=mu*(mu^2/var + 1)
beta
plotNormalInvGamma(mu, 1, alpha, beta)
###############################################################3
mean(diet_milk)#Just checking :- )
var(diet_milk)


t.test(diet_milk,normal_milk) #Just courious again. *LOL*

#The best pick for the 4 parameters "mu", "lambda", "alpha", and "beta"
#are "mu" is the sample mean, "lambda" is 1, and alpha and beta as computed above.
AB1 <- bayesTest(diet_milk, normal_milk,
                 priors =  c("mu" = mu,"lambda"=1, "alpha" = alpha, "beta" = beta), n_samples = 1e5,
                 distribution = "normal")

summary(AB1)
plot(AB1)

#################################################################################


