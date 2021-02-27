library(dplyr)
library(ggplot2)

#*** MSBA 6440 ***#
#*** Mochen Yang ***#
#*** Original code by Gordon Burtch ***#

# Analyzing Movie Rental Pricing Experiment Data

# import data into R
movie = read.csv("MovieData-Exp.csv")

# Descriptive plots: distributions of leases and prices
hist(movie$leases)
hist(movie$price)

# randomization check
# "treatment" is discount on price, we can make a dummy variable of "receiving treatment or not" to facilitate randomization check
movie = movie %>% mutate(discount = base_price - price,
                         has_discount = ifelse(discount > 0, 1, 0))
# check randomization effort on base_price and likes
t.test(likes ~ has_discount, data = movie)
t.test(base_price ~ has_discount, data = movie)
# randomization check looks OK


# Let's evaluate statistical power now.
# How big a sample we would need to detect the 20% change they hope to find?
power.t.test(n=NULL,type=c("two.sample"),power=0.8,sig.level=0.1,delta=0.1)
# sample size... 118 movies per group.
# What sort of difference we can reliably detect with our current?
power.t.test(n=118,type=c("two.sample"),power=0.8,sig.level=0.1,delta=NULL)
# Do we have sufficient sample? What's the implication / advice for management?
# No, we have a highly insufficient sample to detect the desired effect. The general advice is to collect more data.

# Let's estimate the treatment effect
m1 = lm(leases ~ has_discount, data = movie)
summary(m1)
m2 = lm(leases ~ discount, data = movie)
summary(m2)
m3 = lm(leases ~ log(discount+1), data = movie)
summary(m3)
# discount does have a positive effect on leases, but marginally significant (again, due to small sample)

# Does treatment effect vary with base price?
m4 = lm(leases ~ has_discount + base_price + has_discount*base_price, data = movie)
summary(m4)
m5 = lm(leases ~ log(discount+1) + base_price + log(discount+1)*base_price, data = movie)
summary(m5)

# What can we conclude? 
# Nothing! Don't draw conclusions from null results...

# Does treatment effect vary with movie popularity?
m6 = lm(leases ~ has_discount + likes + has_discount*likes, data = movie)
summary(m6)
m7 = lm(leases ~ log(discount+1) + likes + log(discount+1)*likes, data = movie)
summary(m7)

# What can we conclude?
# If a movie is really good, "I don't care what it costs!"
# The strength of the moderation, however, is pretty small from a practical point of view.
