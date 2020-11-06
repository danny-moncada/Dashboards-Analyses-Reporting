# Authors: Gordon Burtch and Gautam Ray
# Course: MSBA 6440
# Session: Fixed Effects
# Topic: Returns to Education Fixed Effects
# Lecture 5

library(stargazer)
library(plm)

PData<-read.csv("KoopTobias.csv")
     
# Let's try a fixed effect regression.   

within_reg <- plm(data=PData,LOGWAGE~EDUC,index=c("PERSONID"),effect="individual",model="within")

pooling_reg <- plm(data=PData,LOGWAGE~EDUC,index=c("PERSONID"),effect="individual",model="pooling")

ols_reg <-lm(data=PData,LOGWAGE~EDUC)

#Let's see if panel data model is needed

pFtest(within_reg, pooling_reg)

stargazer(within_reg,pooling_reg, ols_reg, title="Within vs. Pooling Models vs. OLS",column.labels = c("Within", "Pooling", "OLS"), type="text")

# Fixed Effect vs Random Effect

within_reg <- plm(data=PData,LOGWAGE~EDUC + ABILITY,index=c("PERSONID"),effect="individual",model="within")

random_reg = plm(LOGWAGE ~ EDUC + ABILITY, data = PData, index=c("PERSONID"), effect="individual", model="random")

stargazer(within_reg,random_reg, title="Fixed vs. Random Effect Model",column.labels = c("Within", "Random"), type="text")


# Hausman test
phtest(within_reg, random_reg)


#Serial Correlation (Breusch Godfrey Test)

pbgtest(within_reg)


#Testing for Hetroskedasticity

library(lmtest)

bptest(LOGWAGE ~ EDUC + factor(PERSONID), data = PData)

#Hetroskedasticity and Serial Correlation Consistent Estimator

coeftest(within_reg) # Original coefficients

coeftest(within_reg, vcovHC) # Heteroskedasticity consistent coefficients