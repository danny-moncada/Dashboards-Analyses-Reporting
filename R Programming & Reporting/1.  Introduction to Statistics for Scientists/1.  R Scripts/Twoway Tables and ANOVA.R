## ANOVA Section

# Are the mean number of daily visitors to a ski resort the same for three types of snow conditions?

SnowType <- c(rep("Powder", times = 4), rep("Machine Made", times = 6), rep("Packed", times = 5))
SnowType

NumbVisitors <- c(1210, 1080, 1537, 941, 2107, 1149, 862, 1870, 1528, 1382, 2846, 1638, 2019, 1178, 2233)

# Powder_NumbVisitors(1210, 1080, 1537, 941)
# MachineMade_NumbVisitors(2107, 1149, 862, 1870, 1528, 1382)
# Packed_NumbVisitors(2846, 1638, 2019, 1178, 2233)

# ANOVA
fit <-aov(NumbVisitors ~ SnowType)

# Treatment (k - 1)
treatment = length(unique(SnowType)) - 1
treatment
# Error (n - k)
error = total_df - treatment
error
# Total DF (n - 1)
total_df = length(SnowType) - 1
total_df

# Sum of Squares Treatment
sst = 1468909
sst
# Sum of Squares Error
sse = 2819077
sse
# Sum of Squares Total
sstotal = sst + sse
sstotal

# Mean of Squares Treatment
mst = 1468909 / 2
mst

# Mean of Squares Error
mse = 2819077 / 12
mse

# F-Value
f_value = round(mst / mse, 3)
f_value

summary(fit)

print(model.tables(fit, "means"))

boxplot(NumbVisitors ~ SnowType)

# Assumption checks
  # Residual = Actual - Category mean
  # check the Normal probability plot as a check on the normality assumption

qqnorm(fit$residuals)
qqline(fit$residuals, col = 'red')

  # goodness of fit test of H0: normal
shapiro.test(fit$residuals)

  # to check equal variances
# install car package first
#install.packages('car')
library(car)

leveneTest(NumbVisitors, SnowType)

# to check all the pairwise contrasts
TukeyHSD(fit, conf.level = .90)

# R 5.3 Cholesterol
# Drug company compares three different drugs (A, B, C) being developed to reduced cholesterol levels
# Each drug is administered to six patients for 6 months
# After 6 months, reduction in cholesterol level is recorded for each patient
# measures of cholesterol reduction are in Cholesterol.xlsx

library(readxl)

Cholesterol <- read_excel("Cholesterol.xlsx", col_names = TRUE)

# set columns to variables to make it faster
chol_drug = Cholesterol$Drug
chol_reduction = Cholesterol$CholReduction

# print variables to make sure values are right
print(chol_drug)
print(chol_reduction)

chol_fit <-aov(chol_reduction ~ chol_drug)

# A. Do the three drugs differ?
# Based on the the F value of 40.79 (LARGE), and the p-value of the f distribution being very small
# we reject the null hypothesis that there is no relationship between the drugs and the reduction of
# cholesterol levels, and conclude that the three drugs differ in effectiveness of reducing
# cholesterol levels

summary(chol_fit)

# The means of reduction in cholesterol levels vary between the different drugs
# A = 23.67, B = 39.17, C = 12.50

print(model.tables(chol_fit, "means"))

# Same with the boxplots for each drug
boxplot(chol_reduction ~ chol_drug)

# B.  What assumptions are needed for the test?  Check these as possible.

  # (1) Random Sampling
  # (2) Stability of the process
  # (3) Since n < 30 for all three predictor variables, we have to check to see that
  #     the response variable is normally distributed within all the groups, which
  #     it is.
  # (4) We assume a common standard deviation across all of the groups

  # Residual = Actual - Category mean
  # check the Normal probability plot as a check on the normality assumption

qqnorm(chol_fit$residuals)
qqline(chol_fit$residuals, col = 'red')

  # goodness of fit test of H0: normal
shapiro.test(chol_fit$residuals)



