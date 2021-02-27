install.packages("MatchIt") 
install.packages("cem") 
install.packages("cobalt")
install.packages("Matching")
install.packages("rbounds")
library(MatchIt) 
library(cem) 
library(cobalt)
library(Matching)
library(rbounds)
library(data.table);library(stargazer);library(ggplot2)

#*** MSBA 6440 ***#
#*** Gordon Burtch and Gautam Ray***#
#*** Updated Feb 2020 ***#
#*** Code for Lecture 4 ***#

# Analyzing Training Program Data

# Load Data

MyData <- read.csv("TrainingProgram.csv")


#Estimate Average Treatment Effect

mean(MyData$re78[MyData$treat == 1]) - mean(MyData$re78[MyData$treat == 0])

ols.model <- lm(re78 ~ treat + age + education + black + hispanic + married + nodegree + re75 , data = MyData)

summary(lm(re78 ~ treat + age + education + black + hispanic + married + nodegree + re75 , data = MyData))

#Exact Matching

matchit(formula = treat ~ age + education + black + married + nodegree + re75 + hispanic, data = MyData, method = "exact")

exact.match <- matchit(formula= treat ~ age + education + black + married + nodegree + re75 + hispanic, data = MyData, method = "exact")

exact.data <- match.data(exact.match)

# Lets Check Covariate Balance

covs <- subset(MyData, select = -c(treat, re78))

m.out <- matchit(f.build("treat", covs), data = MyData, method = "exact")

love.plot(m.out, binary = "std", threshold = .1)

#Estimate Average Treatment Effect

exact.model <- lm(re78 ~ treat+ age + education + black + married + nodegree + re75 + hispanic, data = exact.data)

stargazer(ols.model, exact.model,title="Model with Different Types of Matches",type="text",column.labels=c("OLS Model", "Exact Matches"))


#Propensity Score Matching

PS<- glm(treat ~ age + education + black + married + nodegree + re75 + hispanic, family = "binomial", data = MyData)

summary(PS)

# No Matching

MyData$PS<-glm(treat ~ age + education + black + married + nodegree + re75 + hispanic, data=MyData, family = "binomial")$fitted.values

ggplot(MyData, aes(x = PS, color = factor(treat))) +geom_density()


#Propensity Score Matching - Nearest Match

nearest.match <- matchit(formula = treat ~ age + education + black + married + nodegree + re75 + hispanic, data = MyData, method = "nearest", distance = "logit")

matchit(formula = treat ~ age + education + black + married + nodegree + re75 + hispanic, data = MyData, method = "nearest", distance = "logit")

nearest.data <- match.data(nearest.match) 

nearest.data$PS<-glm(treat ~ age + education + black + married + nodegree + re75 + hispanic, data=nearest.data, family = "binomial")$fitted.values

ggplot(nearest.data, aes(x = PS, color = factor(treat))) +geom_density()

# Lets Check Covariate Balance

covs <- subset(MyData, select = -c(treat, re78))

m.out <- matchit(f.build("treat", covs), data = MyData, method = "nearest", distance ="logit")

love.plot(m.out, binary = "std", threshold = .1)

#Estimate Average Treatment Effect

nearest.model <- lm(re78 ~ treat + age + education + black + married + nodegree + re75 + hispanic, data = nearest.data)

stargazer(exact.model, nearest.model,title="Model with Different Types of Matches",type="text",column.labels=c("Exact Matches","PSM - Nearest" ))


#Propensity Score Matching - Caliper

caliper.match <- matchit(formula = treat ~ age + education + black + married + nodegree + re75 + hispanic, data = MyData, distance = "logit", method = "nearest", caliper = 0.001)

matchit(formula = treat ~ age + education + black + married + nodegree + re75 + hispanic, data = MyData, distance = "logit", method = "nearest" , caliper = 0.001)

caliper.data <- match.data(caliper.match) 

caliper.data$PS<-glm(treat ~ age + education + black + married + nodegree + re75 + hispanic, data=caliper.data, family = "binomial")$fitted.values

ggplot(caliper.data, aes(x = PS, color = factor(treat))) +geom_density()

# Lets Check Covariate Balance

covs <- subset(MyData, select = -c(treat, re78))

m.out <- matchit(f.build("treat", covs), data = MyData, distance ="logit", method = "nearest", caliper = 0.001)

love.plot(m.out, binary = "std", threshold = .1)

#Estimate Average Treatment Effect

caliper.model <- lm(re78 ~ treat + age + education + black + married + nodegree + re75 + hispanic, data = caliper.data)

stargazer(nearest.model, caliper.model, title="Model with Different Types of Matches",type="text",column.labels=c("Nearest Matching","Caliper Matching" ))

#---Runs	the	sensitivity	test	based	on	the	matched	sample	using	Wilcoxon's	rank	sign	

Match	<- Match(Y=MyData$re78,	Tr=MyData$treat,	X=PS$fitted,	replace=FALSE)
psens(Match,	Gamma	= 2,	GammaInc	= 0.1)



# Coarsend Exact Matching

# Automatic Coarsend Exact Matching

autocem.match <- matchit(formula = treat ~ age + education + black + married + nodegree + re75 + hispanic, data = MyData, method = "cem")

matchit(formula = treat ~ age + education + black + married + nodegree + re75 + hispanic, data = MyData, method = "cem")

autocem.data <- match.data(autocem.match)


autocem.data$PS<-glm(treat ~ age + education + black + married + nodegree + re75 + hispanic, data=autocem.data, family = "binomial")$fitted.values

ggplot(autocem.data, aes(x = PS, color = factor(treat))) +geom_density()

#Lets Check Covariate balance

m.out <- matchit(f.build("treat", covs), data = autocem.data, method = "cem")

love.plot(m.out, binary = "std", threshold = .1)



autocem.model <- lm(re78 ~ treat + age + education + black + married + nodegree + re75 + hispanic, data = autocem.data)

stargazer(exact.model, nearest.model, autocem.model, title="Model with Different Types of Matches",type="text",column.labels=c("Exact Matches","PSM - Nearest", "Auto CEM" ))


# User Specified Coarsend Exact Matching

re75cut <- seq(0, max(MyData$re75), by=1000) 
agecut <- c(20.5, 25.5, 30.5,35.5,40.5)
educut <- c(0, 6.5, 8.5, 12.5, 17)

my.cutpoints <- list(re75=re75cut, age=agecut, education = educut)

usercem.match <- matchit(treat ~ age + education + black + married + nodegree + re75 + hispanic, data = MyData, method = "cem", cutpoints = my.cutpoints)

summary(usercem.match)$nn 

usercem.data <- match.data(usercem.match) 

usercem.data$PS<-glm(treat ~ age + education + black + married + nodegree + re75 + hispanic, data=usercem.data, family = "binomial")$fitted.values

ggplot(usercem.data, aes(x = PS, color = factor(treat))) +geom_density()

#Let's check Covariate Balance

m.out <- matchit(f.build("treat", covs), data = usercem.data, method = "cem")

love.plot(m.out, binary = "std", threshold = .1)

#Estimate Average Treatment Effect

usercem.model <- lm(re78 ~ treat + age + education + black + married + nodegree + re75 + hispanic, data = usercem.data)

stargazer(nearest.model, autocem.model, usercem.model, title="Model with Different Types of Matches",type="text",column.labels=c("PSM - Nearest", "Auto CEM", "User CEM"))




