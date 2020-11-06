#Specia thanks to Florian Hartig for this great R example.  
#As a first step, we create some test data that will be used to fit our model. 
#Let's assume a linear relationship between the predictor and the response variable, 
#so we take a linear model and add some noise.
#Note the actual equatio without noise is y = 5x :- )

trueA <- 5
trueB <- 0
trueSd <- 10
sampleSize <- 31

# create independent x-values 
x <- (-(sampleSize-1)/2):((sampleSize-1)/2)#Notice this creates [-15, 15] in Z.
x
# create dependent values according to ax + b + N(0,sd)
y <-  trueA * x + trueB + rnorm(n=sampleSize,mean=0,sd=trueSd)

plot(x,y, main="Test Data")

#I balanced x values around zero to "de-correlate" slope and intercept.
#The result should look something like the figure to the right

#So, given that our linear model y = b + a*x + N(0,sd) takes the parameters (a, b, sd) as an input, 
#we have to return the probability of obtaining the test data above under this model 
#This sounds more complicated as it is, as you see in the code - we simply calculate the difference 
#between predictions y = b + a*x and the observed y, and then we have to look up the probability densities
#(using dnorm) for such deviations to occur.

likelihood <- function(param){
  a = param[1]
  b = param[2]
  sd = param[3]
  
  pred = a*x + b
  singlelikelihoods = dnorm(y, mean = pred, sd = sd, log = T)
  sumll = sum(singlelikelihoods)
  return(sumll)   
}

#Why we work with logarithms

#You might have noticed that I return the logarithm of the probabilities in the likelihood function, 
#which is also the reason why I sum the probabilities of all our datapoints
#(the logarithm of a product equals the sum of the logarithms). 
#Why do we do this? You don't have to, but it's strongly advisable because likelihoods, 
#where a lot of small probabilities are multiplied, can get ridiculously small pretty fast (something like 10^-34). 
#At some stage, computer programs are getting into numerical rounding or underflow problems then. 
#So, bottom-line: when you program something with likelihoods, always use logarithms!!!

# Example: plot the likelihood profile of the slope a
slopevalues <- function(x){return(likelihood(c(x, trueB, trueSd)))}
slopelikelihoods <- lapply(seq(3, 7, by=.05), slopevalues )
plot (seq(3, 7, by=.05), slopelikelihoods , type="l", xlab = "values of slope parameter a", ylab = "Log likelihood")
#Defining the prior

#As a second step, as always in Bayesian statistics, 
#we have to specify a prior distribution for each parameter. 
#To make it easy, I used uniform distributions and normal distributions for all three parameters.

# Prior distribution
prior <- function(param){
  a = param[1]
  b = param[2]
  sd = param[3]
  aprior = dunif(a, min=0, max=10, log = T)
  bprior = dnorm(b, sd = 5, log = T)
  sdprior = dunif(sd, min=0, max=30, log = T)
  return(aprior+bprior+sdprior)
}

#The posterior

#The product of prior and likelihood is the actual quantity the MCMC will be working on. 
#This function is called the posterior 
#(or to be exact, it's called the posterior after it's normalized, which the MCMC will do for us, 
#but let's not be picky for the moment). Again, here we work with the sum because we work with logarithms.

posterior <- function(param){
  return (likelihood(param) + prior(param))
}

#MCMC
#Now, here comes the actual Metropolis-Hastings algorithm. 
#One of the most frequent applications of this algorithm (as in this example) 
#is sampling from the posterior density in Bayesian statistics. 
#In principle, however, the algorithm may be used to sample from any integrable function. 
#So, the aim of this algorithm is to jump around in parameter space, 
#but in a way that the probability to be at a point is proportional to the function we sample from 
#(this is usually called the target function). In our case this is the posterior defined above.

#This is achieved by
#1. Starting at a random parameter value
#2.  Choosing a new parameter value close to the old value based on some probability density 
#that is called the proposal function
#3.  Jumping to this new point with a probability p(new)/p(old), 
#where p is the target function, and p>1 means jumping as well.

######## Metropolis algorithm ################

proposalfunction <- function(param){
  return(rnorm(3,mean = param, sd= c(0.1,0.5,0.3)))
}

run_metropolis_MCMC <- function(startvalue, iterations){
  chain = array(dim = c(iterations+1,3))
  chain[1,] = startvalue
  for (i in 1:iterations){
    proposal = proposalfunction(chain[i,])
    
    probab = exp(posterior(proposal) - posterior(chain[i,]))
    if (runif(1) < probab){
      chain[i+1,] = proposal
    }else{
      chain[i+1,] = chain[i,]
    }
  }
  return(chain)
}

startvalue = c(4,0,10)
chain = run_metropolis_MCMC(startvalue, 10000)

burnIn = 5000
acceptance = 1-mean(duplicated(chain[-(1:burnIn),]))
### Summary: #######################

par(mfrow = c(2,3))
hist(chain[-(1:burnIn),1],nclass=30, , main="Posterior of a", xlab="True value = red line" )
abline(v = mean(chain[-(1:burnIn),1]))
abline(v = trueA, col="red" )
hist(chain[-(1:burnIn),2],nclass=30, main="Posterior of b", xlab="True value = red line")
abline(v = mean(chain[-(1:burnIn),2]))
abline(v = trueB, col="red" )
hist(chain[-(1:burnIn),3],nclass=30, main="Posterior of sd", xlab="True value = red line")
abline(v = mean(chain[-(1:burnIn),3]) )
abline(v = trueSd, col="red" )
plot(chain[-(1:burnIn),1], type = "l", xlab="True value = red line" , main = "Chain values of a", )
abline(h = trueA, col="red" )
plot(chain[-(1:burnIn),2], type = "l", xlab="True value = red line" , main = "Chain values of b", )
abline(h = trueB, col="red" )
plot(chain[-(1:burnIn),3], type = "l", xlab="True value = red line" , main = "Chain values of sd", )
abline(h = trueSd, col="red" )

# for comparison:
summary(lm(y~x))
