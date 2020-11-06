
library(data.table);library(stargazer);library(ggplot2);library(MESS)

#*** MSBA 6440 ***#
#*** Gordon Burtch and Gautam Ray***#
#*** Updated Feb 2020 ***#
#*** Code for Lecture 3 ***#

# Analyzing Movie Rental Pricing Experiment Data

#*** Load Dataset ***#
MyData<- read.csv("MovieData-Exp.csv")
View(MyData)

# Descriptive statistics / plots...
hist(MyData$leases)
hist(MyData$price)

# Let's make a treatment dummy to keep things simple for now. 
# This helps us do some easy randomization checks.
# Let's also construct the discount variable.
MyData$disc <- MyData$base_price - MyData$price
summary(MyData[MyData$disc>0,]$disc)
MyData$treated <- (MyData$disc > 0)

# Let's check randomization...
t.test(likes~treated,data=MyData)
t.test(base_price~treated,data=MyData)

# Let's evaluate statistical power now.
# Do we have enough data? Remember, we have 0.5 leases per movie-week on average prior 
# to the experiment taking place, for this set of customers. 
# Management wants to know about a 20% increase with 90% confidence.
# Thus, we need to detect an increase of 0.10 leases per movie in the week of the experiment.
# That is, 0.50 * 20% = 0.10. This is our delta parameter.
# 90% confidence implies an alpha of 0.10 (1 - 0.9 = 0.1).
# We assume a power of 80% absent other information.

# The first power test tells us what sort of difference we can reliably detect with our current
# sample size... 118 movies per group.
power_t_test(n=118,type=c("two.sample"),alternative="two.sided",power=0.8,sig.level=0.1,delta=NULL)
# The second tells how big a sample we would need to detect the 20% change they hope to find.
power_t_test(n=NULL,type=c("two.sample"),alternative="two.sided",power=0.8,sig.level=0.1,delta=0.1)

# Note: we appear to be heavily underpowered to detect the effect management is looking for. 
# I would thus caution management about reading too much into results from this experiment. 
# I might even advise repeating it with the bigger, requisite sample.

# That said, moving on... 
# Let's estimate the treatment effect. 

#*** OLS of leases on price and log(price) ***#
ols <- lm(leases ~ price, data = MyData) 
olslog <- lm(leases ~ log(price), data = MyData) 
stargazer(ols,olslog,title="OLS leases on prices and log(price)",type="text",column.labels=c("price","log(price)"))

#*** OLS of leases on price and log(price) with additional controls***#
olslogcontrols <- lm(leases ~ log(price) + log(likes), data = MyData) 
stargazer(ols,olslog,olslogcontrols,title="OLS leases on prices, log(price) and controls",type="text",column.labels=c("price","log(price)","with controls"),omit.labels = c("yr dummies"),omit = "factor[(]year_release[)]",omit.yes.no = c("Yes","No"))

# Hmmm... something is wrong!
# WAIT!!! We can't just look at price... 
# Not all of the variation in price is from our experiment!
# The variation across movies in base-price is endogenous... 
# We need to focus just on the price discount treatment itself...
t.test(leases~treated, data=MyData)
ols_treat <- lm(leases ~ treated, data = MyData) 
ols_log_discount <- lm(leases ~ log(disc+1), data = MyData) 

# Does a positive coefficient make sense? Yes, discount is amount of money removed from price.
stargazer(ols_treat,ols_log_discount,type="text",column.labels=c("Binary","Log Discount"))

# What sort of heterogeneity might we look at here? And how? 
# Let's check out base price.
ols_moderated_base <- lm(leases ~ treated*base_price, data=MyData)
ols_log_disc_moderated_base <- lm(leases ~ log(disc+1)*base_price, data=MyData)
stargazer(ols_moderated_base,ols_log_disc_moderated_base, type="text",column.labels=c("Treated Moderatedy by Base Price", "Disc Moderated by Base Price"))

# Why does the treatment effect disappear? Because it's the effect of treatment when 
# base price = 0... this never actually occurs in the data!
# Let's shift the base price variable so it is mean 0.
# Then, the coefficient on treatment's main effect reflects treatment on the average movie.
MyData$log_base_price_demean <- log(MyData$base_price)-mean(log(MyData$base_price))
ols_moderated_dm <- lm(leases ~ treated*log_base_price_demean, data=MyData)
ols_log_disc_moderated_dm <- lm(leases ~ log(disc+1)*log_base_price_demean, data=MyData)
stargazer(ols_moderated_dm,ols_log_disc_moderated_dm, type="text",column.labels=c("Base Price Moderator De-Meaned"), "Log Disc Base Price Moderated De-Meaned")

# Nope, the effect doesn't seem to be moderated by baseline price. 
# You can try it with a log transformation and you'll come to the same conclusion.
# What can we conclude? 
# Nothing! Don't draw conclusions from null results...

# Try doing the same thing with likes... 
MyData$likes_demean <- MyData$likes-mean(MyData$likes)
ols_moderated_likes_dm <- lm(leases ~ treated*likes_demean, data=MyData)
ols_log_disc_moderated__likes_dm <- lm(leases ~ log(disc+1)*likes_demean, data=MyData)
stargazer(ols_moderated_likes_dm,ols_log_disc_moderated__likes_dm, type="text",column.labels=c("Like Moderator De-Meaned", "Log Price, Like Moderator De-Mean"))

# We do find that popular movies respond less strongly to the discount treatment.
# This makes some sense... if a movie is really good, "I don't care what it costs!"
# The strength of the moderation is pretty weak, however, in practical terms...
# We are going out to many significant digits... you can try the log transform here, 
# But a better option might also be to just rescale the variable (e.g., 1,000's of likes)

MyData$likes_demean <- MyData$likes/1000000-mean(MyData$likes/1000000)
ols_moderated_likes_dm <- lm(leases ~ treated*likes_demean, data=MyData)
ols_log_disc_moderated__likes_dm <- lm(leases ~ log(disc+1)*likes_demean, data=MyData)
stargazer(ols_moderated_likes_dm,ols_log_disc_moderated__likes_dm, type="text",column.labels=c("Like Moderator De-Meaned", "Log Disc, Like Moderator De-Mean"))

