
x = rnorm(100)
summary(x)

library(readxl)

# A real estate agency collects data concerning
  # house sales prices ($1000s) and house sizes (100s of square feet).

houses <- read_excel("Houses.xlsx", na = "NA", col_names = TRUE)
houses

# scatter plot w/ fitted linear regression line

plot(houses$Size, houses$Price, pch = 16, main = "Houses", xlab = "House Size (100s of square feet)",
    ylab = "Sale Price ($10000s)")
abline(lm(houses$Price ~ houses$Size), lty = 2, col = "red")

# fit the model

linefit1 <- lm(houses$Price ~ houses$Size)

# to see an information summary of the fitted model
summary(linefit1)

# to see the coefficient of determination R-squared
summary(linefit1)$r.squared

# the observed residuals, epsilon-hats
resids <- residuals(linefit1)
print(resids)

# standard deviation of the residuals = sqrt(MSE)
summary(linefit1)$sigma

par(mfrow = c(2, 2))
plot(lm(Starbucks$carb ~ Starbucks$calories))
#plot(lm(cal100s ~ Starbucks$carb))

Starbucks <- read_excel("starbucks.xlsx", na = "NA", col_names = TRUE)
head(Starbucks, 5)
#cal100s <- Starbucks$calories*100
#print(cal100s)

#plot(Starbucks$carb, Starbucks$calories, pch = 16, main = "Starbucks", xlab = "Carbs", ylab = "Calories (100s)")
#abline(lm(Starbucks$calories ~ Starbucks$carb), lty = 2, col = "red")
#linefitStarbucks <- lm(cal100s ~ Starbucks$carb)
#summary(linefitStarbucks)

plot(Starbucks$calories, Starbucks$carb, pch = 16, main = "Starbucks", xlab = "Calories (100s)", ylab = "Carbs")
abline(lm(Starbucks$carb ~ Starbucks$calories), lty = 2, col = "red")

linefitStarbucks <- lm(Starbucks$carb ~ Starbucks$calories)

summary(linefitStarbucks)

coefficients(linefitStarbucks)

print(summary(linefitStarbucks)$r.squared)

# Proportion of variation in Y that is explained by model (and variation in {Xi})
# Range [0, 1]
# 0 means it explains 0% of the variation in Y, meaning there is no relationship between these variables
# R^2 of 1 means it is explaining all of the varation in Y, which means there is a perfect relationship

summary(linefitStarbucks)$sigma

# Standard deviation of the sample errors, or in this context, the observed residuals
# The epilsons represent that part of Y that is not captured by the relationship of the X values (predictor variables)

print(anova(linefitStarbucks))

# Large F value, we can conclude that Ha is true, that there is a relationship between Carbs and Calories

head(Starbucks, 5)

resids <- residuals(linefitStarbucks) 
print(resids[2:3])

point_estimate <- 8.944 + (10.603 * 2)
print(point_estimate)

#attach(Starbucks)
#linefit_2 <- lm(carb ~ calories)
#newdata <- data.frame(calories = 2)
#predict(linefit_2, newdata, interval = 'predict', level = .90)

print(confint(linefitStarbucks, level = .90))

# Random sampling (our sample data came from an unbiased sampling of the process)
# Process stability (we're assuming that the process and the relationships in that process are relatively stable)
# Ei ~ Normal(Mean 0, SD o): Epilson terms that they are normally distributed across all values of the predictors
# Y = Uy + e
# epilson hats are estimates of epilson and can be used to test the assumptions about epilson

# Standardized residual are the z-scores of the residuals
# Normality test on the standardized residuals - is there anything wrong with our assumption of normality?

linefitStarbucks.stres <- rstandard(linefitStarbucks)
plot(Starbucks$carb, linefitStarbucks.stres, pch = 16, main = "Standardized Residual Plot", xlab = "Calories", ylab = "Standardized Residuals")
abline(0,0, lty=2, col="red")

qqnorm(linefitStarbucks.stres, main = "Normal Probability Plot", xlab = "Normal Scores", ylab = "Standardized Residuals")
qqline(linefitStarbucks.stres, col = "red")

print(shapiro.test(linefitStarbucks.stres))

attach(Starbucks)
linefit_2 <- lm(carb ~ calories)
newdata <- data.frame(calories = 4.5)

# 90% prediction interval for carbs amount for product having 450 Calories
predict(linefit_2, newdata, interval="predict", level = .90)

detach(Starbucks)

# Multiple Regression
    # Data file: see file for documentation

drywall <- read_excel("Drywall.xlsx", na = "NA", col_names = TRUE)

# Shorthand to allow referring to dataframe columns without stating the dataframe name

attach(drywall)

plot(Permits, Sales, pch = 16, xlab = "Number of Permits in County", ylab = "Sales (100s of sheets)")

plot(Mortgage, Sales, pch = 16, xlab = "Five-year Mortgage Rate", ylab = "Sales (100s of sheets)")

plot(A_Vacancy, Sales, pch = 16, xlab = "Apartment Vacancy Rate (%)", ylab = "Sales (100s of sheets)")

plot(O_Vacancy, Sales, pch = 16, xlab = "Office Vacancy Rate (%)", ylab = "Sales (100s of sheets)")

# fit the model linefit4 <- lm(Sales ~ Permits + Mortgage + A_Vacancy + O_Vacancy)
linefit4 <- lm(Sales ~ Permits + Mortgage + A_Vacancy + O_Vacancy)

# information summary of the fitted model summary(linefit4)
summary(linefit4)

# the observed residuals, epsilon-hats
residsMR <- residuals(linefit4)
print(residsMR)

# standard deviation of the residuals = sqrt(MSE)
summary(linefit4)$sigma

detach(drywall)

# A real estate agency collects data concerning 
# house sales prices ($1000s) and house sizes (100s of square feet). 
#install readxl package first

library(readxl)
houses <- read_excel("Houses.xlsx", na="NA", col_names = TRUE)
