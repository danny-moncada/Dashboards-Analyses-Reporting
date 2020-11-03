#Bayesian Grid Approximation example from Statistical Rethinking - fantastic book!
#Define Grid
p_grid <- seq(from=0, to=1, length.out = 11)
#The above code makes a grid of 20 points.
p_grid#I always need to take a look as I still don't trust R *LOL*
#Define Prior

prior<- c(0, .04, .08, .12, .16, .2, .16, .12, .08, .04, 0)
prior#For this example the prior for each grid approximation is 1 which is an informative prior.  

#Compute each likelihood at each value in grid.
likelihood<- c(0, .1, .2, .3, .4, .5, .6, .7, .8, .9, 1)
likelihood
#Compute product of likelihood times the prior.
unstd.posterior<- likelihood*prior
unstd.posterior
sum(unstd.posterior)
posterior<- unstd.posterior/sum(unstd.posterior)
#Standardize the posterior so it sums to 1.
posterior
plot(p_grid, posterior, type="b",
     xlab = "", ylab="Posterior Probability")
mtext("11 points")

