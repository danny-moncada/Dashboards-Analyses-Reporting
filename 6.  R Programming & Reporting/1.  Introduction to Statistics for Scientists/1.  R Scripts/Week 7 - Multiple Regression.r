
library(readxl)

houses <- read_excel("Values.xlsx", na = "NA", col_names = TRUE)

attach(houses)

linefitHouses <- lm(AppraisedValue ~ LotSize + HouseSize + Age + Rooms + Baths + Garage)

summary(linefitHouses)

confint(linefitHouses, level = .95)

anova(linefitHouses)

linefitHousesr <- lm(AppraisedValue ~ Garage + Baths + Rooms + Age + HouseSize + LotSize)
summary(linefitHousesr)

## this is basura

plot(AppraisedValue, Baths, pch = 16 ,  xlab = "Baths",  ylab = "Appraised Value")
abline(lm(Baths ~ AppraisedValue), lty=2,  col= 'red')

cor(houses[,2:8])

plot(AppraisedValue, LotSize, pch = 16 ,  xlab = "LotSize",  ylab = "Appraised Value")
abline(lm(LotSize ~ AppraisedValue), lty=2,  col= 'red')

plot(AppraisedValue, HouseSize, pch = 16 ,  xlab = "HouseSize",  ylab = "Appraised Value")
abline(lm(HouseSize ~ AppraisedValue), lty=2,  col= 'red')

plot(AppraisedValue, Age, pch = 16 ,  xlab = "Age",  ylab = "Appraised Value")
abline(lm(Age ~ AppraisedValue), lty=2,  col= 'red')

linefit3 <- lm(AppraisedValue ~ HouseSize + LotSize + Age)
linefit3.stres <- rstandard(linefit3)
plot(linefit3$fitted.values, linefit3.stres, pch = 16 ,  main = "Standardized Residual Plot",  
     xlab = "Fitted Appraised Value",  ylab = "Standardized Residuals")
abline(0,0,  lty=2,  col="red")

h <- hist(linefit3.stres)
x <- linefit3.stres
xfit <- seq(min(x), max(x), length = 50 )
yfit <- dnorm(xfit, mean =mean(x), sd =sd(x))
yfit <- yfit*diff(h$mids[1:2])*length(x)
lines(xfit, yfit, col="blue")

qqnorm(linefit3.stres, main = "Normal Probability Plot",  xlab = "Normal Scores",  ylab = "Standardized Residuals")
qqline(linefit3.stres, col = "red")

shapiro.test(linefit3.stres)

# R 7.2 Detergent

library(readxl)
fresh <- read_excel("Fresh.xlsx", na = "NA", col_names = TRUE)

attach(fresh)

head(fresh)

linefitfresh <- lm(Demand ~ Price + IndPrice + AdvExp + PriceDif)

summary(linefitfresh)

cor(fresh[,5:1])

## NA as a coefficient in a regression indicates that the variable in question is linearly related
# to the other variables.

coefficients(linefitfresh)

plot(Demand, PriceDif, pch = 16 ,  xlab = "PriceDif",  ylab = "Demand")
abline(lm(PriceDif ~ Demand), lty=2,  col= 'red')

plot(Demand, AdvExp, pch = 16 ,  xlab = "AdvExp",  ylab = "Demand")
abline(lm(AdvExp ~ Demand), lty=2,  col= 'red')

plot(Demand, IndPrice, pch = 16 ,  xlab = "IndPrice",  ylab = "Demand")
abline(lm(IndPrice ~ Demand), lty=2,  col= 'red')

plot(Demand, Price, pch = 16 ,  xlab = "Price",  ylab = "Demand")
abline(lm(Price ~ Demand), lty=2,  col= 'red')

linefit2 <- lm(Demand ~ PriceDif + AdvExp)

summary(linefit2)

#linefit2 <- lm(AppraisedValue ~ HouseSize + LotSize + Age)
linefit2.stres <- rstandard(linefit2)
plot(linefit2$fitted.values, linefit2.stres, pch = 16 ,  main = "Standardized Residual Plot",  
     xlab = "Fitted Demand",  ylab = "Standardized Residuals")
abline(0,0,  lty=2,  col="red")

h <- hist(linefit2.stres)
x <- linefit2.stres
xfit <- seq(min(x), max(x), length = 50 )
yfit <- dnorm(xfit, mean =mean(x), sd =sd(x))
yfit <- yfit*diff(h$mids[1:2])*length(x)
lines(xfit, yfit, col="blue")

qqnorm(linefit2.stres, main = "Normal Probability Plot",  xlab = "Normal Scores",  ylab = "Standardized Residuals")
qqline(linefit2.stres, col = "red")

shapiro.test(linefit2.stres)

pairs(~  Demand + Price + IndPrice + AdvExp + PriceDif, main="Simple Scatterplot Matrix")

pairs(~  Demand + AdvExp + PriceDif, main="Simple Scatterplot Matrix")
