library(bayesAB)


## In one question I will give you a 15 element data set drawn from a normal distribution with rnorm in R. 
## By whatever methods you feel appropriate- you are to determine as closely as is possible what the actual mean 
## was set to in the rnorm generator. Within 2.5% will be considered correct.


my_random_sample <- rnorm(15, 60, 5)
my_random_sample
# 67.40145 59.78685 68.66153 64.01166 54.43690 53.11176 64.95808 58.99665 70.72413 51.79857 58.43458 54.22028 65.47009 56.98714 59.20529



# sample mean, not population mean
# therefore, use n-1, not n to calculate
sample_mean <- sum(my_random_sample)/(15 -1)
sample_mean
# 64.87178


sample_var <- var(my_random_sample)
sample_var
#35.9426


sample_sd <- sd(my_random_sample)
sample_sd
#5.995215


# using Beckman to solve for alpha, beta
sample_alpha <- sample_mean ^ 2 / sample_var + 2
sample_alpha
#119.0853

sample_beta <- sample_mean * (sample_mean ^ 2 / sample_var + 1)
sample_beta
#7660.401



# generate distributions to find where 0 is right in the middle of the confidence interval

x_D9 <- rnorm(20, sample_mean - .9*sample_mean, sample_sd)
x_D8 <- rnorm(20, sample_mean - .8*sample_mean, sample_sd)
x_D7 <- rnorm(20, sample_mean - .7*sample_mean, sample_sd)
x_D6 <- rnorm(20, sample_mean - .6*sample_mean, sample_sd)
x_D5 <- rnorm(20, sample_mean - .5*sample_mean, sample_sd)
x_D4 <- rnorm(20, sample_mean - .4*sample_mean, sample_sd)
x_D3 <- rnorm(20, sample_mean - .3*sample_mean, sample_sd)
x_D2 <- rnorm(20, sample_mean - .2*sample_mean, sample_sd)
x_D1 <- rnorm(20, sample_mean - .1*sample_mean, sample_sd)

x <- rnorm(20, sample_mean, sample_sd)

x_U1 <- rnorm(20, sample_mean + .1*sample_mean, sample_sd)
x_U2 <- rnorm(20, sample_mean + .2*sample_mean, sample_sd)
x_U3 <- rnorm(20, sample_mean + .3*sample_mean, sample_sd)
x_U4 <- rnorm(20, sample_mean + .4*sample_mean, sample_sd)
x_U5 <- rnorm(20, sample_mean + .5*sample_mean, sample_sd)
x_U6 <- rnorm(20, sample_mean + .6*sample_mean, sample_sd)
x_U7 <- rnorm(20, sample_mean + .7*sample_mean, sample_sd)
x_U8 <- rnorm(20, sample_mean + .8*sample_mean, sample_sd)
x_U9 <- rnorm(20, sample_mean + .9*sample_mean, sample_sd)



# testing standard variable
AB_X <- bayesTest(my_random_sample, x,
                 priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                 distribution = "normal")

summary(AB_X)

# P(A > B) by (0, 0)%: 
#   
#   $Mu
# [1] 0.01005
# 
# $Mu
# 5%         95% 
#   -0.15245614 -0.02811822


# testing U1
AB_U1 <- bayesTest(my_random_sample, x_U1,
                  priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                  distribution = "normal")

summary(AB_U1)


# P(A > B) by (0, 0)%: 
#   
#   $Mu
# [1] 6e-04
# 
# 
# $Mu
# 5%         95% 
#   -0.18031948 -0.06185815 


# testing U2
AB_U2 <- bayesTest(my_random_sample, x_U2,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")

summary(AB_U2)


# $Mu
# 5%        95% 
#   -0.2639888 -0.1618352 
# 
# P(A > B) by (0, 0)%: 
#   
#   $Mu
# [1] 0


# this is going the wrong direction and getting further from 0 in the middle of the CI and for A>B about 50%



# # testing U3
# AB_U3 <- bayesTest(my_random_sample, x_U3,
#                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
#                    distribution = "normal")
# 
# summary(AB_U3)
# 
# 
# 
# 
# 
# # testing U4
# AB_U4 <- bayesTest(my_random_sample, x_U4,
#                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
#                    distribution = "normal")
# 
# summary(AB_U4)
# 
# 
# 
# 
# 
# 
# # testing U5
# AB_U5 <- bayesTest(my_random_sample, x_U5,
#                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
#                    distribution = "normal")
# 
# summary(AB_U5)
# 
# 
# 
# 
# 
# # testing U6
# AB_U6 <- bayesTest(my_random_sample, x_U6,
#                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
#                    distribution = "normal")
# 
# summary(AB_U6)
# 
# 
# 
# 
# 
# # testing U7
# AB_U7 <- bayesTest(my_random_sample, x_U7,
#                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
#                    distribution = "normal")
# 
# summary(AB_U7)
# 
# 
# 
# 
# 
# # testing U8
# AB_U8 <- bayesTest(my_random_sample, x_U8,
#                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
#                    distribution = "normal")
# 
# summary(AB_U8)
# 
# 
# 
# 
# 
# # testing U9
# AB_U9 <- bayesTest(my_random_sample, x_U9,
#                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
#                    distribution = "normal")
# 
# summary(AB_U9)




# testing D1
AB_D1 <- bayesTest(my_random_sample, x_D1,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")

summary(AB_D1)


# $Mu
# 5%         95% 
#   -0.01746107  0.13786421 
# 
# 
# P(A > B) by (0, 0)%: 
#   
#   $Mu
# [1] 0.89659



# testing D2
AB_D2 <- bayesTest(my_random_sample, x_D2,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")

summary(AB_D2)



# $Mu
# 5%       95% 
#   0.1088099 0.2949644 
# 
# P(A > B) by (0, 0)%: 
#   
#   $Mu
# [1] 0.99997


# this got really big, really fast.
# so far, X has been the closest. I am going to recreate with smaller increments



# # testing D3
# AB_D3 <- bayesTest(my_random_sample, x_D3,
#                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
#                    distribution = "normal")
# 
# summary(AB_D3)
# 
# 
# 
# 
# # testing D4
# AB_D4 <- bayesTest(my_random_sample, x_D4,
#                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
#                    distribution = "normal")
# 
# summary(AB_D4)
# 
# 
# 
# 
# # testing D5
# AB_D5 <- bayesTest(my_random_sample, x_D5,
#                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
#                    distribution = "normal")
# 
# summary(AB_D5)
# 
# 
# 
# 
# # testing D6
# AB_D6 <- bayesTest(my_random_sample, x_D6,
#                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
#                    distribution = "normal")
# 
# summary(AB_D6)
# 
# 
# 
# 
# # testing D7
# AB_D7 <- bayesTest(my_random_sample, x_D7,
#                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
#                    distribution = "normal")
# 
# summary(AB_D7)
# 
# 
# 
# 
# # testing D8
# AB_D8 <- bayesTest(my_random_sample, x_D8,
#                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
#                    distribution = "normal")
# 
# summary(AB_D8)
# 
# 
# 
# 
# # testing D9
# AB_D9 <- bayesTest(my_random_sample, x_D9,
#                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
#                    distribution = "normal")
# 
# summary(AB_D9)












# based on the couple trials I did, it's likely between x and x_D1


x_D01 <- rnorm(20, sample_mean - .01*sample_mean, sample_sd)
x_D02 <- rnorm(20, sample_mean - .02*sample_mean, sample_sd)
x_D03 <- rnorm(20, sample_mean - .03*sample_mean, sample_sd)
x_D04 <- rnorm(20, sample_mean - .04*sample_mean, sample_sd)
x_D05 <- rnorm(20, sample_mean - .05*sample_mean, sample_sd)
x_D06 <- rnorm(20, sample_mean - .06*sample_mean, sample_sd)
x_D07 <- rnorm(20, sample_mean - .07*sample_mean, sample_sd)
x_D08 <- rnorm(20, sample_mean - .08*sample_mean, sample_sd)
x_D09 <- rnorm(20, sample_mean - .09*sample_mean, sample_sd)




# testing D01
AB_D01 <- bayesTest(my_random_sample, x_D01,
                   priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                   distribution = "normal")

summary(AB_D01)



# $Mu
# 5%         95% 
#   -0.09845452  0.03657607
# 
# 
# P(A > B) by (0, 0)%: 
#   
#   $Mu
# [1] 0.21402




# testing D03
AB_D03 <- bayesTest(my_random_sample, x_D03,
                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                    distribution = "normal")

summary(AB_D03)

# $Mu
# 5%        95% 
#   -0.1012958  0.0328583 
# 
#  
# P(A > B) by (0, 0)%: 
#   
#   $Mu
# [1] 0.19009





# testing D05
AB_D05 <- bayesTest(my_random_sample, x_D05,
                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                    distribution = "normal")

summary(AB_D05)

# $Mu
# 5%         95% 
#   -0.08015936  0.05907628 
#  
#   
# P(A > B) by (0, 0)%: 
#   
#   $Mu
# [1] 0.38359





# testing D06
AB_D06 <- bayesTest(my_random_sample, x_D06,
                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                    distribution = "normal")

summary(AB_D06)

# $Mu
# 5%         95% 
#   -0.05763803  0.08707198 
#   
#    
# P(A > B) by (0, 0)%: 
#   
#   $Mu
# [1] 0.61359





# this is the closest I've gotten
# It seems to be somewhere between down .05 and down .06
# I could continue to go out decimal places if I wanted to fine tune


x_D055 <- rnorm(20, sample_mean - .055*sample_mean, sample_sd)






# testing D055
AB_D055 <- bayesTest(my_random_sample, x_D055,
                    priors =  c("mu" = sample_mean,"lambda"=1, "alpha" = sample_alpha, "beta" = sample_beta), n_samples = 1e5,
                    distribution = "normal")

summary(AB_D055)



# P(A > B) by (0, 0)%: 
#   
#   $Mu
# [1] 0.51653
# 
# 
# $Mu
# 5%         95% 
#   -0.06697235  0.07546169 


# so, it would appear the true mean is sample_mean  - sample_mean * .055

sample_mean  - sample_mean * .055
# [1] 61.30384

# We know the mean started at 60, this is pretty close
((sample_mean  - sample_mean * .055) - 60) / 60
# within 2.17% of the actual