---
title: "2.5 Lecture"
output: html_document
---

```{r setup, include=FALSE}
library(readr)
doctorRatings <- read_csv("Grad School/MSBA 6250/Data Files/doctorRatings.csv")
str(doctorRatings)
summary(doctorRatings)

survey.table <- table(doctorRatings$surveyrating)
webrating.table <-table(doctorRatings$webrating)
barplot(survey.table)
barplot(webrating.table)
histogram(doctorRatings$surveyrating)

plot(doctorRatings$webrating ~ doctorRatings$surveyrating)
m1 <- lm(doctorRatings$webrating ~ doctorRatings$surveyrating)
coeff - coefficients(m1)abline(m1,col = 'red')

a1 <- aov(doctorRatings$surveyrating ~ as.factor(doctorRatings$israted))
anova(a1)
## the following line gives the rating of a standard doctor (Intercept = 79.12837) and the rating
## if the doctor is rated (1.17)
a1$coefficients 

TukeyHSD(a1)

m2 <- lm(doctorRatings$israted ~ doctorRatings$surveyrating)
summary(m2)

m3 <- lm(doctorRatings$israted ~ doctorRatings$surveyrating + doctorRatings$denver + doctorRatings$memphis
         + doctorRatings$urban + doctorRatings$largeurban + doctorRatings$population + doctorRatings$median
         +doctorRatings$rawzero + doctorRatings$ratedzero + doctorRatings$experience + doctorRatings$gender
         + doctorRatings$board)
summary(m3)

m4 <- glm(doctorRatings$israted ~ doctorRatings$surveyrating, family = binomial(link = 'logit'))
summary(m4)

m5 <- glm(doctorRatings$israted ~ doctorRatings$surveyrating + doctorRatings$denver + doctorRatings$memphis
         + doctorRatings$urban + doctorRatings$largeurban + doctorRatings$population + doctorRatings$median
         +doctorRatings$rawzero + doctorRatings$ratedzero + doctorRatings$experience + doctorRatings$gender
         + doctorRatings$board, family = binomial(link = 'logit'))
summary(m5)

quantile(doctorRatings$surveyrating)

##bins the bad doctors into sr1 and good doctors into sr4

doctorRatings$sr_1 <- ifelse(doctorRatings$surveyrating<= 75,1,0)
doctorRatings$sr_4 <- ifelse(doctorRatings$surveyrating>85, 1,0)

## shows that bad doctors are less likely to be rated, and not that good doctors are more likely to be rated

m6 <- glm(doctorRatings$israted ~ doctorRatings$sr_1 + doctorRatings$sr_4 + doctorRatings$denver + doctorRatings$memphis
          + doctorRatings$urban + doctorRatings$largeurban + doctorRatings$population + doctorRatings$median
          +doctorRatings$rawzero + doctorRatings$ratedzero + doctorRatings$experience + doctorRatings$gender
          + doctorRatings$board, family = binomial(link = 'logit'))
summary(m6)


## are web ratings dependent on survey ratings?

##subsets doctors into only those who are rated
doctorsRated <- doctorRatings[!is.na(doctorRatings$webrating),]
doctorsRated

reg1 <- lm(doctorsRated$webrating ~ doctorsRated$surveyrating)
summary(reg1)

## I'm not doing the larger models. Sorry

##splines?
## breaks the regression line into two distinct buckets
## ex. MPG vs. age

install.packages('lspline')
library('lspline')

reg1 <- lm(doctorsRated$webrating ~ lspline(doctorsRated$surveyrating, c(76,83)))
summary(reg1)

## the interpretation of this could be that web rating isn't valuable from good doctors
## good for differentiating doctors on the low end or in the intermediary

reg1 <- glm(ofratings ~ surveyrating, family = 'poisson', data = doctorRatings)
summary(reg1)
```


