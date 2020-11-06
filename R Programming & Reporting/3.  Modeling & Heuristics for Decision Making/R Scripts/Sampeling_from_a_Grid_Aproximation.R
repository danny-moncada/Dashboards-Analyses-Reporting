#Let's play a little with dbinon(6,9,p=?)
dbinom(6, 9, .5)
#This is C(9,6).5^6.5^3

#Samplng from a Grid Approximation example from Statistical Rethinking - fantastic book!
#Define Grid
p_grid <- seq(from=0, to=1, length.out = 1000)
#The above code makes a grid of 1000 points.
#Too many to look at :- )
#Define Prior
prior<- rep(1,1000)#Again we are working with a non-informative prior.
#___________________________________________________________________________________________
#Compute each likelihood at each value in grid.  
#We are going to creat a Bayesian experiment by taking a globe, twirlling it in the air and
#looking where our first finger landed.  On water or on land.  Suppose in 9 trials
#we got 6 waters.  Let us find the likelihhods of this given the 1000 possible values for 
#p = the probably if water. We are goign to tr to estimate the actual ratio of water to land.
#____________________________________________________________________________________________
likelihood<- dbinom(6, size = 9, prob=p_grid)#Here we are computing 1000 binomial probabilities
#given we had 6 "successes" in 9 trials with the probability of success being the elements of p_grid.
#That is, for p_grid = .5 likelihood<- dbinom(6, 9, .5) so we are creating a grid of 1000
#of these liklihood grid points.
head(likelihood)#Here are the first 6 entries of our Likelihood function.  
#No sense printing all 1000 *LOL*

#Compute product of likelihood times the prior.
unstd.posterior<- likelihood*prior
head(unstd.posterior)#Again, let's look at the first 6 elements of
#our unstandardized posterior. 
posterior<- unstd.posterior/sum(unstd.posterior)
#Standardize the posterior so it sums to 1.
head(posterior)#And finally the first 6 elements of the standardized posterior.
#Because I'm still newish to R - I always like to see what
#kind of monster I created :- )

plot(p_grid, posterior, type="b",
     xlab = "Probability of Water", ylab="Posterior Probability")
mtext("1000 points")
#Now lets sample from this.
samples<- sample(p_grid, prob = posterior, size = 1e4, replace=TRUE)#Here we pick 10000 (1e4) 
#samples with replacement. The probability of each sample being picked is given by the posterior.
head(samples)
plot(samples)#You can see(kind of *LOL*)that the probabilities are more densily packed about .6 or so.
hist(samples)#This is a little more helpful.
sum(samples < .5)/1e4
#So about 17% of our saples lie below a probabilit of 50 percent.
sum(samples >.5 & samples < .75)/1e4
#This tells s abot 60% of our sample posterior probabilities lie between p = .5 and p = .75.
quantile(samples, .8)
#From about p = 76% to the left hold about 80% of our sample observations.
quantile(samples, c(.1, .9))
#This show the range of sampled probabilities between the 10^th percentil ad the 90^th percentile.
