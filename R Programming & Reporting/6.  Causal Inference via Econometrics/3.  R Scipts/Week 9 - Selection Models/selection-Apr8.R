# Author: Gordon Burtch and Gautam Ray
# Course: MSBA 6440
# Session: Selection and Measurement Error
# Topic: Selection Model Example
# Lecture 9


suppressWarnings(suppressPackageStartupMessages({
library(sampleSelection)
library(stargazer)
}))

MROZ <-read.csv("MROZ.csv")

MROZ$kids <- (MROZ$kidslt6 + MROZ$kidsge6)

# Female labor supply (lfp = labour force participation)

## Outcome equations without correcting for selection
# I() means "as-is" -- do calculation in parentheses then use as variable

## Comparison of linear regression and selection model

outcome1 <- lm(wage ~ educ, data = MROZ)
summary(outcome1)

selection1 <- selection(selection = lfp ~ age + I(age^2) + faminc + kidslt6 + educ, 
                        outcome = wage ~ educ, 
                        data = MROZ, method = "2step")
summary(selection1)

plot(MROZ$wage ~ MROZ$educ)
curve(outcome1$coeff[1] + outcome1$coeff[2]*x, col="black", lwd="2", add=TRUE)
curve(selection1$coeff[7] + selection1$coeff[8]*x, col="orange", lwd="2", add=TRUE)


## A more complete model comparison

outcome2 <- lm(wage ~ exper + I( exper^2 ) + educ + city, data = MROZ)
summary(outcome2)

## Correcting for selection

selection.twostep2 <- selection(selection = lfp ~ age + I(age^2) + faminc + kidslt6 + educ, 
                                outcome = wage ~ exper + I(exper^2) + educ + city, 
                                data = MROZ, method = "2step")
summary(selection.twostep2)

selection.mle <- selection(selection = lfp ~ age + I(age^2) + faminc + kids + educ, 
                           outcome = wage ~ exper + I(exper^2) + educ + city, 
                           data = MROZ, method = "mle")
summary(selection.mle)


## Heckman model selection "by hand" ##

seleqn1 <- glm(lfp ~ age + I(age^2) + faminc + kidslt6 + educ, family=binomial(link="probit"), 
               data=MROZ)
summary(seleqn1)

## Calculate inverse Mills ratio by hand ##

MROZ$IMR <- dnorm(seleqn1$linear.predictors)/pnorm(seleqn1$linear.predictors)

## Outcome equation correcting for selection ##

outeqn1 <- lm(wage ~ exper + I(exper^2) + educ + city + IMR, data=MROZ, subset=(lfp==1))
summary(outeqn1)

## compare to selection package -- coefficients right, se's wrong

summary(selection.twostep2)

stargazer(outeqn1,selection.twostep2,type="text",title="Heckman Two-step vs.Heckman by Hand",
          column.labels = c("Heckman By Hand","Heckman Command"))


