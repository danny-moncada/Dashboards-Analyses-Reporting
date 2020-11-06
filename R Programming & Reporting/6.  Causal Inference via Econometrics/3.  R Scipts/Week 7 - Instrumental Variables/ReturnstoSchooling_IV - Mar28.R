# Author: Gordon Burtch and Gautam Ray
# Course: MSBA 6440
# Session: Instrumental Variables
# Lecture 7

library(MASS)
library(stargazer)
library(AER)

MyData1<-read.csv("MROZ.csv")
MyData <- MyData1[MyData1$lfp==1,] #restricts sample to lfp=1

#OLS Model of Wage on Education

ols <- lm(log(wage)~educ+exper+expersq, data=MyData)

# 2SLS Model 'by hand'

educ.ols <- lm(educ~exper+expersq+motheduc, data=MyData)
educHat <- fitted(educ.ols)
wage.2sls <- lm(log(wage)~educHat+exper+expersq, data=MyData)

#IVREG

wage.ivreg <- ivreg(log(wage)~educ+exper+expersq|exper+expersq+motheduc, data=MyData)

stargazer(ols,wage.2sls,wage.ivreg,type="text",title="OLS vs 2SLS vs IVREG",column.labels = c("OLS","2SLS","IVREG"))


# Setting "diagnostics = TRUE" let's us assess a hausman test, weak IV stats and overidentifying tests of instrument exclusion.
summary(wage.ivreg,diagnostics=TRUE)

wage.ivreg2 <- ivreg(log(wage)~educ+exper+expersq|exper+expersq+motheduc+fatheduc, data=MyData)
summary(wage.ivreg2,diagnostics=TRUE)
