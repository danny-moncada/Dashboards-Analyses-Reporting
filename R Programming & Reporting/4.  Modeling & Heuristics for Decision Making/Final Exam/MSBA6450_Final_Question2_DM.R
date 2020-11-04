library(bayesAB)

## In one question I will give you a 15 element data set drawn from a normal distribution with rnorm in R. 
## By whatever methods you feel appropriate- you are to determine as closely as is possible what the actual mean 
## was set to in the rnorm generator. Within 2.5% will be considered correct.

random_sample = c(4.653431, 4.446646, 5.087739, 5.052033, 6.920449, 6.968938, 4.452641, 
                     4.948848, 5.054194, 4.659720, 5.939746, 5.000139, 5.034643, 4.955450, 4.066340)
random_sample

# sample mean, not ACTUAL mean
# This means I will use n-1 and not n to calculate the mean
sample_mean <- sum(random_sample)/(15 -1)
sample_mean
## [1] 5.517211

## Calculate the sample's standard deviation to use later on for my AB testing
sample_sd <- sd(random_sample)
sample_sd
## [1] 0.8386102

# Calucate the sample's alpha and beta, again for AB testing our means
sample_alpha <- sample_mean ^ 2 / sample_var + 2
sample_alpha
## [1] 45.28316

sample_beta <- sample_mean * (sample_mean ^ 2 / sample_var + 1)
sample_beta
## [1] 244.3195

## Generate a host of distributions to find where 0 is right in the middle of the confidence interval
## This helps us pin down where we should be looking

## These are DOWN sampling, decrease the sample mean very slightly 
x_d1 <- rnorm(20, sample_mean - .1*sample_mean, sample_sd)
x_d2 <- rnorm(20, sample_mean - .2*sample_mean, sample_sd)
x_d3 <- rnorm(20, sample_mean - .3*sample_mean, sample_sd)
x_d4 <- rnorm(20, sample_mean - .4*sample_mean, sample_sd)
x_d5 <- rnorm(20, sample_mean - .5*sample_mean, sample_sd)
x_d6 <- rnorm(20, sample_mean - .6*sample_mean, sample_sd)
x_d7 <- rnorm(20, sample_mean - .7*sample_mean, sample_sd)
x_d8 <- rnorm(20, sample_mean - .8*sample_mean, sample_sd)
x_d9 <- rnorm(20, sample_mean - .9*sample_mean, sample_sd)

## Right in the middle
x <- rnorm(20, sample_mean, sample_sd)

### Now we "UP" sample and increment the sample mean by .1 for ten tests
x_u1 <- rnorm(20, sample_mean + .1*sample_mean, sample_sd)
x_u2 <- rnorm(20, sample_mean + .2*sample_mean, sample_sd)
x_u3 <- rnorm(20, sample_mean + .3*sample_mean, sample_sd)
x_u4 <- rnorm(20, sample_mean + .4*sample_mean, sample_sd)
x_u5 <- rnorm(20, sample_mean + .5*sample_mean, sample_sd)
x_u6 <- rnorm(20, sample_mean + .6*sample_mean, sample_sd)
x_u7 <- rnorm(20, sample_mean + .7*sample_mean, sample_sd)
x_u8 <- rnorm(20, sample_mean + .8*sample_mean, sample_sd)
x_u9 <- rnorm(20, sample_mean + .9*sample_mean, sample_sd)


# We start by testing our "standard" x - with no up or down sampling
AB_x <- bayesTest(random_sample, x,
                  priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                  distribution = "normal")

summary(AB_x)

## P(A > B) by (0, 0)%: 
  
##  $Mu
## [1] 0.16377

## $Mu
## 5%         95% 
##  -0.29918442  0.08874215


# Test our first up sample u1
AB_u1 <- bayesTest(random_sample, x_u1,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")

summary(AB_u1)


## P(A > B) by (0, 0)%: 
  
##  $Mu
## [1] 0.14785

## $Mu
## 5%        95% 
##  -0.30552780  0.08134323

## The confidence interval is pretty good but the probability score is not so we keep testing/searching

## Testing the next level up, u2 (GREAT BAND NOT!)
AB_u2 <- bayesTest(random_sample, x_u2,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")

summary(AB_u2)

## P(A > B) by (0, 0)%: 
  
##  $Mu
## [1] 0.00763

## $Mu
## 5%         95% 
##   -0.39931511 -0.08759424 

## I did worse with my probability score here and my confidence interval got bigger, so we might need to switch gears
## Let's keep testing our up samples

## testing U3
AB_u3 <- bayesTest(random_sample, x_u3,
                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                    distribution = "normal")
 
summary(AB_u3)

## P(A > B) by (0, 0)%: 
  
##  $Mu
## [1] 0.0027

## $Mu
## 5%        95% 
##  -0.4208664 -0.1261988

## I keep getting further away from where I want so I am going to stop "upsampling" from this point. Let's try a change
## in direction and see how that goes. I'll leave a sample block of code if I want continuing these tests below.

## testing u4 - u9
## AB_u4 <- bayesTest(random_sample, x_u4,
##                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
##                    distribution = "normal")
## 
## summary(AB_u)

## Going to switch gears - we'll test our down samples next
## I start with the first one I generated and see how I do
AB_d1 <- bayesTest(random_sample, x_d1,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")

summary(AB_d1)

## P(A > B) by (0, 0)%: 
  
##  $Mu
## [1] 0.66839

## $Mu
## 5%        95% 
##   -0.1640601  0.3457455

## OK!  Going down gave me a much better probability score than any of my initial test. Let's keep going.

## testing d2
AB_d2 <- bayesTest(random_sample, x_d2,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")

summary(AB_d2)

## P(A > B) by (0, 0)%: 
  
##  $Mu
## [1] 0.55927

## $Mu
## 5%        95% 
##  -0.1954270  0.2867777

## We're getting closer by going down, let's see!

## testing d3
AB_d3 <- bayesTest(random_sample, x_d3,
                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                    distribution = "normal")
 
summary(AB_d3)

## P(A > B) by (0, 0)%: 

## $Mu
## [1] 0.93306

## $Mu
## 5%         95% 
##  -0.02249764  0.64572698

## We went WAY out of bounds here, our probability shot in the other direction - so I guess that means we went too far.

## Leaving 
## AB_d4 <- bayesTest(random_sample, x_d4,
##                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
##                    distribution = "normal")
## 
## summary(AB_d4)

## Based on my first group of tests, we're probably in between -.1 and -.2
## Let's generate another set of distributions, in between -.1 and -.2

x_d01 <- rnorm(20, sample_mean - .01*sample_mean, sample_sd)
x_d02 <- rnorm(20, sample_mean - .02*sample_mean, sample_sd)
x_d03 <- rnorm(20, sample_mean - .03*sample_mean, sample_sd)
x_d04 <- rnorm(20, sample_mean - .04*sample_mean, sample_sd)
x_d05 <- rnorm(20, sample_mean - .05*sample_mean, sample_sd)
x_d06 <- rnorm(20, sample_mean - .06*sample_mean, sample_sd)
x_d07 <- rnorm(20, sample_mean - .07*sample_mean, sample_sd)
x_d08 <- rnorm(20, sample_mean - .08*sample_mean, sample_sd)
x_d09 <- rnorm(20, sample_mean - .09*sample_mean, sample_sd)

## testing D01
AB_d01 <- bayesTest(random_sample, x_d01,
                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                    distribution = "normal")

summary(AB_d01)

## P(A > B) by (0, 0)%: 
  
##   $Mu
## [1] 0.43987

## $Mu
## 5%        95% 
##   -0.2245730  0.2295821

## testing D03
AB_d03 <- bayesTest(random_sample, x_d03,
                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                    distribution = "normal")

summary(AB_d03)

## P(A > B) by (0, 0)%: 
  
##   $Mu
## [1] 0.39004

## $Mu
## 5%        95% 
##   -0.2366227  0.2033874

## testing D05
AB_d05 <- bayesTest(random_sample, x_d05,
                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                    distribution = "normal")

summary(AB_d05)

## P(A > B) by (0, 0)%: 
  
##  $Mu
## [1] 0.34145

## $Mu
## 5%        95% 
##  -0.2496420  0.1804096 


# testing D06
AB_d06 <- bayesTest(random_sample, x_d06,
                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                    distribution = "normal")

summary(AB_d06)

## P(A > B) by (0, 0)%: 
  
##   $Mu
## [1] 0.56228

## $Mu
## 5%        95% 
##   -0.1939512  0.2898081


## I went a little bit of the rails between -.04 and -.05, but then -.06 brought me back on track.
## I am starting to think that it will land between -.05 and -.06.

## Generate a new test point right in the middle of -.05 and -.06
x_d055 <- rnorm(20, sample_mean - .055*sample_mean, sample_sd)

## Testing D055
AB_d055 <- bayesTest(random_sample, x_d055,
                     priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                     distribution = "normal")

summary(AB_d055)

## P(A > B) by (0, 0)%: 
  
##  $Mu
## [1] 0.50752

## $Mu
## 5%        95% 
##   -0.2227711  0.2321686

## $Mu
## 5%        95% 
##  -0.2080874  0.2594702

plot(AB_d055)

## DING DING DING!  We might have a winner here.  A very nice probability score and
## a confidence interval centered around zero, equally distributed.
## It looks like our true mean is going to be our sample mean - sample_mean*0.55
## Let's calculate this and get our population mean!

population_mean <- sample_mean  - sample_mean * .055
population_mean
## [1] 5.213765

## Looking at the upper and lower bounds by .03
population_mean+population_mean*.03
## [1] 5.370178
population_mean-population_mean*.03
## [1] 5.057352