# Author: Gordon Burtch and Gautam Ray
# Course: MSBA 6440
# Session: Regression Discontinuity
# Topic: RDD Example
# Lecture 8

suppressWarnings(suppressPackageStartupMessages({
library(rdrobust)
library(rdd)
library(ggplot2)
}))

# Dataset used by Lee (2008), which is a paper that talks about the "incumbency advantage" in US politics.
# If I hold a congressional seat right now, to what degree does that increase my party's chances of winning re-election?
# The discontinuity design here is based on vote share in the *last* election. Essentially, I am "assigned" to incumbency
# If I won the last election, and not if not. Whether I win an election is based on a simple majority threshold (given the two-party system)
# Usually it means I passed 50% of the vote. So, we're going to use that 50% cutoff in the last election to estimate the effect of "just barely" 
# winning last time, on winning this time (versus losing)

HouseData <-read.csv("house.csv")

# Let's define our treatment variable (0 = equal proportion of vote in last election)
HouseData$treat <- (HouseData$x>0)

# Let's run the endogenous regression first... says 35% increase in vote share due to winning last election!
# Of course we know that's wrong... 
ols <- lm(data=HouseData,y~treat)
summary(ols)

# What is this OLS actually estimating? It's a t-test comparing vote outcomes in current election between incumbents and non-incumbents.
ggplot(data=HouseData) + geom_boxplot(aes(y=y,x=treat))

# Let's try RDD now, where we condition on the relationship between y and x, to get at the effect right around the threshold.
# By using "all" the data we are implicitly using a maximum bandwidth (use all of the range of x around c)
# This says the local treatment effect is 0.11 (11% increase in vote outcome due to the discontinuity).
ols <- lm(data=HouseData,y~treat + x)
summary(ols)

# Here's a plot of what we are estimating by running this regression.
ggplot(HouseData, aes(y=y,x=x)) + geom_point(aes(col=treat+1),show.legend = FALSE) + geom_vline(xintercept=0,linetype="dashed",color="red") +
  geom_smooth(aes(group=treat,col=as.numeric(treat)),method = "lm",show.legend=FALSE)

# But we don't really believe that incumbents and prior losers are comparable "generally", so we don't trust this bandwidth value, 
# for the same reason we don't trust the OLS more generally... 
# We *might* believe the comparison is fair right around the election win threshold, however. 
# Here, we are zooming in to a 5% differential on either side of the cutoff, h = 0.05.
Pared_House <- HouseData[HouseData$x >= -0.05 & HouseData$x <= 0.05,]
ggplot(Pared_House, aes(y=y,x=x,col=as.numeric(treat))) + geom_point(show.legend = FALSE) + geom_vline(xintercept=0,linetype="dashed",color="red")
# Looks better... 

# Okay let's run our RDD regression now. Our estimate falls to about 5% with this tighter bandwidth.
house_rdd <- lm(data=Pared_House,y ~ treat + x) 
summary(house_rdd)
ggplot(Pared_House, aes(y=y,x=x)) + geom_point(aes(col=treat+1),show.legend = FALSE) + geom_vline(xintercept=0,linetype="dashed",color="red") +
  geom_smooth(aes(group=treat,col=as.numeric(treat)),method = "lm",show.legend=FALSE)


# Lets try an interaction to see if the slopes are different
house_rdd_int <- lm(data=Pared_House,y ~ treat*x) 
summary(house_rdd_int)

# Lets try a square term to see if there is any curvilinearity

Pared_House$x_sq <- Pared_House$x*Pared_House$x
house_rdd_sq <- lm(data=Pared_House,y ~ treat + x + x_sq) 
summary(house_rdd_sq)


# These days, we don't implement it all manually. 
# We use packages that implement algorithms that choose bandwidth, specification and other things for us based on statistics... 
# We probably want to use a weighting function, for example (further away from cutoff, we down-weight you)
# in tandem with the optimally chosen band-width, etc. 
# rdrobust() chooses everything for you, based on some cross-validation, etc. 
# This says that we are still over-doing it! A more accurate estimate of the effect is actually about just 6%. 
House_Robust_RDD <- rdrobust(HouseData$y,HouseData$x,c=0)
summary(House_Robust_RDD)
rdplot(HouseData$y,HouseData$x)

# It can't "fix" self-selection, however, so let's again run a density check around the cut-point to evaluate self-selection ("sorting")
# the number it spits out is the p-value associated with the non-parametric test of density differences around the threshold. 
# In this case, the p-value is ~0.19, which is fairly far away from being a problem (no evidence of sorting)
DCdensity(HouseData$x,0,plot=TRUE)

