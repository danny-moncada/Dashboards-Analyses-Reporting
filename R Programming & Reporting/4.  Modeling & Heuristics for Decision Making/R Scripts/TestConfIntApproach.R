## In one question I will give you a 15 element data set drawn from a normal distribution with rnorm in R. 
## By whatever methods you feel appropriate- you are to determine as closely as is possible what the actual mean 
## was set to in the rnorm generator. Within 2.5% will be considered correct.


#install.packages("bayesAB")
library(bayesAB)

true_mean = 6482
my_random_sample = rnorm(15, true_mean, 5)
my_random_sample

# sample mean, not population mean, therefore, use n-1, not n to calculate
sample_mean <- sum(my_random_sample)/(15 -1)
sample_mean

sample_var <- var(my_random_sample)
sample_var

sample_sd <- sd(my_random_sample)
sample_sd

# using Beckman to solve for alpha, beta
sample_alpha <- sample_mean ^ 2 / sample_var + 2
sample_alpha

sample_beta <- sample_mean * (sample_mean ^ 2 / sample_var + 1)
sample_beta

###########################################################################################################
# generate distributions at .x prescision to find where 0 is right in the middle of the confidence interval
###########################################################################################################

U.9 <- rnorm(20, sample_mean + .9*sample_mean, sample_sd)
U.8 <- rnorm(20, sample_mean + .8*sample_mean, sample_sd)
U.7 <- rnorm(20, sample_mean + .7*sample_mean, sample_sd)
U.6 <- rnorm(20, sample_mean + .6*sample_mean, sample_sd)
U.5 <- rnorm(20, sample_mean + .5*sample_mean, sample_sd)
U.4 <- rnorm(20, sample_mean + .4*sample_mean, sample_sd)
U.3 <- rnorm(20, sample_mean + .3*sample_mean, sample_sd)
U.2 <- rnorm(20, sample_mean + .2*sample_mean, sample_sd)
U.1 <- rnorm(20, sample_mean + .1*sample_mean, sample_sd)

base <- rnorm(20, sample_mean, sample_sd)

D.1 <- rnorm(20, sample_mean - .1*sample_mean, sample_sd)
D.2 <- rnorm(20, sample_mean - .2*sample_mean, sample_sd)
D.3 <- rnorm(20, sample_mean - .3*sample_mean, sample_sd)
D.4 <- rnorm(20, sample_mean - .4*sample_mean, sample_sd)
D.5 <- rnorm(20, sample_mean - .5*sample_mean, sample_sd)
D.6 <- rnorm(20, sample_mean - .6*sample_mean, sample_sd)
D.7 <- rnorm(20, sample_mean - .7*sample_mean, sample_sd)
D.8 <- rnorm(20, sample_mean - .8*sample_mean, sample_sd)
D.9 <- rnorm(20, sample_mean - .9*sample_mean, sample_sd)


####################
# testing BASE CASE
####################
AB_base <- bayesTest(my_random_sample, base,
                 priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                 distribution = "normal")
summary(AB_base)
model = AB_base
output = (summary(model))
probability = output$probability[[1]][[1]]
lower = output$interval[[1]][[1]]
upper = output$interval[[1]][[2]]
center = (lower+upper)/2
cat(" Probability A>B for mu is",probability,"\n","Center of 90% Conf. Interval is at",center,"for model AB_base")


##########################
# testing UP BY .X Series
##########################
ABU.1 <- bayesTest(my_random_sample, U.1,
                  priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                  distribution = "normal")
summary(ABU.1)
model = ABU.1
output = (summary(model))
probability = output$probability[[1]][[1]]
lower = output$interval[[1]][[1]]
upper = output$interval[[1]][[2]]
center = (lower+upper)/2
cat(" Probability A>B for mu is",probability,"\n","Center of 90% Conf. Interval is at",center,"for model ABU.1")

ABU.2 <- bayesTest(my_random_sample, U.2,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")
summary(ABU.2)
model = ABU.2
output = (summary(model))
probability = output$probability[[1]][[1]]
lower = output$interval[[1]][[1]]
upper = output$interval[[1]][[2]]
center = (lower+upper)/2
cat(" Probability A>B for mu is",probability,"\n","Center of 90% Conf. Interval is at",center,"for model ABU.2")


ABU.3 <- bayesTest(my_random_sample, U.3,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")
ABU.4 <- bayesTest(my_random_sample, U.4,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")
ABU.5 <- bayesTest(my_random_sample, U.5,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")
ABU.6 <- bayesTest(my_random_sample, U.6,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")
ABU.7 <- bayesTest(my_random_sample, U.7,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")
ABU.8 <- bayesTest(my_random_sample, U.8,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")
ABU.9 <- bayesTest(my_random_sample, U.9,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")

##############################
# Testing the DOWN BY .X series
##############################
ABD.1 <- bayesTest(my_random_sample, D.1,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")
summary(ABD.1)
model = ABD.1
output = (summary(model))
probability = output$probability[[1]][[1]]
lower = output$interval[[1]][[1]]
upper = output$interval[[1]][[2]]
center = (lower+upper)/2
cat(" Probability A>B for mu is",probability,"\n","Center of 90% Conf. Interval is at",center,"for model ABD.1")

ABD.2 <- bayesTest(my_random_sample, D.2,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")
summary(ABD.2)
model = ABD.2
output = (summary(model))
probability = output$probability[[1]][[1]]
lower = output$interval[[1]][[1]]
upper = output$interval[[1]][[2]]
center = (lower+upper)/2
cat(" Probability A>B for mu is",probability,"\n","Center of 90% Conf. Interval is at",center,"for model ABD.2")

ABD.3 <- bayesTest(my_random_sample, D.3,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")
ABD.4 <- bayesTest(my_random_sample, D.4,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")
ABD.5 <- bayesTest(my_random_sample, D.5,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")
ABD.6 <- bayesTest(my_random_sample, D.6,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")
ABD.7 <- bayesTest(my_random_sample, D.7,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")
ABD.8 <- bayesTest(my_random_sample, D.8,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")
ABD.9 <- bayesTest(my_random_sample, D.9,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")

#####################################################
#  RESULTS OF THE .X PRESCISION TESTING
#####################################################
cat(" ABU.9    Prob. Mu A>B: ",(summary(ABU.9))$probability[[1]][[1]],"    Interval Center",(summary(ABU.9)$interval[[1]][[1]]+(summary(ABU.9)$interval[[1]][[2]])/2),"\n",
    "ABU.8    Prob. Mu A>B: ",(summary(ABU.8))$probability[[1]][[1]],"    Interval Center",(summary(ABU.8)$interval[[1]][[1]]+(summary(ABU.8)$interval[[1]][[2]])/2),"\n",
    "ABU.7    Prob. Mu A>B: ",(summary(ABU.7))$probability[[1]][[1]],"    Interval Center",(summary(ABU.7)$interval[[1]][[1]]+(summary(ABU.7)$interval[[1]][[2]])/2),"\n",
    "ABU.6    Prob. Mu A>B: ",(summary(ABU.6))$probability[[1]][[1]],"    Interval Center",(summary(ABU.6)$interval[[1]][[1]]+(summary(ABU.6)$interval[[1]][[2]])/2),"\n",
    "ABU.5    Prob. Mu A>B: ",(summary(ABU.5))$probability[[1]][[1]],"    Interval Center",(summary(ABU.5)$interval[[1]][[1]]+(summary(ABU.5)$interval[[1]][[2]])/2),"\n",
    "ABU.4    Prob. Mu A>B: ",(summary(ABU.4))$probability[[1]][[1]],"    Interval Center",(summary(ABU.4)$interval[[1]][[1]]+(summary(ABU.4)$interval[[1]][[2]])/2),"\n",
    "ABU.3    Prob. Mu A>B: ",(summary(ABU.3))$probability[[1]][[1]],"    Interval Center",(summary(ABU.3)$interval[[1]][[1]]+(summary(ABU.3)$interval[[1]][[2]])/2),"\n",
    "ABU.2    Prob. Mu A>B: ",(summary(ABU.2))$probability[[1]][[1]],"    Interval Center",(summary(ABU.2)$interval[[1]][[1]]+(summary(ABU.2)$interval[[1]][[2]])/2),"\n",
    "ABU.1    Prob. Mu A>B: ",(summary(ABU.1))$probability[[1]][[1]],"    Interval Center",(summary(ABU.1)$interval[[1]][[1]]+(summary(ABU.1)$interval[[1]][[2]])/2),"\n",
    "ABbase   Prob. Mu A>B: ",(summary(AB_base))$probability[[1]][[1]],"    Interval Center",(summary(AB_base)$interval[[1]][[1]]+(summary(AB_base)$interval[[1]][[2]])/2),"\n",
    "ABD.1    Prob. Mu A>B: ",(summary(ABD.1))$probability[[1]][[1]],"    Interval Center",(summary(ABD.1)$interval[[1]][[1]]+(summary(ABD.1)$interval[[1]][[2]])/2),"\n",
    "ABD.2    Prob. Mu A>B: ",(summary(ABD.2))$probability[[1]][[1]],"    Interval Center",(summary(ABD.2)$interval[[1]][[1]]+(summary(ABD.2)$interval[[1]][[2]])/2),"\n",
    "ABD.3    Prob. Mu A>B: ",(summary(ABD.3))$probability[[1]][[1]],"    Interval Center",(summary(ABD.3)$interval[[1]][[1]]+(summary(ABD.3)$interval[[1]][[2]])/2),"\n",
    "ABD.4    Prob. Mu A>B: ",(summary(ABD.4))$probability[[1]][[1]],"    Interval Center",(summary(ABD.4)$interval[[1]][[1]]+(summary(ABD.4)$interval[[1]][[2]])/2),"\n",
    "ABD.5    Prob. Mu A>B: ",(summary(ABD.5))$probability[[1]][[1]],"    Interval Center",(summary(ABD.5)$interval[[1]][[1]]+(summary(ABD.5)$interval[[1]][[2]])/2),"\n",
    "ABD.6    Prob. Mu A>B: ",(summary(ABD.6))$probability[[1]][[1]],"    Interval Center",(summary(ABD.6)$interval[[1]][[1]]+(summary(ABD.6)$interval[[1]][[2]])/2),"\n",
    "ABD.7    Prob. Mu A>B: ",(summary(ABD.7))$probability[[1]][[1]],"    Interval Center",(summary(ABD.7)$interval[[1]][[1]]+(summary(ABD.7)$interval[[1]][[2]])/2),"\n",
    "ABD.8    Prob. Mu A>B: ",(summary(ABD.8))$probability[[1]][[1]],"    Interval Center",(summary(ABD.8)$interval[[1]][[1]]+(summary(ABD.8)$interval[[1]][[2]])/2),"\n",
    "ABD.9    Prob. Mu A>B: ",(summary(ABD.9))$probability[[1]][[1]],"    Interval Center",(summary(ABD.9)$interval[[1]][[1]]+(summary(ABD.9)$interval[[1]][[2]])/2))


#####################################################
#  DETERMINING THE HUNDRETH DECIMAL PLACE
#####################################################


# Test sliding up and down at the hundreth place to see the changes until the center of the 
# confidence interval is as close to 0 as possible. When you get close, try splitting the differnece 
# at the thousandth place and go with that as a final test.


##################
# SLIDE DOWN MODEL
##################
down <- rnorm(20, sample_mean - .08*sample_mean, sample_sd)
ABdown <- bayesTest(my_random_sample, down,
                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                    distribution = "normal")
summary(ABdown)
cat("Prob. Mu A>B: ",(summary(ABdown))$probability[[1]][[1]],"    Interval Center",(summary(ABdown)$interval[[1]][[1]]+(summary(ABdown)$interval[[1]][[2]])/2))

# generate final answer
cat("Your final answer is",sample_mean  - sample_mean*.075)


##################
# SLIDE UP MODEL
##################
up <- rnorm(20, sample_mean + .055*sample_mean, sample_sd)
ABup <- bayesTest(my_random_sample, up,
                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                    distribution = "normal")
summary(ABup)
cat("Prob. Mu A>B: ",(summary(ABup))$probability[[1]][[1]],"    Interval Center",(summary(ABup)$interval[[1]][[1]]+(summary(ABup)$interval[[1]][[2]])/2))

# generate final answer
cat("Your final answer is",sample_mean+sample_mean*.055)



#WHEN PRACTICING -- Determine the marigin of error
# SLIDING DOWN
cat("You were off by",(((sample_mean  - sample_mean *.075) - true_mean) / true_mean)*100,"%")
#SLIDING UP
cat("You were off by",(((sample_mean  + sample_mean *.055) - true_mean) / true_mean)*100,"%")

