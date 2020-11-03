#Charles Example
library(bayesAB)

A_sample<-c(4,96)#4 out of 96 Click Through Rate on webpage 1.
B_sample<-c(45,1280)#45 our of 1280 Click Through Rate on webpage 2.

fisher.test(data.frame(A_sample,B_sample))

##
##  Fisher's Exact Test for Count Data
##
## data:  data.frame(A_sample, B_sample)
## p-value = 0.7727
## alternative hypothesis: true odds ratio is not equal to 1
## 95 percent confidence interval:
##  0.3031585 3.3528400
## sample estimates:
## odds ratio
##   1.185033 #No significant difference

#We launched a power test here to check the sample size we need.
power.prop.test(p1=4/96,p2=45/1280,power=0.8,sig.level = 0.05)
##
##      Two-sample comparison of proportions power calculation
##
##               n = 13678.32
##              p1 = 0.04166667
##              p2 = 0.03515625
##       sig.level = 0.05
##           power = 0.8
##     alternative = two.sided
##
## NOTE: n is number in *each* group
A_s<-rbinom(96,1,4/96)#Here we are creating a binomial data set of 96 elements 
#with prior beta(Theta| 1,1) - a noninformative prior with p = 4/96.  Similar below :- )
B_s<-rbinom(1280,1,45/1280)
AB1 <- bayesTest(A_s, B_s,
                 priors = c('alpha' = 1, 'beta' = 1),
                 distribution = 'bernoulli')
summary(AB1)

## Quantiles of posteriors for A and B:
##
## $Probability
## $Probability$A_probs
##           0%          25%          50%          75%         100%
## 0.0008017126 0.0348436245 0.0480286692 0.0639101508 0.1990413449
##
## $Probability$B_probs
##         0%        25%        50%        75%       100%
## 0.01738483 0.03152084 0.03488182 0.03840652 0.06333131
##
##
## --------------------------------------------
##
## P(A > B) by (0)%:
##
## $Probability
## [1] 0.7414
##
## --------------------------------------------
##
## Credible Interval on (A - B) / B for interval length(s) (0.9) :
##
## $Probability
##         5%        95%
## -0.4267753  1.7670381
##
## --------------------------------------------
##
## Posterior Expected Loss for choo## [1] 0.009537639
## Choosing B over A:
##
## $Probability
## [1] 0.009537639
plot(AB1)

