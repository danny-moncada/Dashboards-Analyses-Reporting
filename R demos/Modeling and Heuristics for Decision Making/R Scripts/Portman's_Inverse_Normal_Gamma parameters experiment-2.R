library(bayesAB)
library(tidyverse)

A_norm <- rnorm(100, 6, 1.5)
B_norm <- rnorm(100, 5, 2.5)
#Frank Portman's bayesAB is a fantastic R program and we've seen in class 
#how to parameterize the Beta and Possion priors.
#How to find the four parmeters in the Inverse Normal Gamma distribution is 
#another matter *LOL*.  Dr. Portman uses the following example without and 
#sort of reference as to how he picked his parameters.  Let's investigate this :- )
#The parameters for the prior ar mu, lambda, alpha, and beta.
#Mu is the mean od the distribution in B or the sample distribution
#as in general-we will not know the actual.  For our purposes lambda will always be 1.
#Now Portman has alpha = 3 and beta = 1.
#Let's take a look.
plotNormalInvGamma(5,1,3,1)
#Now in "Estimating an Inverse Gamma distribution", by A. Llera, C. F. Beckmann
#we are given these approximations.  mu is the sample mean, lambda = 1, and 
#alpha = mu^2/s^2 + 2, and beta = mu(mu^2/s^2 + 1) where s^2 is the sample varience.
mu=mean(B_norm)
mu
var=var(B_norm)
var
#Let's take a look :- )
alpha=mu^2/var + 2
alpha
beta=mu*(mu^2/var + 1)
beta
plotNormalInvGamma(mu, 1, alpha, beta)
#Pretty different *LOL*


AB1 <- bayesTest(A_norm, B_norm,
                 priors = c('mu' = 5, 'lambda' = 1, 'alpha' = 3, 'beta' = 1),
                 distribution = 'normal')
AB2 <- bayesTest(A_norm, B_norm,
                 priors = c('mu' = mu, 'lambda' = 1, 'alpha' = alpha, 'beta' = beta),
                 distribution = 'normal')



summary(AB1)
summary(AB2)
#The predictions are essentually the same.  Let's push it a bit :- )
#Incidently, The posteriors for the statistics 'Mean' and 'Variance' 
#are returned alongside 'Mu' and 'Sig_Sq' for interpretability.

A_norm1 <- rnorm(100, 5.1, 1.5)
B_norm1 <- rnorm(100, 5, 2.5)
#Only a 10% difference.

mu1=mean(B_norm1)
mu1
var1=var(B_norm1)
var1
#Let's take a look :- )
alpha1=mu1^2/var1 + 2
alpha1
beta1=mu1*(mu1^2/var1 + 1)
beta1
plotNormalInvGamma(mu1, 1, alpha1, beta1)



AB3 <- bayesTest(A_norm1, B_norm1,
                 priors = c('mu' = 5, 'lambda' = 1, 'alpha' = 3, 'beta' = 1),
                 distribution = 'normal')
AB4 <- bayesTest(A_norm, B_norm,
                 priors = c('mu' = mu1, 'lambda' = 1, 'alpha' = alpha1, 'beta' = beta1),
                 distribution = 'normal')



summary(AB3)
summary(AB4)
#Interesting!!!!!


A_norm2 <- rnorm(100, 5.01, 1.5)
B_norm2 <- rnorm(100, 5, 2.5)
#Only a 1% difference.

mu2=mean(B_norm2)
mu2
var2=var(B_norm2)
var2
#Let's take a look :- )
alpha2=mu2^2/var2 + 2
alpha2
beta2=mu2*(mu2^2/var2 + 1)
beta2
plotNormalInvGamma(mu2, 1, alpha2, beta2)



AB5 <- bayesTest(A_norm2, B_norm2,
                 priors = c('mu' = 5, 'lambda' = 1, 'alpha' = 3, 'beta' = 1),
                 distribution = 'normal')
AB6 <- bayesTest(A_norm, B_norm,
                 priors = c('mu' = mu2, 'lambda' = 1, 'alpha' = alpha2, 'beta' = beta2),
                 distribution = 'normal')



summary(AB5)
summary(AB6)
#In my trial runs setting the priors in accordance with the sited paper
#yeild as good or better results.  Now we need to investigate what happens
#when we shift the sample variences :- )


A_norm3 <- rnorm(100, 5.1, 10.5)#Let's radically shift this varience 
B_norm3 <- rnorm(100, 5, 2.5)
#Only a 10% difference.

mu3=mean(B_norm3)
mu3
var3=var(B_norm3)
var3
#Let's take a look :- )
alpha3=mu3^2/var3 + 2
alpha3
beta3=mu3*(mu3^2/var3 + 1)
beta3
plotNormalInvGamma(mu3, 1, alpha3, beta3)



AB7 <- bayesTest(A_norm3, B_norm3,
                 priors = c('mu' = 5, 'lambda' = 1, 'alpha' = 3, 'beta' = 1),
                 distribution = 'normal')
AB8 <- bayesTest(A_norm, B_norm,
                 priors = c('mu' = mu3, 'lambda' = 1, 'alpha' = alpha3, 'beta' = beta3),
                 distribution = 'normal')



summary(AB7)
summary(AB8)
#In my runs ere both models we not particularly good, but "our" prior seemed to do better.
######################################################################################3
#This tie let's radically shift the B_norm variation whilst restoring that of A_norm.
A_norm4 <- rnorm(100, 5.1, 1.5)
B_norm4 <- rnorm(100, 5, 20.5)#Change the B_norm s.d. from2.5 to 20.5.
#Only a 10% difference.

mu4=mean(B_norm4)
mu4
var4=var(B_norm4)
var4

alpha4=mu4^2/var4 + 2
alpha4
beta4=mu4*(mu4^2/var3 + 1)
beta4
plotNormalInvGamma(mu4, 1, alpha4, beta4)



AB9 <- bayesTest(A_norm3, B_norm3,
                 priors = c('mu' = 5, 'lambda' = 1, 'alpha' = 3, 'beta' = 1),
                 distribution = 'normal')
AB10 <- bayesTest(A_norm, B_norm,
                 priors = c('mu' = mu4, 'lambda' = 1, 'alpha' = alpha4, 'beta' = beta4),
                 distribution = 'normal')



summary(AB9)
summary(AB10)
#"Our" Prior method does significantly better!
#One more case - both samples have large variences.

A_norm5 <- rnorm(100, 5.1, 10.5)#Let's radically shiftboth statnard deviations.
B_norm5 <- rnorm(100, 5, 20.5)
#Only a 10% difference.

mu5=mean(B_norm5)
mu5
var5=var(B_norm5)
var5

alpha5=mu5^2/var5 + 2
alpha5
beta5=mu5*(mu5^2/var5 + 1)
beta5
plotNormalInvGamma(mu5, 1, alpha5, beta5)



AB11 <- bayesTest(A_norm5, B_norm5,
                 priors = c('mu' = 5, 'lambda' = 1, 'alpha' = 3, 'beta' = 1),
                 distribution = 'normal')
AB12 <- bayesTest(A_norm5, B_norm5,
                 priors = c('mu' = mu5, 'lambda' = 1, 'alpha' = alpha5, 'beta' = beta5),
                 distribution = 'normal')



summary(AB11)
summary(AB12)
#Here they are about the same again :- )