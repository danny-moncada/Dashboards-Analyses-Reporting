
# install.packages('pscl', repos='http://cran.us.r-project.org')

library(readxl)
library(pscl)
library(ggplot2)

perform <- read_excel("Performance.xlsx", na = "NA", col_names = TRUE)
attach(perform)

head(perform)
tail(perform)

# A.  Conduct a logistic regression using Group as the response variable

modelfit <- glm(Group ~ Test1 + Test2, family = binomial)
summary(modelfit)

print(pR2(modelfit))

# B. Does the model indicate a relationship between success and the two tests?  Do both tests contribute to explaining performance?
# Yes, the model indicates a relationship between success and the two tests.  However, only test 1 is a valid predictor; test2 does 
# not really factor into success

boxplot(Test1 ~ Group)

boxplot(Test2 ~ Group)

print(range(Test1))
print(range(Test2))

modelfit <- glm(Group ~ Test1, family = binomial)
xtest1 <- seq(75, 100, 1)
ytest1 <- predict(modelfit, list(Test1 = xtest1),type="response")

plot(Test1, Group, pch = 16, xlab = "Test1 Scores", ylab = "Group")
lines(xtest1, ytest1, col="red")

modelfit2 <- glm(Group ~ Test2, family = binomial)
xtest2 <- seq(65, 100, 1)
ytest2 <- predict(modelfit2, list(Test2 = xtest2),type="response")

plot(Test2, Group, pch = 16, xlab = "Test2 Scores", ylab = "Group")
lines(xtest2, ytest2, col="red")

# C. Use the model to estimate the probability of success for employees who score:
# 93 on Test 1 and 84 on Test 2
# 93% probability an employee will be successful if they score a 93 on Test 1 and an 84 on Test 2, if in fact the sample reflects the 
# Y = 1

Xvalues <- data.frame(Test1 = 93,  Test2 = 84)
predict(modelfit, Xvalues, type = "response")

# 84 on Test 1 and 93 on Test 2
# 44% probability an employee will be successful if they score an 84 on Test1 and a 93 on Test2

Xvalues <- data.frame(Test1 = 84,  Test2 = 93)
predict(modelfit, Xvalues, type = "response")

detach(perform)
