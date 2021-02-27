#########################################################################################################
#In one question I will give you a 15 element data set drawn from a normal distribution with rnorm in R. 
#By whatever methods you feel appropriate- you are to determine as closely as is possible what the actual 
#mean was set to in the rnorm generator. Within 2.5% will be considered correct.
#########################################################################################################

population_mean = 60
random_sample = rnorm(15, population_mean, 5)
random_sample

#get actual mean of rnorm sample
sample_mean = mean(random_sample)
sample_mean

S = sum((random_sample - mean(random_sample))^2)
n = length(random_sample)

#estimate the variance
sigma2 = S/rchisq(1000, n - 1) 

#estiamte the mean
mu = rnorm(1000, mean = mean(random_sample), sd = sqrt(sigma2)/sqrt(n))

# the mean is the .50 in the quantile 
estimated_mean = quantile(mu, c(.5))
estimated_mean

# Measure how close the estimate was (looking for better than 2.5%). Output is scaled 
# by 100 to report the actual percentage.
((estimated_mean - population_mean)/population_mean)*100
 
