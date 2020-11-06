#*** Mochen Yang ***#
#*** Modified Original Script by Gordon Burtch ***
#*** Propensity Score Matching ***#

library(dplyr)
library(ggplot2)
library(MatchIt)

# import data
data = read.csv("TSTV-Obs-Dataset.csv")

# Data Exploration
# When does the treatment begin?
# This is recorded by the "after" variable
min(data$week)
max(data$week)
min(data %>% filter(after==1) %>% select(week))

# How many and what proportion of customers were treated with TSTV?
# This is recorded by the "premium" variable
data %>% filter(premium == 1) %>% select(id) %>% unique() %>% nrow()
data %>% filter(premium == 0) %>% select(id) %>% unique() %>% nrow()

#How are the viewership variables distributed?
hist(data$view_time_total_hr)
hist(data$view_time_live_hr)
hist(data$view_time_tstv_hr)


# Let's just look at what is going on with average viewership behavior for treated vs. untreated, in the weeks around the treatment date.
# Create aggregated viewership data by averaging across households in the same group
week_ave = data %>% group_by(week, premium) %>%
  summarise(ave_view_total = mean(view_time_total_hr),
            ave_view_live = mean(view_time_live_hr),
            ave_view_tstv = mean(view_time_tstv_hr)) %>% ungroup()

# plot for total TV time
ggplot(week_ave, aes(x = week, y = ave_view_total, color = factor(premium))) + 
  geom_line() + 
  geom_vline(xintercept = 2227, linetype='dotted') + 
  ylim(0, 6) + xlim(2220,2233) + 
  theme_bw()

# plot for live TV time
ggplot(week_ave, aes(x = week, y = ave_view_live, color = factor(premium))) + 
  geom_line() + 
  geom_vline(xintercept = 2227, linetype='dotted') + 
  ylim(0, 6) + xlim(2220,2233) + 
  theme_bw()

# plot for TSTV time
ggplot(week_ave, aes(x = week, y = ave_view_tstv, color = factor(premium))) + 
  geom_line() + 
  geom_vline(xintercept = 2227, linetype='dotted') + 
  ylim(0, 6) + xlim(2220,2233) + 
  theme_bw()


# Propensity Score Matching

#For this demonstration, we will use data from the pre-period for matching, then estimate the effect of TSTV gifting in the post period.

# create a dataset of before vs. after for convenience
data_summary = data %>% group_by(id, after) %>%
  summarise_all(mean) %>% ungroup()

# Check covariance balancing with t.test
data_pre = data_summary %>% filter(after == 0)
t.test(view_time_total_hr ~ premium, data = data_pre)

# Let's see what propensity scores distribution look like 
PScore = glm(premium ~ view_time_total_hr, data = data_pre, family = "binomial")$fitted.values
data_pre$PScore = PScore
ggplot(data_pre, aes(x = PScore, color = factor(premium))) +
  geom_density()

# Perform Matching
# Note: the matchit command may take a long time to run with large datasets
match_output <- matchit(premium ~ view_time_total_hr, data = data_pre, method = 'nearest', distance = "logit", caliper = 0.001, replace = FALSE, ratio = 2)
summary(match_output)
data_match = match.data(match_output)

# Evaluate covariance balance again, after matching
t.test(view_time_total_hr ~ premium, data = data_match)
ggplot(data_match, aes(x = PScore, color = factor(premium))) +
  geom_density()


#Now let's estimate the treatment effect with vs. without matching.
data_post = data_summary %>% filter(after == 1)

model_unmatch = lm(log(view_time_total_hr+1)~ premium, data = data_post)
summary(model_unmatch)

model_match = lm(log(view_time_total_hr+1)~ premium, data = data_post %>% filter(id %in% data_match$id))
summary(model_match)

# What difference do you see, with and without matching?


# Sensitivity checks:
# 1. change caliper to 0.005
# 2. match with replacement
# 3. match 1 treated unit with 2 control units